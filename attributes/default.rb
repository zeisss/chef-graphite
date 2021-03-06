default["graphite"]["version"]                              = "0.9.10"
default["graphite"]["storage_dir"]                          = "/opt/graphite/storage/"
default["graphite"]["carbon"]["line_receiver_interface"]    = "127.0.0.1"
default["graphite"]["carbon"]["pickle_receiver_interface"]  = "127.0.0.1"
default["graphite"]["carbon"]["cache_query_interface"]      = "127.0.0.1"
default["graphite"]["carbon"]["log_updates"]                = true
default["graphite"]["dashboard"]["timezone"]                = "UTC"
default["graphite"]["dashboard"]["memcache_hosts"]          = [ "127.0.0.1:11211" ]

# The default values template
default["graphite"]["templates"]["default"]["background"]   = "black"
default["graphite"]["templates"]["default"]["foreground"]   = "white"
default["graphite"]["templates"]["default"]["majorLine"]    = "white"
default["graphite"]["templates"]["default"]["minorLine"]    = "grey"
default["graphite"]["templates"]["default"]["lineColors"]   = "blue,green,red,purple,brown,yellow,aqua,grey,magenta,pink,gold,rose"
default["graphite"]["templates"]["default"]["fontName"]     = "Sans"
default["graphite"]["templates"]["default"]["fontSize"]     = "10"
default["graphite"]["templates"]["default"]["fontBold"]     = "False"
default["graphite"]["templates"]["default"]["fontItalic"]   = "False"

# The default values dashboard
default["graphite"]["dashboard"]["server_name"]             = "graphite"
