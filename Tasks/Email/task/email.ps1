[CmdletBinding(DefaultParameterSetName = 'None')]
param
(
	[String] [Parameter(Mandatory = $true)] $from,
	[String] [Parameter(Mandatory = $true)] $to,
    [String] [Parameter(Mandatory = $true)] $subject,
    [String] [Parameter(Mandatory = $false)] $body,
    [String] [Parameter(Mandatory = $false)] $attachments
)


 function sendMail{

     $smtpserver = Get-TaskVariable $distributedTaskContext "smtpserver"
     $port = Get-TaskVariable $distributedTaskContext "port"
     $username = Get-TaskVariable $distributedTaskContext "username"
     $password = Get-TaskVariable $distributedTaskContext "password"
     $enableSSL = Get-TaskVariable $distributedTaskContext "enableSSL"

     Write-Host (Get-LocalizedString -Key 'smtpserver: {0}...' -ArgumentList $smtpServer)
     Write-Host (Get-LocalizedString -Key 'port: {0}...' -ArgumentList $port)
     Write-Host (Get-LocalizedString -Key 'username: {0}...' -ArgumentList $username)
     Write-Host (Get-LocalizedString -Key 'password: {0}...' -ArgumentList $password)
     Write-Host (Get-LocalizedString -Key 'enableSSL: {0}...' -ArgumentList $enableSSL)
     
     #Creating a Mail object
     $msg = new-object Net.Mail.MailMessage
     
    #Creating SMTP server object
     $smtp = new-object Net.Mail.SmtpClient($smtpServer)
     $smtp.EnableSSL = $enableSSL

     #Email structure 
     $msg.From = $from
     $msg.ReplyTo = $from
     
    ForEach($toe in $to.Split(','))
    {
        $msg.To.Add($toe.Trim())
        
        Write-Host (Get-LocalizedString -Key 'To: {0}...' -ArgumentList $toe)
    } 
     
     $msg.subject = $subject
     $msg.body = $body 
     
     if (![string]::IsNullOrEmpty($username) -and ![string]::IsNullOrEmpty($password))
     {
        $smtp.Credentials = New-Object System.Net.NetworkCredential($username, $password);
        
         Write-Host  'Credentials used'
     }


     #Attachments
       $attFiles = New-Object "System.Collections.Generic.List[Net.Mail.Attachment]"
      if (![string]::IsNullOrEmpty($attachments)) 
      {
 
        ForEach($file in $attachments.Split(','))
            {          
                if ( (Test-Path $file) -eq $true )
                {
                    Write-Host (Get-LocalizedString -Key 'Adding Attachment: {0}...' -ArgumentList $file)
                    $att = new-object Net.Mail.Attachment($file)
                    $msg.Attachments.Add($att)
                    
                    $attFiles.Add($att)
                }    
                else
                {
                    Write-Host (Get-LocalizedString -Key 'Attachment Not Found: {0}...' -ArgumentList $file)       
                }                
            }
      }
     
 
     #Sending email 
     $smtp.Send($msg)
     Write-Host  'Email Sent!'
  
     if ($attFiles.Count -gt 0)
     {
        Write-Host 'Disposing Mail Attachments'
          
        ForEach($att in $attFiles)
        {
            $att.Dispose()
        } 
     } 
     
     $smtp.Dispose()
}

sendMail