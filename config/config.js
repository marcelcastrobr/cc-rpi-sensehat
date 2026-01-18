/* MagicMirror Config - Kongsberg, Norway */
let config = {
	address: "localhost",
	port: 8080,
	basePath: "/",
	ipWhitelist: ["127.0.0.1", "::ffff:127.0.0.1", "::1"],

	useHttps: false,
	httpsPrivateKey: "",
	httpsCertificate: "",

	language: "nb",
	locale: "nb-NO",

	logLevel: ["INFO", "LOG", "WARN", "ERROR"],
	timeFormat: 24,
	units: "metric",

	modules: [
		{
			module: "alert",
		},
		{
			module: "updatenotification",
			position: "top_bar"
		},
		{
			module: "clock",
			position: "top_left"
		},
		{
			module: "calendar",
			header: "Norske helligdager",
			position: "top_left",
			config: {
				calendars: [
					{
						fetchInterval: 7 * 24 * 60 * 60 * 1000,
						symbol: "calendar-check",
						url: "https://www.officeholidays.com/ics/norway"
					}
				]
			}
		},
		{
			module: "compliments",
			position: "lower_third"
		},
		{
			module: "weather",
			position: "top_right",
			config: {
				weatherProvider: "openmeteo",
				type: "current",
				lat: 59.6691,
				lon: 9.6522
			}
		},
		{
			module: "weather",
			position: "top_right",
			header: "Værmelding",
			config: {
				weatherProvider: "openmeteo",
				type: "forecast",
				lat: 59.6691,
				lon: 9.6522
			}
		},
		{
			module: "newsfeed",
			position: "bottom_bar",
			config: {
				feeds: [
					{
						title: "NRK Nyheter",
						url: "https://www.nrk.no/toppsaker.rss"
					},
					{
						title: "VG",
						url: "https://www.vg.no/rss/feed"
					}
				],
				showSourceTitle: true,
				showPublishDate: true,
				broadcastNewsFeeds: true,
				broadcastNewsUpdates: true
			}
		},
		{
			module: "netatmo",
			position: "bottom_left",
			header: "Netatmo",
			config: {
				clientId: "YOUR_NETATMO_CLIENT_ID",
				clientSecret: "YOUR_NETATMO_CLIENT_SECRET",
				refresh_token: "YOUR_NETATMO_REFRESH_TOKEN"
			}
		},
		{
			module: "MMM-Tibber",
			position: "top_center",
			header: "Tibber",
			config: {
				tibberToken: "YOUR_TIBBER_TOKEN",
				homeId: "YOUR_TIBBER_HOME_ID"
			}
		},
		{
			module: "MMM-Fintech",
			position: "bottom_right",
			header: "Aksjer",
			config: {
				showLastUpdated: true,
				showPricePerUnit: true,
				showQuantity: false,
				currency: "USD",
				sortBy: "name"
			}
		},
	]
};

/*************** DO NOT EDIT THE LINE BELOW ***************/
if (typeof module !== "undefined") { module.exports = config; }
