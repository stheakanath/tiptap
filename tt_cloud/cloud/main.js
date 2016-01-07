ACCURACY_RADIUS = 0.01; //km
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
Parse.Cloud.define("hello", function(request, response) {
  response.success("Hello world!");
});

Parse.Cloud.define("attemptTransaction", function(request, response) {
	var u1_gpoint = new Parse.GeoPoint(request.params.lat, request.params.lng);
	var u1_shake_time = request.params.shake_time;
	var u1_amnt = request.params.tip_amnt
	var active_user_query = new Parse.Query("Parse.User")
	// first, get all active users.
	active_user_query.equalTo("isOnline", true);
	active_user_query.find({
		success: function(results) {
			console.log("Transaction attempted. Found " + results.length + " active users.");
			var geofiltered_matches = [];
			// then, find all the people who are within 10m (1000m in 1 km -> 0.01 km = 10 m)
			for (user in results) {
				var other_geopoint = user.get("gps");
				var dist = u1_gpoint.kilometersTo(other_geopoint);
				if (dist <= ACCURACY_RADIUS) {
					geofiltered_matches.push(user);
				}
			}
			if (geofiltered_matches.length == 0) {
				var status = "No users were found in your area who have the app open.";
				response.error(status);
			} else {
				var final_matches = [];
				// commented out this leniency rule. if shaking is too inaccurate, we will use this heuristic.
				// if (geofiltered_matches.length == 1) {
				// 	response.success(geofiltered_matches);
				// }
				for (user in geofiltered_matches) {
					if (user.get("isShaking") == true) {
						final_matches.push(user);
					}
				}
				if (final_matches.length == 0) {
					var status = "We see other users in your area, but they do not seem to be shaking. Please try again.";
					response.error(status);
				} else {
					response.success(final_matches);
				}
			}
		},
		error: function() {
			var err = "No other active users found. Please close app, open, and try again.";
			response.error(err);
		}
	});
});

Parse.Cloud.define("setShake", function(request, response) {
	var p_query = Parse.Query("Parse.User");
	var shake_setting = false;
	if (request.params.shake == "true") {
		shake_setting = true;
	}
	p_query.get(request.params.obj_id, {
		success : function(results) {
			if (results.length > 1) {
				status = "More than 1 ID. Your ID is incorrect.";
				response.error(status);
			} else {
				var user = results[0];
				user.set("isShaking", shake_setting);
				user.save();
			}
		}
	})
});