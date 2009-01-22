<?


session_start();
if($_GET['pin']=="123frytki"){
	$_SESSION['logged'] = true;
	header("Location: index.php");
	exit;
} else {
	unset($_SESSION['logged']);
	header("Content-Type: text/html; charset=utf-8");
}

?>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xml:lang="en" xmlns="http://www.w3.org/1999/xhtml" lang="en"><head>

    
    	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    	<meta name="viewport" content="width = 710">
    	
    	    	
    
    	    	
    	    	
    	<link rel="stylesheet" type="text/css" href="login_pliki/global.css">
    	
    	    	
    	    	
    	    	
    	<title>Log in @ zaQpki</title>
    </head><body id="account_login" onload="document.getElementById('pin').focus();">    
        <div id="container">
            <div id="header">
<a href="http://zaqpki.unl.pl/"><img src="login_pliki/zaqpki.png" id="logo"></a>
                <div id="nav">
                                            <a>zaQpki... clean up your business</a>
                                    </div>
                <div id="new_post_notice_container"></div>
                <div id="content_tab">
                                            <a style="font-size: 90%;">get ready</a>
                                        
                    <img src="login_pliki/content_tab_left_2.png" id="content_tab_left" alt="">
                </div>
            </div>
            <div id="content_container">
                <div id="content">
                    
<form action="login.php" method="get" class="account_form">
    <h1>
        Log in
   </h1>

    <label for="pin" style="margin: 30px 0px 3px; display: block;">Personal Identification Number</label>
    <input name="pin" id="pin" class="text_field huge wide" type="password">

    <div style="margin-top: 30px;">
        <a style="color: rgb(155, 171, 180); float: right; font-size: 14px; padding-top: 11px;">Don't forget your password!</a>
        
        <input value="Log in" class="big_button" style="margin-right: 15px;" type="submit">
    </div>
    
    </form>                </div>
                
                <div id="footer">
                    <strong>(c) zaQpki, Inc.</strong>
                    <a>Help</a>
                    <a>What's New</a>
                    <a>Developers</a>
                    <a>Content Policy</a>
                    <a>Terms of Service</a>
                    <a>Privacy Policy</a>
                </div>
            </div>
        </div>
        
        <script src="login_pliki/urchin.js" type="text/javascript">
        </script>
        <script type="text/javascript">
            _uacct = "UA-97144-8";
            urchinTracker();
        </script>
    </body></html>