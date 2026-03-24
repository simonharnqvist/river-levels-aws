resource "aws_glue_catalog_table" "raw_stations" {
  name          = "raw_stations"
  database_name = "RiverData"

  storage_descriptor {
    
    columns {
        name = "station_no"
        type = "number"
        }

    columns {
        name = "station_name"
        type = "string"
        }

    columns {
        name = "river_name"
        type = "string"
        }
    }
}

    

resource "aws_glue_catalog_table" "raw_timeseries" {
  name          = "raw_timeseries"
  database_name = "RiverData"

  storage_descriptor {
    columns {
        name = "station_name"
        type = "string"
    }
    columns {
        name = "station_no"
        type = "number"
    }
    columns { 
        name = "station_id"
        type = "number"
    }
    columns {
        name = "ts_id"
        type = "number"
    }
    columns {
        name = "ts_name"
        type = "string"
    }
    columns { 
        name = "parametertype_id"
        type = "number"
    }
    columns {
        name = "parametertype_name"
        type = "string"
    }
  }
}

resource "aws_glue_catalog_table" "stations_ts" {
  name          = "stations_ts"
  database_name = "RiverData"

  storage_descriptor {
    columns {
      name = "station_id"
      type = "number"
    }

    columns {
      name = "station_name"
      type = "string"
    }

    columns {
      name = "river_name"
      type = "string"
    }

    columns {
      name = "ts_id"
      type = "number"
    }

    columns {
      name = "ts_name"
      type = "string"
    }
  }
}