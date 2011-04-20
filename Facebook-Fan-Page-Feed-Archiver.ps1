#Facebook Fan Page Archiving Script
#
#   Created by City of Bellingham, WA (http://www.cob.org)
#   Version .6 (beta)
#	Last modified 7/13/2010 by Josh Nylander, Steven Niedermeyer, and Dan Smith
#	
#	This script is designed to harvest new or modified wall posts, including
#   associated comments, from a Facebook fan page.  Downloaded data  
#	is stored as JSON files.  No de-duplication or conversion
#	is performed.
#
#Modify the script input values below
# 
#Script inputs
[string] $source_id = 'TODO' #Facebook fan page ID
[string] $app_id = 'TODO' #Facebook application ID
[string] $app_secret = 'TODO' #Facebook application secret
[string] $path = 'C:\temp' #Path to save files to (e.g. c:\temp or \\server\share\directory)
[int] $minutesback = 60 * 24 * 3 #Number of minutes back to check for new or updated posts (including new comments).
						#When first running, 60 * 24 * X where X is the number of days since you started your fanpage or oldest post
						#Then reset to the frequency that you run the script.

#Prepare environment
$wc = new-object System.Net.WebClient

#Calculate UNIX date to use, in seconds
[datetime] $check_date = (get-date).AddMinutes(-1 * $minutesback)
[datetime] $unix_start_date = [System.TimeZoneInfo]::ConvertTimeToUtc((Get-Date -Date '1/1/1970'))
$unixtimespan = New-TimeSpan -Start $unix_start_date -End $([System.TimeZoneInfo]::ConvertTimeToUtc($check_date))
[int] $time_value = [System.Convert]::ToInt32($unixtimespan.TotalSeconds)

#Get an Access Token
[string] $url = "https://graph.facebook.com/oauth/access_token?type=client_cred&client_id=$app_id&client_secret=$app_secret"
[string] $access_token = $wc.DownloadString($url)
$access_token = $access_token.Replace("access_token=", "")

#Build query URL
[string] $url = ''
[string] $resultText = ''
$url = "https://api.facebook.com/method/fql.query?query=SELECT%20post_id%20FROM%20stream%20WHERE%20source_id%20%3D%20$source_id%20AND%20updated_time%20%3E%20$time_value&access_token=$access_token&format=xml"

#Run query and load resulting XML
[System.Xml.XmlDocument] $xd = new-object System.Xml.XmlDocument
$resultText = $wc.DownloadString($url)
$xd.LoadXML($resultText)

#Get the stream_post nodes
$nodelist = $xd.ChildNodes.Item(1).ChildNodes
Write-Output ('Total: ' + $nodelist.Count)

#Iterate through the nodes, retrieving post_id and then downloading the post
foreach ($post in $nodelist) {
  $post_id = $post.FirstChild.InnerText
  Write-Output "Found $post_id as having been updated"
  $url_post = "https://graph.facebook.com/$post_id/?access_token=$access_token"
  $fileName = $path + '\' + $post_id + '-' + (Get-Date -Format yyyyMMddHHmm) + '.json'
  try
	{
		$wc.DownloadFile($url_post,$fileName)
	} catch
	{
		'{"error:"' + $_.Exception.Message | Out-File ($fileName + '.err');
		$url_post = ''
		$resultPost = ''
		Write-Output "Error writing $post_id"
	}
}