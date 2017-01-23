d_config = {
    wifis = {
        wifi_home_downstairs = "TP-LINK_A67FB4",
        wifi_home_upstairs = "JN",
        wifi_production = "IphoneLody",
        wifi_csa = "TeamCSA"
    },
    wifi = "wifi_home_downstairs",
    timeout_between_measures_in_seconds = 5, -- 5 is ok for debugging, it might be 30 for the final product
    thermometer_input_pin = 1, -- gpio5 (D1)
    thermometers_names_addresses = {
        black = "28-FF-F1-DD-33-16-03-21",
        white = "28-DE-91-C0-06-00-00-5B"
    },
    thermometers_thingspeak_fields = {}
}

d_config["thermometers_thingspeak_fields"]["black"] = "1"
d_config["thermometers_thingspeak_fields"]["white"] = "2"
