<?php
# vi: ts=4 noexpandtab

// set DH_API_KEY to your key (per https://panel.dreamhost.com/?tree=home.api)
// probably should limit this key to dns modifications only
$DH_API_KEY="PFBKVK3THLE4NDZ7";
// set HOSTS to contain an array of fields that can be modified
// only entries in this list will be updated
$HOSTS=array("sweyn.cceckman.com", "richard.cceckman.com");
// set a password.  If you wish to restrict this, set a password here
// and then pass make your url request to include 'passwd' key
// set to "" if you do not wish to have a password
$PASSWD="uxD5w96VqKoI1ndQol8C";

$APP_NAME="my-dhdyndns";
$DH_API_BASE="https://api.dreamhost.com/";

function dh_request($cmd,$aargs=false) {
	global $DH_API_BASE, $DH_API_KEY, $APP_NAME;
	$base=$API_BASE;
	$id=uniqid($APP_NAME);

	$args="?key=$DH_API_KEY&cmd=$cmd&format=json";
	$args.="&unique_id=" . uniqid($APP_NAME);
	if(is_array($aargs)) {
		foreach($aargs as $key => $val) {
			$args.="&" . urlencode($key) . "=" . urlencode($val);
		}
	}

	$url=$DH_API_BASE . $args;
	$curl_handle=curl_init();
	curl_setopt($curl_handle,CURLOPT_URL,$DH_API_BASE . $args);
	curl_setopt($curl_handle,CURLOPT_CONNECTTIMEOUT,5);
	curl_setopt($curl_handle,CURLOPT_RETURNTRANSFER,1);
	$buffer = curl_exec($curl_handle);
	curl_close($curl_handle);

	if (empty($buffer)) {
    	return(false);
	} else {
    	return(json_decode($buffer,true));
	}
}
function fail($str) {
    $from = 'From: CCEckman DNS systems <system@cceckman.com>';
    if((strpos($str, "success") === FALSE) && ( strpos($str, "correct") === FALSE)){
        printf("error: %s",$str);
        $msg = sprintf( <<<HRD
        The DomainSite server encountered a failure when attempting a DNS update.
        Attempted host: %s
        Attempted IP:   %s
        Comment:        %s
        Time:           %s
        Error:          %s
        Hope this helps in debugging.

        -Charles
HRD
        , $_REQUEST["host"]
        , $_REQUEST["ip"]
        , $_REQUEST["comment"]
        , date(DATE_RFC822)
        , $str
    );
        $subject = "Error in DNS Update";
        $send_alert = TRUE;
    }else{

        $msg = sprintf( <<<HRD
        The DomainSite server performed a DNS update.
        Attempted host: %s
        Attempted IP:   %s
        Comment:        %s
        Time:           %s
        Message:        %s
        Hope this helps in debugging.

        -Charles
HRD
        , $_REQUEST["host"]
        , $_REQUEST["ip"]
        , $_REQUEST["comment"]
        , date(DATE_RFC822)
        , $str
    );
        printf("%s",$str);
        $subject = "DNS Update";
        $send_alert = TRUE;
    }
    if($send_alert === TRUE){
        mail("spiwaterwing@gmail.com", $subject, $msg, $from);
    }
    exit(false);
}
function bad_input() {
	fail("invalid input\n");
}

$passwd=$_REQUEST["passwd"];
$host=$_REQUEST["host"];
$addr=$_REQUEST["ip"];
$comment=$_REQUEST["comment"];

//echo "DBG0\n";

if($PASSWD != $passwd) { bad_input(); }
//echo "DBG0.1\n";
if(!in_array($host,$HOSTS)) { bad_input(); }

//echo "DBG1\n";

if(!$DH_API_KEY) {
	$DH_API_KEY=$_REQUEST["key"];
	if(!$DH_API_KEY) { bad_input(); }
}

if(!$addr) { $addr=$_SERVER["REMOTE_ADDR"]; }

$ret=dh_request("dns-list_records");
if($ret["result"] != "success") {
	fail("failed list records\n");
	return(1);
}
$found=false;
foreach($ret["data"] as $key => $row) {
	if($row["record"] == $host) {
		if($row["editable"] == 0) {
			fail("error: $host not editable");
		}
		if($row["type"] != "A") {
			fail("error: $host not a A record");
		}
		$found=$row;
	}
}

if($found) {
	if($addr==$found["value"]) {
		printf("record correct: %s => %s\n", $found["record"], $addr);
		return(0);
	}
	$ret=dh_request("dns-remove_record",
		            array("record" => $found["record"],
					      "type" => $found["type"],
						  "value" => $found["value"]));
	if($ret["result"] != "success") {
		fail("failed to remove record\n");
		return(1);
	}
	$record=$found["record"];
	$type=$found["type"];
	printf("deleted %s. had value %s\n", $record,$found["value"]);
} else {
	$record=$host;
	$type='A';
}

$ret=dh_request("dns-add_record",
                array("record" => $record,
                      "type" => $type,
                      "value" => $addr,
					  "comment" => $comment));

if($ret["result"] != "success") {
	fail(sprintf("%s\n\t%s\n",
	             "failed to add $record of type $type to $addr", $ret["data"]));
	return(1);
}

// Actually an alert
fail(sprintf("success: set %s to %s\n", $record, $addr));

?>
