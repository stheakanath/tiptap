ACCURACY_RADIUS = 1; // 1 km accuracy
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
Parse.Cloud.define("hello", function(request, response) {
  response.success("Hello world!");
});


function argmin(l) {
    var min_index = 0;
    for (var i = 1; i < l.length; i++) {
    	if (l[i] < l[min_index]) {
    		min_index = i;
    	}
    }
    return min_index;
}


Parse.Cloud.define("attemptTransaction", function(request, response) {
	// var u1_gpoint = new Parse.GeoPoint(parseFloat(request.params.lat), parseFloat(request.params.lng));
	var u1_shake_time = request.params.shake_time;
	var u1_amnt = request.params.tip_amnt;
	var u1_u_name = request.params.username;
	console.log(JSON.stringify(request.params.gps));
	var u1_gpoint = new Parse.GeoPoint(request.params.gps.latitude, request.params.gps.longitude);
	var active_user_query = new Parse.Query("_User");
	// first, get all active users.
	active_user_query.equalTo("isOnline", true);
	active_user_query.notEqualTo("username", u1_u_name);
	active_user_query.find({
		success: function(results) {
			console.log(JSON.stringify("Transaction attempted. Found " + results.length + " active users."));
			console.log(JSON.stringify(results));
			var geofiltered_matches = [];
			if (results.length == 0) {
				console.log(JSON.stringify("No results were found."));
				response.error(status);
			}
			// then, find all the people who are within 10m (1000m in 1 km -> 0.01 km = 10 m)
			var distances = [];
			for (var j = 0; j < results.length; j++) {
				console.log(JSON.stringify("Got into the results for loop"));
				var user = results[j];
				var other_geopoint = user.get("gps");
				if ((other_geopoint == undefined) || (other_geopoint == null)) {
					console.log(JSON.stringify("this object does not have a geopoint."));
					continue;
				}
				console.log(JSON.stringify(other_geopoint));
				var dist = u1_gpoint.kilometersTo(other_geopoint);
				console.log(dist);
				if (dist <= ACCURACY_RADIUS) {
					geofiltered_matches.push(user);
					distances.push(dist);
				}
			}
			console.log(JSON.stringify("Finished geofiltering"));
			if (geofiltered_matches.length == 0) {
				var status = "No users were found in your area who have the app open.";
				console.log(JSON.stringify(status));
				response.error(status);
			} else {
				var final_matches = [];
				var filtered_distances = [];
				// dummy line
				// commented out this leniency rule. if shaking is too inaccurate, we will use this heuristic.
				// if (geofiltered_matches.length == 1) {
				// 	response.success(geofiltered_matches);
				// }
				for (var i = 0; i < geofiltered_matches.length; i++) {
					var geo_user = geofiltered_matches[i];
					if (geo_user.get("isShaking") == true) {
						final_matches.push(geo_user);
						filtered_distances.push(distances[i]);
					}
				}
				if (final_matches.length == 0) {
					var status = "We see other users in your area, but they do not seem to be shaking. Please try again.";
					console.log(JSON.stringify(status));
					response.error(status);
				} else {
					console.log(JSON.stringify("Final matches found - " + final_matches.length + " potential receivers found."));
					response.success(final_matches[argmin(filtered_distances)]);
				}
			}
		},
		error: function(error) {
			console.log(JSON.stringify(error));
			var err = "No other active users found. Please close app, open, and try again.";
			response.error(err);
		}
	});
});

Parse.Cloud.define("setShake", function(request, response) {
	var p_query = new Parse.Query("_User");
	var shake_setting = false;
	if (request.params.shake == "true") {
		shake_setting = true;
	}
	var obj_id = request.params.obj_id;
	p_query.get(obj_id, {
		success : function(results) {
			if (results.length == 0) {
				var status = "No results found for " + JSON.stringify(obj_id);
				response.error(status);
			}
			if (results.length > 1) {
				status = "More than 1 ID. Your ID is incorrect.";
				response.error(status);
			} else {
				var user = results[0];
				user.set("isShaking", shake_setting);
				user.save().then(function() {
					response.success();
					});
			}
		},
		error : function(error) {
			console.log(error);
			var err = "No ID found with provided ID.";
			response.error(err);
		},
		useMasterKey : true
	});
});

Parse.Cloud.define("notifyRecipient", function(request, response) { 
	console.log(JSON.stringify("received push call"));
	var username = request.params.u_name;
	console.log(username);
	var amnt_paid = request.params.amt;
	console.log(amnt_paid);
	var pushQuery = new Parse.Query(Parse.Installation);
	var notif_string = "You were just paid " + amnt_paid + "!";
	pushQuery.equalTo("username", username);
	Parse.Push.send({
		where: pushQuery,
		data: {
			alert: notif_string,
			sound: "default"
		}}, {
			success: function() {
				console.log("SUCCESSSSSSSSS");
				response.success("success");
			},
			error: function(error) {
				console.log(JSON.stringify(error));
				response.error(error);
			}
	});
});