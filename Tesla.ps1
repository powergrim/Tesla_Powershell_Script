<#
.SYNOPSIS
  This script is used to call the Tesla and execute a command
.DESCRIPTION
  If you want to control your Tesla and set the temperature, stop charging or open the port. This script is a collection of functions used.
.PARAMETER temperature
  Sets the temperature of the Tesla using the conditions in this script
.PARAMETER stopcharge
  Stops charging the car and unlocks the charging port

.NOTES
  Version:        0.1
  Author:         Sander Bastiaansen (bastiaansen.xyz)
  Creation Date:  4-1-2020
  Purpose/Change: Initial script development

.EXAMPLE
  ./command-tesla.ps1 -temperature is used to set the temperature.
  ./command-tesla.ps1 -stopcharge will stop charging and unlock the chargeport
#>

# Parameters
Param(
    [switch]$temperature,
    [switch]$stopcharge,
    [switch]$honkhorn
    )

#Script Version
$sScriptVersion = "0.1"

#Start script transcript
start-transcript -path /home/pi/Tesla/log/Transcript.txt

#Script variables
$outsidetemperature = "3"

# Capture credentials
$Username = 'user'
$Password = 'password'
$pass = ConvertTo-SecureString -AsPlainText $Password -Force
$Cred = New-Object System.Management.Automation.PSCredential -ArgumentList $Username,$pass

#Open connection
Connect-Tesla -Credential $Cred -NoPersist

#Wake up vehicle
set-tesla -Command wake_up

#Get carname
$VehicleState = get-tesla -Command vehicle_state
$Carname = $VehicleState.vehicle_name
Write-Host "This car's name is $Carname"
write-host "$carname has woken up!"

if ($temperature){
#Get Tesla outside Temperature
    $temp = get-tesla -command climate_state
    $outsidetemp = $temp.outside_temp
    Write-Host "Outside temperature is $outsidetemp degrees celsius."

#Based on temperature switch on the conditioning
if($outsidetemp -le "3"){
    set-tesla -Command auto_conditioning_start
    Write-Host "Outside temperature is lower than $outsidetemp degrees, therefore $carname is now heating up"
    }
    else{
        Write-host "Outside temperature exceeds $outsidetemperature degrees Celsius, therefore the heating is not started"
    }
}

if ($stopcharge){
    set-tesla -Command charge_stop
    write-host "$carname has stopped charging"
    }

if ($honkhorn){
    set-tesla -Command honk_horn
    Write-host "$carname has honked its horn"
    }
