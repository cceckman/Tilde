<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<?php
$titles = array(
	"An Overabundance of Vowels",
	"A Limited Number of Voxels",
	"An Insignificant Plurality",
	"A Standing Ovulation",
	"A Bee Sees Dee",
	"An Impossibly Complicated Rock",
	"A Planet of Conifers",
	"A Randomly-Selected Title",
	"A Lounging Monk",
	"A Robert Ludlum Novel",
	"A Jimmy Bedlam Film",
	"A Mouse in the House",
	"A Site of Sights",
	"A Heresy Herd",
	"A Hershey Herd",
	"A Wonderful Wonder"
);

//$titles = array("Title");
$title = $titles[rand(0, count($titles) -1)];
//echo count($titles) -1;
	?>
<title><?php echo $title; ?></title>
</head>
<body>
<p>Coming soon: Charles Eckman's home page.</p>
<?php
/*
$connect = mysql_connect("mysql.cceckman.com", 'cceckman', 't5UxmDClLZxJPZR92tVO');
mysql_select_db('cceckman',$connect);
$s = file_get_contents('cceckman.sql');
var_dump($s);
$result = mysql_query($s, $connect); 
var_dump($result);*/
?>
</body>
</html>