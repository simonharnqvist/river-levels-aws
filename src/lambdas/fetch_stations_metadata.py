import requests
import boto3
from datetime import datetime
import os
import json

s3 = boto3.client("s3")
glue = boto3.client("glue")

RAW_BUCKET = os.getenv("RAW_BUCKET")
WORKFLOW_NAME = os.getenv("STATIONS_METADATA_WORKFLOW")


BASE_URL = (
    "https://timeseries.sepa.org.uk/KiWIS/KiWIS"
    "?service=kisters&datasource=0&type=queryServices"
)


def _parse_kiwis_json(res_json):
    """
    KiWIS returns: [header_row, row1, row2, ...]
    Convert to list[dict].
    """
    if not isinstance(res_json, list) or len(res_json) < 2:
        return []

    header, *rows = res_json
    return [dict(zip(header, row)) for row in rows]


def get_stations():
    """Fetch all stations with river + name."""
    url = (
        f"{BASE_URL}"
        "&request=getStationList"
        "&returnfields=station_no,station_name,river_name"
        "&format=json"
    )
    res = requests.get(url, timeout=10)
    res.raise_for_status()

    return _parse_kiwis_json(res.json())


def get_timeseries_for_station(station_no: str):

    url = (
        f"{BASE_URL}"
        "&request=getTimeseriesList"
        "&returnfields=ts_id,ts_name,parametertype_name,station_no"
        "&format=json"
    )
    res = requests.get(url, params={"station_no": station_no}, timeout=10)
    res.raise_for_status()

    return _parse_kiwis_json(res.json())


def get_all_ts_ids():

    stations = get_stations()

    mapping = {}
    for st in stations:
        station_no = st["station_no"]
        ts_list = get_timeseries_for_station(station_no)
        mapping[station_no] = ts_list

    return mapping


def lambda_handler(event, context):
    stations = get_stations()
    ts_map = get_all_ts_ids()

    # 2. Build S3 key prefix
    ingested_date = datetime.now().strftime("%Y-%m-%d")
    stations_key = f"raw/stations/ingested_date={ingested_date}/stations.json"
    ts_key = f"raw/timeseries/ingested_date={ingested_date}/timeseries.json"

    # 3. Write raw JSON to S3
    s3.put_object(
        Bucket=RAW_BUCKET,
        Key=stations_key,
        Body=json.dumps(stations).encode("utf-8"),
        ContentType="application/json",
    )

    s3.put_object(
        Bucket=RAW_BUCKET,
        Key=ts_key,
        Body=json.dumps(ts_map).encode("utf-8"),
        ContentType="application/json",
    )

    glue.start_workflow_run(Name=WORKFLOW_NAME)

    return {
        "status": "ok",
        "stations_count": len(stations),
        "ts_map_count": len(ts_map),
        "stations_s3_key": stations_key,
        "timeseries_s3_key": ts_key,
    }
