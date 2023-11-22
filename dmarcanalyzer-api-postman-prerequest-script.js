function getTokenAndStore(){
    console.log('Requesting new token');
    pm.sendRequest(echoPostRequest, function (err, res) {
    console.log(err ? err : res.json());
        if (err === null) {
            console.log('Saving the token')
            var responseJson = res.json();
            pm.environment.set('access_token', responseJson.access_token)
    
            var expiryDate = new Date();
             console.log('Saving the expiry time:' + responseJson.expires_in)
            expiryDate.setSeconds(expiryDate.getSeconds() + responseJson.expires_in);
            pm.environment.set('expires_in', expiryDate.getTime());
        }
    });
}

const echoPostRequest = {
  url: 'https://api.dmarcanalyzer.com/login/access_token',
  method: 'POST',
  header: 'Content-Type:application/json',
  body: {
    mode: 'application/json',
    raw: JSON.stringify(
        {
        	'grant_type':'password',
            username: pm.variables.get("dmarcuser"),
        	password:pm.variables.get("dmarcpassword"),
        	'client_id':pm.variables.get("client-id"),
        	'client_secret':pm.variables.get("secret"),
        })
  }
};


var expiryBuffer = 60;

if (!pm.environment.get('expires_in') || 
    !pm.environment.get('access_token')) {
    console.log('Token or expiry date are missing')
} else if ((pm.environment.get('expires_in') - (expiryBuffer*1000)) <= (new Date()).getTime()) {
    console.log('Token is expired');
    getTokenAndStore(); // go get a new token
} else {
    var expiryTime = (pm.environment.get('expires_in') - (expiryBuffer*1000) - (new Date()).getTime())/1000
    console.log('Token and expiry date are all good. Requesting new token in: ' + expiryTime + ' seconds (Expiry buffer:' + expiryBuffer + ')');
}

