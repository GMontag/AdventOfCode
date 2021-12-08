$in = "yzbqklnj"

$salt = 0

$md5 = new-object -TypeName System.Security.Cryptography.MD5CryptoServiceProvider
$utf8 = new-object -TypeName System.Text.UTF8Encoding
$fivezeroes = $false
$sixzeroes = $false

while (-not ($fivezeroes -and $sixzeroes) ) {
	$hash = [System.BitConverter]::ToString($md5.ComputeHash($utf8.GetBytes($in + $salt.ToString())))
	$hash = $hash.Replace('-','')
	if ($hash -like "00000*") { Write-Host "Five zeroes is $salt"; $fivezeroes = $true }
	if ($hash -like "000000*") { Write-Host "Six zeroes is $salt"; $sixzeroes = $true }
	$salt++
}