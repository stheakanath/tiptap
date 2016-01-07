
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
Parse.Cloud.define("hello", function(request, response) {
  response.success("Hello world!");
});

Parse.Cloud.define("attemptTransaction", function(request, response) {
	var u1_lat = request.params.lat;
	var u1_lng = request.params.lng;
	var u1_shake_time = request.params.shake_time;
	var u1_amnt = request.params.tip_amnt
	console.log(JSON.stringify(u1_lat));
	response.success();
})