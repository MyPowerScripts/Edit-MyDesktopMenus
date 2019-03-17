#requires -version 5.0
<#
  .SYNOPSIS
  .DESCRIPTION
  .PARAMETER <Parameter-Name>
  .EXAMPLE
  .NOTES
    Script MyDM.ps1 Version 1.0 by MyAdmin on 2/23/2019
    Script Code Generator Version: 4.30.00.00
  .LINK
#>
[CmdletBinding(DefaultParameterSetName = "Local")]
param (
  [parameter(Mandatory = $True, ParameterSetName = "Remote")]
  [String]$ComputerName = [Environment]::MachineName,
  [parameter(Mandatory = $False, ParameterSetName = "Remote")]
  [ValidateSet("Yes", "No")]
  [String]$AskCreds = "No"
)

$ErrorActionPreference = "Stop"

# Comment Out $VerbosePreference Line for Production Deployment
$VerbosePreference = "Continue"

# Comment Out $DebugPreference Line for Production Deployment
$DebugPreference = "Continue"

# Clear Previous Error Messages
$Error.Clear()

[void][System.Reflection.Assembly]::Load("System.Windows.Forms, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089")
[void][System.Reflection.Assembly]::Load("System.Drawing, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a")

if ((Get-Module -Name CimCmdlets).Name -ne "CimCmdlets")
{
  Import-Module -Name CimCmdlets -ErrorAction "SilentlyContinue"
  if ((Get-Module -Name CimCmdlets).Name -ne "CimCmdlets")
  {
    [Void]([System.Windows.Forms.MessageBox]::Show("CimCmdlets Module not Found.", "Error: $TitleName", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error))
    [Environment]::Exit(1)
  }
}

#region ******** MyDM Configuration  ********

$MyDMConfig = @{}

# MyDM Script Production Mode
$MyDMConfig.Production = $True
$MyDMConfig.EditRegistry = $True

# MyDM Script Configuration
$MyDMConfig.ScriptName = "My Desktop Menus"
$MyDMConfig.ScriptVersion = "3.1.0.0"
$MyDMConfig.ScriptAuthor = "Ken Sweet"

# MyDM Form Control Space
$MyDMConfig.FormSpacer = 4

# MyDM Script Default Font Settings
$MyDMConfig.FontFamily = "Verdana"
$MyDMConfig.FontSize = 10

$MyDMConfig.DefaultIconPath = "$($ENV:windir)\System32\shell32.dll"
$MyDMConfig.DefaultIconIndex = 43
$MyDMConfig.DefaultIconSmall = $Null

$MyDMConfig.EnableUser = ($ComputerName -eq [Environment]::MachineName)
$MyDMConfig.EnableSystem = [Security.Principal.WindowsPrincipal]::New([Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

$MyDMConfig.RegistryRights = @("KEY_QUERY_VALUE", "KEY_SET_VALUE", "KEY_CREATE_SUB_KEY", "KEY_ENUMERATE_SUB_KEYS", "KEY_CREATE")

$MyDMConfig.RegistryMenuList = "Software\$($MyDMConfig.ScriptName)"
$MyDMConfig.RegistryMenuData = "Software\Classes\CLSID"
$MyDMConfig.RegistrySubMenuCmds = "SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\Shell"
$MyDMConfig.RegistryMenuDisplay = "SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace"
$MyDMConfig.RegistryMenuDeleted = "Software\Microsoft\Windows\CurrentVersion\Explorer\CLSID"

$MyDMConfig.MaxSubMenuCmds = 16

$MyDMConfig.PrefixMenu = "Menu{0:000}"
$MyDMConfig.PrefixCommand = "XCmd{0:000}"
$MyDMConfig.PrefixSubCommand = "MyDM-{0}-{1}-{2:00}"

$MyDMConfig.SeparatorYes = "Yes"
$MyDMConfig.SeparatorNo = "No"

$MyDMConfig.SeparatorBefore = 0x20
$MyDMConfig.SeparatorAfter = 0x40

if (($AskCreds -eq "Yes") -and (-not $MyDMConfig.EnableUser))
{
  Try
  {
    $MyDMConfig.Credential = (Get-Credential -ErrorAction "SilentlyContinue")
  }
  Catch
  {
    $MyDMConfig.Credential = [PSCredential]::Empty
  }
}
else
{
  $MyDMConfig.Credential = [PSCredential]::Empty
}

# Get Script Path
if ([String]::IsNullOrEmpty($HostInvocation))
{
  $MyDMConfig.ScriptPath = [System.IO.Path]::GetDirectoryName($Script:MyInvocation.MyCommand.Path)
}
else
{
  $MyDMConfig.ScriptPath = [System.IO.Path]::GetDirectoryName($HostInvocation.MyCommand.Path)
}

#endregion ******** MyDM Configuration  ********

#region ******** MyDM Form Custom Colors ********

$MyDMColor = @{}

# Main Form Colors - Mine - Dark
$MyDMColor.BackColor = [System.Drawing.Color]::Black
$MyDMColor.ForeColor = [System.Drawing.Color]::DarkRed

# Default Color for Labels, CheckBoxes, and RadioButtons
$MyDMColor.LabelForeColor = [System.Drawing.Color]::DarkRed

$MyDMColor.ErrorForeColor = [System.Drawing.Color]::Yellow

# Default Color for Title Labels
$MyDMColor.TitleBackColor = [System.Drawing.Color]::DimGray
$MyDMColor.TitleForeColor = [System.Drawing.Color]::Black

# Default Color for GroupBoxes
$MyDMColor.GroupForeColor = [System.Drawing.Color]::DarkRed

# Default Colors for TextBoxes, ComboBoxes, CheckedListBoxes, ListBoxes, ListViews, TreeViews, RichTextBoxes, DateTimePickers, and DataGridViews
$MyDMColor.TextBackColor = [System.Drawing.Color]::LightGray
$MyDMColor.TextForeColor = [System.Drawing.Color]::Black

# Default Color for Buttons
$MyDMColor.ButtonBackColor = [System.Drawing.Color]::DarkGray
$MyDMColor.ButtonForeColor = [System.Drawing.Color]::Black

#endregion ******** MyDM Form Custom Colors ********

#region ******** MyDM Form Custom Colors ********

#$MyDMColor = @{}
#
## Main Form Colors - Mine - Light
#$MyDMColor.BackColor = [System.Drawing.Color]::White
#$MyDMColor.ForeColor = [System.Drawing.Color]::Navy
#
## Default Color for Labels, CheckBoxes, and RadioButtons
#$MyDMColor.LabelForeColor = [System.Drawing.Color]::Navy
#
#$MyDMColor.ErrorForeColor = [System.Drawing.Color]::Red
#
## Default Color for Title Labels
#$MyDMColor.TitleBackColor = [System.Drawing.Color]::LightBlue
#$MyDMColor.TitleForeColor = [System.Drawing.Color]::Navy
#
## Default Color for GroupBoxes
#$MyDMColor.GroupForeColor = [System.Drawing.Color]::Navy
#
## Default Colors for TextBoxes, ComboBoxes, CheckedListBoxes, ListBoxes, ListViews, TreeViews, RichTextBoxes, DateTimePickers, and DataGridViews
#$MyDMColor.TextBackColor = [System.Drawing.Color]::White
#$MyDMColor.TextForeColor = [System.Drawing.Color]::Black
#
## Default Color for Buttons
#$MyDMColor.ButtonBackColor = [System.Drawing.Color]::Gainsboro
#$MyDMColor.ButtonForeColor = [System.Drawing.Color]::Navy

#endregion ******** MyDM Form Custom Colors ********

#region ******** Registry Class - Enumerations ********

enum ErrorValues
{
  Success = 0x0
  NoDefault = 0x1
  InvalidKey = 0x2
  Unknown3 = 0x3
  Unknown4 = 0x4
  SubKeys = 0x5
  InValidHive = 0x6
}

enum RegHive
{
  HKROOT = 0x80000000
  HKCU = 0x80000001
  HKLM = 0x80000002
  HKU = 0x80000003
  HKCC = 0x80000005
  HKDD = 0x80000006
}

enum RegType
{
  REG_SZ = 0x1
  REG_EXPAND_SZ = 0x2
  REG_BINARY = 0x3
  REG_DWORD = 0x4
  REG_MULTI_SZ = 0x7
  REG_QWORD = 0xB
}

[Flags()]
enum RegRights
{
  KEY_QUERY_VALUE = 0x00001
  KEY_SET_VALUE = 0x00002
  KEY_CREATE_SUB_KEY = 0x00004
  KEY_ENUMERATE_SUB_KEYS = 0x00008
  KEY_NOTIFY = 0x00010
  KEY_CREATE = 0x00020
  DELETE = 0x10000
  READ_CONTROL = 0x20000
  WRITE_DAC = 0x40000
  WRITE_OWNER = 0x80000
}
#EndRegion ******** Registry Class - Enumerations ********

#region ******** Registry Class - Method Result Classes ********

#region MyRegAccess
class MyRegAccess
{
  [Int]$Failure
  [Bool]$Granted
  
  MyRegAccess ([Int]$Failure, [Bool]$Granted)
  {
    $This.Failure = $Failure
    $This.Granted = $Granted
  }
}
#endregion MyRegAccess

#region MyRegResult
class MyRegResult
{
  [Int]$Failure
  
  MyRegResult ([Int]$Failure)
  {
    $This.Failure = $Failure
  }
}
#endregion MyRegResult

#region MyRegEnumKey
class MyRegEnumKey
{
  [Int]$Failure
  [String[]]$Value
  
  MyRegEnumKey ([Int]$Failure, [String[]]$Value)
  {
    $This.Failure = $Failure
    $This.Value = $Value
  }
}
#endregion MyRegEnumKey

#region MyRegString
class MyRegString
{
  [Int]$Failure
  [String]$Value
  
  MyRegString ([Int]$Failure, [String]$Value)
  {
    $This.Failure = $Failure
    $This.Value = $Value
  }
}
#endregion MyRegString

#region MyRegExpandedString
class MyRegExpandedString
{
  [Int]$Failure
  [String]$Value
  
  MyRegExpandedString ([Int]$Failure, [String]$Value)
  {
    $This.Failure = $Failure
    $This.Value = $Value
  }
}
#endregion MyRegExpandedString

#region MyRegMultiString
class MyRegMultiString
{
  [Int]$Failure
  [String[]]$Value
  
  MyRegMultiString ([Int]$Failure, [String[]]$Value)
  {
    $This.Failure = $Failure
    $This.Value = $Value
  }
}
#endregion MyRegMultiString

#region MyRegDWord
class MyRegDWord
{
  [Int]$Failure
  [Uint32]$Value
  
  MyRegDWord ([Int]$Failure, [Uint32]$Value)
  {
    $This.Failure = $Failure
    $This.Value = $Value
  }
}
#endregion MyRegDWord

#region MyRegQWord
class MyRegQWord
{
  [Int]$Failure
  [Uint64]$Value
  
  MyRegQWord ([Int]$Failure, [Uint64]$Value)
  {
    $This.Failure = $Failure
    $This.Value = $Value
  }
}
#endregion MyRegQWord

#region MyRegBinary
class MyRegBinary
{
  [Int]$Failure
  [Byte[]]$Value
  
  MyRegBinary ([Int]$Failure, [Byte[]]$Value)
  {
    $This.Failure = $Failure
    $This.Value = $Value
  }
}
#endregion MyRegBinary

#region MyRegEnumValue
class MyRegEnumValue
{
  [String]$Name
  [RegType]$Type
  
  MyRegEnumValue([String]$Name, [RegType]$Type)
  {
    $This.Name = $Name
    $This.Type = $Type
  }
}
#endregion MyRegEnumValue

#region MyRegEnumValues
class MyRegEnumValues
{
  [int]$Failure
  [MyRegEnumValue[]]$Values
  
  MyRegEnumValues ([int]$Failure, [MyRegEnumValue[]]$Values)
  {
    $This.Failure = $Failure
    $This.Values = $Values
  }
}
#endregion MyRegEnumValues

#endregion ******** Registry Class - Method Result Classes ********

#region ******** Registry Class - MyWMIRegistry Class ********
class MyWMIRegistry
{
  [Bool]$Connect = $False
  
  [RegHive]$DefaultHive = "HKLM"
  
  hidden [CimSession]$CimSession
  
  hidden [CimClass]$StdRegProv
  
  #region ******** Class Constructors ********
  
  # ---------------------------------------
  # Crerate New Class with Default Settings
  # ---------------------------------------
  MyWMIRegistry ()
  {
    $This.ConnectRegistry(@{ })
  }
  
  # ---------------------------------------
  # Crerate New Class for Specifed Computer
  # ---------------------------------------
  MyWMIRegistry ([String]$ComputerName)
  {
    if ([String]::IsNullOrEmpty($ComputerName))
    {
      Throw "Error Missing or Invalid ComputerName"
    }
    else
    {
      $This.ConnectRegistry(@{ "Computername" = $Computername })
    }
  }
  
  # -------------------------------------------------------
  # Crerate New Class for Specifed Computer and Credentials
  # -------------------------------------------------------
  MyWMIRegistry ([String]$ComputerName, [PSCredential]$Credential)
  {
    if ([String]::IsNullOrEmpty($ComputerName))
    {
      Throw "Error Missing or Invalid ComputerName / Credential"
    }
    else
    {
      $This.ConnectRegistry(@{ "Computername" = $Computername; "Credential" = $Credential })
    }
  }
  
  #endregion ******** Class Constructors ********
  
  #region ******** Internal Methods ********
  
  # ------------------------------------------
  # Convert Signed Integer to Unsigned Integer
  # ------------------------------------------
  hidden [uint32] Int2Uint ([int]$Value)
  {
    return [BitConverter]::ToUInt32([BitConverter]::GetBytes($Value), 0)
  }
  
  # ----------------------------------------------
  # Open CimSession using Wsman then Dcom Protocol
  # ----------------------------------------------
  hidden [Void] ConnectRegistry ([HashTable]$Options)
  {
    $Protocol = "WSMAN"
    While (-Not $This.Connect)
    {
      try
      {
        $This.CimSession = New-CimSession -SessionOption (New-CimSessionOption -Protocol $Protocol) @Options
        $This.StdRegProv = Get-CimClass -CimSession $This.CimSession -Namespace "Root\Default" -ClassName "StdRegProv"
        $This.Connect = $True
      }
      catch
      {
        if ($Protocol -eq "DCOM")
        {
          #Throw "Unable to Connect to Registry"
          break
        }
        $Protocol = "DCOM"
      }
    }
  }
  
  #endregion ******** Internal Methods ********
  
  #region ******** Class Methods ********
  
  # ------------------------------
  # Return Connected Computername
  # ------------------------------
  [String] ComputerName ()
  {
    return $This.CimSession.ComputerName
  }
  
  # ------------------------------
  # Return Connected Computername
  # ------------------------------
  [String] Protocol ()
  {
    return $This.CimSession.Protocol
  }
  
  # -------------------------
  # Close the Open CimSession
  # -------------------------
  [Bool] Close ()
  {
    try
    {
      Remove-CimSession -CimSession $This.CimSession
      $This.CimSession = $Null
      $This.Connect = $False
    }
    catch
    {
    }
    return (-not $This.Connect)
  }
  
  #endregion ******** Class Methods ********
  
  #region ******** Static Methods ********
  
  # ------------------------------
  # Generate new Credential Object
  # ------------------------------
  static [PSCredential] GenerateCreds ([String]$UserName, [String]$Password)
  {
    try
    {
      return (New-Object -TypeName PSCredential($UserName, (ConvertTo-SecureString -String $Password -AsPlainText -Force)))
    }
    catch
    {
      Throw "Error Generating Credential Object"
    }
  }
  
  #endregion ******** Static Methods ********
  
  #region ******** CheckAccess ********
  
  # -------------------------------------------------------------------------------------
  # Check for Default Access Rights for the Specified Registry Key Under the Default Hive
  # -------------------------------------------------------------------------------------
  [MyRegAccess] CheckAccess ([String]$SubKey)
  {
    return $This.CheckAccess($This.DefaultHive, $SubKey, ("KEY_QUERY_VALUE", "KEY_SET_VALUE"))
  }
  
  # --------------------------------------------------------------------------------------
  # Check for Specific Access Rights for the Specified Registry Key Under the Default Hive
  # --------------------------------------------------------------------------------------
  [MyRegAccess] CheckAccess ([String]$SubKey, [RegRights]$Rights)
  {
    return $This.CheckAccess($This.DefaultHive, $SubKey, $Rights)
  }
  
  # ------------------------------------------------------------------------
  # Check for Specific Access Rights for the Specified Registry Key and Hive
  # ------------------------------------------------------------------------
  [MyRegAccess] CheckAccess ([RegHive]$Hive, [String]$SubKey, [RegRights]$Rights)
  {
    if (($Result = Invoke-CimMethod -CimSession $This.CimSession -CimClass $This.StdRegProv -MethodName "CheckAccess" -Arguments @{ "hDefKey" = $This.Int2Uint($Hive); "sSubKeyName" = $SubKey; "uRequired" = $Rights }).ReturnValue)
    {
      return [MyRegAccess]::New($Result.ReturnValue, $False)
    }
    else
    {
      return [MyRegAccess]::New($Result.ReturnValue, $Result.bGranted)
    }
  }
  
  #endregion ******** CheckAccess ********
  
  #region ******** EnumKey ********
  
  # -------------------------------------------------------------
  # Get Registry Sub Key Names from Defaut Hive and Specified Key
  # -------------------------------------------------------------
  [MyRegEnumKey] EnumKey ([String]$SubKey)
  {
    return $This.EnumKey($This.DefaultHive, $SubKey)
  }
  
  # ------------------------------------------------------
  # Get Registry Sub Key Names from Specified Hive and Key
  # ------------------------------------------------------
  [MyRegEnumKey] EnumKey ([RegHive]$Hive, [String]$SubKey)
  {
    if (($Result = Invoke-CimMethod -CimSession $This.CimSession -CimClass $This.StdRegProv -MethodName "EnumKey" -Arguments @{ "hDefKey" = $This.Int2Uint($Hive); "sSubKeyName" = $SubKey }).ReturnValue)
    {
      return [MyRegEnumKey]::New($Result.ReturnValue, @())
    }
    else
    {
      return [MyRegEnumKey]::New($Result.ReturnValue, $Result.sNames)
    }
  }
  
  #endregion ******** EnumKey ********
  
  #region ******** CreateKey ********
  
  # ------------------------------------------------------------
  # Create New Registry Key Under Specified Key and Default Hive
  # ------------------------------------------------------------
  [MyRegResult] CreateKey ([String]$SubKey, [String]$Key)
  {
    return $This.CreateKey($This.DefaultHive, $SubKey, $Key)
  }
  
  # ----------------------------------------------------
  # Create New Registry Key Under Specified Key and Hive
  # ----------------------------------------------------
  [MyRegResult] CreateKey ([RegHive]$Hive, [String]$SubKey, [String]$Key)
  {
    if ($Key.Length -le 255)
    {
      return [MyRegResult]::New((Invoke-CimMethod -CimSession $This.CimSession -CimClass $This.StdRegProv -MethodName "CreateKey" -Arguments @{ "hDefKey" = $This.Int2Uint($Hive); "sSubKeyName" = "$SubKey\$Key" }).ReturnValue)
    }
    else
    {
      Throw "Name Exceeds 255 Characters"
    }
  }
  
  #endregion ******** CreateKey ********
  
  #region ******** DeleteKey ********
  
  # -------------------------------------------------------
  # Delete Registry Key From Specified Key and Default Hive
  # -------------------------------------------------------
  [MyRegResult] DeleteKey ([String]$SubKey, [String]$Key)
  {
    return $This.DeleteKey($This.DefaultHive, $SubKey, $Key)
  }
  
  # -----------------------------------------------
  # Delete Registry Key From Specified Key and Hive
  # -----------------------------------------------
  [MyRegResult] DeleteKey ([RegHive]$Hive, [String]$SubKey, [String]$Key)
  {
    if ($Key.Length -le 255)
    {
      return [MyRegResult]::New((Invoke-CimMethod -CimSession $This.CimSession -CimClass $This.StdRegProv -MethodName "DeleteKey" -Arguments @{ "hDefKey" = $This.Int2Uint($Hive); "sSubKeyName" = "$SubKey\$Key" }).ReturnValue)
    }
    else
    {
      Throw "Name Exceeds 255 Characters"
    }
  }
  
  #endregion ******** DeleteKey ********
  
  #region ******** EnumValues ********
  
  # -------------------------------------------------------------
  # Get Registry Sub Key Names from Defaut Hive and Specified Key
  # -------------------------------------------------------------
  [MyRegEnumValues] EnumValues ([String]$SubKey)
  {
    return $This.EnumValues($This.DefaultHive, $SubKey)
  }
  
  # ------------------------------------------------------
  # Get Registry Sub Key Names from Specified Hive and Key
  # ------------------------------------------------------
  [MyRegEnumValues] EnumValues ([RegHive]$Hive, [String]$SubKey)
  {
    $Values = [System.Collections.ArrayList]::New()
    if (($Result = Invoke-CimMethod -CimSession $This.CimSession -CimClass $This.StdRegProv -MethodName "EnumValues" -Arguments @{ "hDefKey" = $This.Int2Uint($Hive); "sSubKeyName" = $SubKey }).ReturnValue)
    {
      return [MyRegEnumValues]::New($Result.ReturnValue, $Values)
    }
    else
    {
      $Count = ($Result.sNames).Count - 1
      For ($Index = 0; $Index -le $Count; $Index++)
      {
        $Values.Add([MyRegEnumValue]::New($Result.sNames[$Index], $Result.Types[$Index]))
      }
      return [MyRegEnumValues]::New($Result.ReturnValue, $Values)
    }
  }
  
  #endregion ******** EnumValues ********
  
  #region ******** StringValue ********
  
  # -------------------------------------------------------
  # Delete Registry Key From Specified Key and Default Hive
  # -------------------------------------------------------
  [MyRegResult] SetStringValue ([String]$SubKey, [String]$Value, [String]$Data)
  {
    return $This.SetStringValue($This.DefaultHive, $SubKey, $Value, $Data)
  }
  
  # -----------------------------------------------
  # Delete Registry Key From Specified Key and Hive
  # -----------------------------------------------
  [MyRegResult] SetStringValue ([RegHive]$Hive, [String]$SubKey, [String]$Value, [String]$Data)
  {
    return [MyRegResult]::New((Invoke-CimMethod -CimSession $This.CimSession -CimClass $This.StdRegProv -MethodName "SetStringValue" -Arguments @{ "hDefKey" = $This.Int2Uint($Hive); "sSubKeyName" = $SubKey; "sValueName" = $Value; "sValue" = $Data }).ReturnValue)
  }
  
  # -------------------------------------------------------
  # Delete Registry Key From Specified Key and Default Hive
  # -------------------------------------------------------
  [MyRegString] GetStringValue ([String]$SubKey, [String]$Value)
  {
    return $This.GetStringValue($This.DefaultHive, $SubKey, $Value)
  }
  
  # -----------------------------------------------
  # Delete Registry Key From Specified Key and Hive
  # -----------------------------------------------
  [MyRegString] GetStringValue ([RegHive]$Hive, [String]$SubKey, [String]$Value)
  {
    if (($Result = Invoke-CimMethod -CimSession $This.CimSession -CimClass $This.StdRegProv -MethodName "GetStringValue" -Arguments @{ "hDefKey" = $This.Int2Uint($Hive); "sSubKeyName" = $SubKey; "sValueName" = $Value }).ReturnValue)
    {
      return [MyRegString]::New($Result.ReturnValue, "")
    }
    else
    {
      return [MyRegString]::New($Result.ReturnValue, $Result.sValue)
    }
  }
  
  #endregion ******** StringValue ********
  
  #region ******** ExpandedStringValue ********
  
  # -------------------------------------------------------
  # Delete Registry Key From Specified Key and Default Hive
  # -------------------------------------------------------
  [MyRegResult] SetExpandedStringValue ([String]$SubKey, [String]$Value, [String]$Data)
  {
    return $This.SetExpandedStringValue($This.DefaultHive, $SubKey, $Value, $Data)
  }
  
  # -----------------------------------------------
  # Delete Registry Key From Specified Key and Hive
  # -----------------------------------------------
  [MyRegResult] SetExpandedStringValue ([RegHive]$Hive, [String]$SubKey, [String]$Value, [String]$Data)
  {
    return [MyRegResult]::New((Invoke-CimMethod -CimSession $This.CimSession -CimClass $This.StdRegProv -MethodName "SetExpandedStringValue" -Arguments @{ "hDefKey" = $This.Int2Uint($Hive); "sSubKeyName" = $SubKey; "sValueName" = $Value; "sValue" = $Data }).ReturnValue)
  }
  
  # -------------------------------------------------------
  # Delete Registry Key From Specified Key and Default Hive
  # -------------------------------------------------------
  [MyRegExpandedString] GetExpandedStringValue ([String]$SubKey, [String]$Value)
  {
    return $This.GetExpandedStringValue($This.DefaultHive, $SubKey, $Value)
  }
  
  # -----------------------------------------------
  # Delete Registry Key From Specified Key and Hive
  # -----------------------------------------------
  [MyRegExpandedString] GetExpandedStringValue ([RegHive]$Hive, [String]$SubKey, [String]$Value)
  {
    if (($Result = Invoke-CimMethod -CimSession $This.CimSession -CimClass $This.StdRegProv -MethodName "GetExpandedStringValue" -Arguments @{ "hDefKey" = $This.Int2Uint($Hive); "sSubKeyName" = $SubKey; "sValueName" = $Value }).ReturnValue)
    {
      return [MyRegExpandedString]::New($Result.ReturnValue, "")
    }
    else
    {
      return [MyRegExpandedString]::New($Result.ReturnValue, $Result.sValue)
    }
  }
  
  #endregion ******** ExpandedStringValue ********
  
  #region ******** MultiStringValue ********
  
  # -------------------------------------------------------
  # Delete Registry Key From Specified Key and Default Hive
  # -------------------------------------------------------
  [MyRegResult] SetMultiStringValue ([String]$SubKey, [String]$Value, [String[]]$Data)
  {
    return $This.SetMultiStringValue($This.DefaultHive, $SubKey, $Value, $Data)
  }
  
  # -----------------------------------------------
  # Delete Registry Key From Specified Key and Hive
  # -----------------------------------------------
  [MyRegResult] SetMultiStringValue ([RegHive]$Hive, [String]$SubKey, [String]$Value, [String[]]$Data)
  {
    return [MyRegResult]::New((Invoke-CimMethod -CimSession $This.CimSession -CimClass $This.StdRegProv -MethodName "SetMultiStringValue" -Arguments @{ "hDefKey" = $This.Int2Uint($Hive); "sSubKeyName" = $SubKey; "sValueName" = $Value; "sValue" = $Data }).ReturnValue)
  }
  
  # -------------------------------------------------------
  # Delete Registry Key From Specified Key and Default Hive
  # -------------------------------------------------------
  [MyRegMultiString] GetMultiStringValue ([String]$SubKey, [String]$Value)
  {
    return $This.GetMultiStringValue($This.DefaultHive, $SubKey, $Value)
  }
  
  # -----------------------------------------------
  # Delete Registry Key From Specified Key and Hive
  # -----------------------------------------------
  [MyRegMultiString] GetMultiStringValue ([RegHive]$Hive, [String]$SubKey, [String]$Value)
  {
    if (($Result = Invoke-CimMethod -CimSession $This.CimSession -CimClass $This.StdRegProv -MethodName "GetMultiStringValue" -Arguments @{ "hDefKey" = $This.Int2Uint($Hive); "sSubKeyName" = $SubKey; "sValueName" = $Value }).ReturnValue)
    {
      return [MyRegMultiString]::New($Result.ReturnValue, @())
    }
    else
    {
      return [MyRegMultiString]::New($Result.ReturnValue, $Result.sValue)
    }
  }
  
  #endregion ******** MultiStringValue ********
  
  #region ******** DWORDValue ********
  
  # -------------------------------------------------------
  # Delete Registry Key From Specified Key and Default Hive
  # -------------------------------------------------------
  [MyRegResult] SetDWORDValue ([String]$SubKey, [String]$Value, [Uint32]$Data)
  {
    return $This.SetDWORDValue($This.DefaultHive, $SubKey, $Value, $Data)
  }
  
  # -----------------------------------------------
  # Delete Registry Key From Specified Key and Hive
  # -----------------------------------------------
  [MyRegResult] SetDWORDValue ([RegHive]$Hive, [String]$SubKey, [String]$Value, [Uint32]$Data)
  {
    return [MyRegResult]::New((Invoke-CimMethod -CimSession $This.CimSession -CimClass $This.StdRegProv -MethodName "SetDWORDValue" -Arguments @{ "hDefKey" = $This.Int2Uint($Hive); "sSubKeyName" = $SubKey; "sValueName" = $Value; "uValue" = $Data }).ReturnValue)
  }
  
  # -------------------------------------------------------
  # Delete Registry Key From Specified Key and Default Hive
  # -------------------------------------------------------
  [MyRegDWord] GetDWORDValue ([String]$SubKey, [String]$Value)
  {
    return $This.GetDWORDValue($This.DefaultHive, $SubKey, $Value)
  }
  
  # -----------------------------------------------
  # Delete Registry Key From Specified Key and Hive
  # -----------------------------------------------
  [MyRegDWord] GetDWORDValue ([RegHive]$Hive, [String]$SubKey, [String]$Value)
  {
    if (($Result = Invoke-CimMethod -CimSession $This.CimSession -CimClass $This.StdRegProv -MethodName "GetDWORDValue" -Arguments @{ "hDefKey" = $This.Int2Uint($Hive); "sSubKeyName" = $SubKey; "sValueName" = $Value }).ReturnValue)
    {
      return [MyRegDWord]::New($Result.ReturnValue, 0)
    }
    else
    {
      return [MyRegDWord]::New($Result.ReturnValue, $Result.uValue)
    }
  }
  
  #endregion ******** DWORDValue ********
  
  #region ******** QWordValue ********
  
  # -------------------------------------------------------
  # Delete Registry Key From Specified Key and Default Hive
  # -------------------------------------------------------
  [MyRegResult] SetQWordValue ([String]$SubKey, [String]$Value, [Uint64]$Data)
  {
    return $This.SetQWordValue($This.DefaultHive, $SubKey, $Value, $Data)
  }
  
  # -----------------------------------------------
  # Delete Registry Key From Specified Key and Hive
  # -----------------------------------------------
  [MyRegResult] SetQWordValue ([RegHive]$Hive, [String]$SubKey, [String]$Value, [Uint64]$Data)
  {
    return [MyRegResult]::New((Invoke-CimMethod -CimSession $This.CimSession -CimClass $This.StdRegProv -MethodName "SetQWordValue" -Arguments @{ "hDefKey" = $This.Int2Uint($Hive); "sSubKeyName" = $SubKey; "sValueName" = $Value; "uValue" = $Data }).ReturnValue)
  }
  
  # -------------------------------------------------------
  # Delete Registry Key From Specified Key and Default Hive
  # -------------------------------------------------------
  [MyRegQWord] GetQWordValue ([String]$SubKey, [String]$Value)
  {
    return $This.GetQWordValue($This.DefaultHive, $SubKey, $Value)
  }
  
  # -----------------------------------------------
  # Delete Registry Key From Specified Key and Hive
  # -----------------------------------------------
  [MyRegQWord] GetQWordValue ([RegHive]$Hive, [String]$SubKey, [String]$Value)
  {
    if (($Result = Invoke-CimMethod -CimSession $This.CimSession -CimClass $This.StdRegProv -MethodName "GetQWORDValue" -Arguments @{ "hDefKey" = $This.Int2Uint($Hive); "sSubKeyName" = $SubKey; "sValueName" = $Value }).ReturnValue)
    {
      return [MyRegQWord]::New($Result.ReturnValue, 0)
    }
    else
    {
      return [MyRegQWord]::New($Result.ReturnValue, $Result.uValue)
    }
  }
  
  #endregion ******** QWordValue ********
  
  #region ******** BinaryValue ********
  
  # -------------------------------------------------------
  # Delete Registry Key From Specified Key and Default Hive
  # -------------------------------------------------------
  [MyRegResult] SetBinaryValue ([String]$SubKey, [String]$Value, [Byte[]]$Data)
  {
    return $This.SetBinaryValue($This.DefaultHive, $SubKey, $Value, $Data)
  }
  
  # -----------------------------------------------
  # Delete Registry Key From Specified Key and Hive
  # -----------------------------------------------
  [MyRegResult] SetBinaryValue ([RegHive]$Hive, [String]$SubKey, [String]$Value, [Byte[]]$Data)
  {
    return [MyRegResult]::New((Invoke-CimMethod -CimSession $This.CimSession -CimClass $This.StdRegProv -MethodName "SetBinaryValue" -Arguments @{ "hDefKey" = $This.Int2Uint($Hive); "sSubKeyName" = $SubKey; "sValueName" = $Value; "uValue" = $Data }).ReturnValue)
  }
  
  # -------------------------------------------------------
  # Delete Registry Key From Specified Key and Default Hive
  # -------------------------------------------------------
  [MyRegBinary] GetBinaryValue ([String]$SubKey, [String]$Value)
  {
    return $This.GetBinaryValue($This.DefaultHive, $SubKey, $Value)
  }
  
  # -----------------------------------------------
  # Delete Registry Key From Specified Key and Hive
  # -----------------------------------------------
  [MyRegBinary] GetBinaryValue ([RegHive]$Hive, [String]$SubKey, [String]$Value)
  {
    if (($Result = Invoke-CimMethod -CimSession $This.CimSession -CimClass $This.StdRegProv -MethodName "GetBinaryValue" -Arguments @{ "hDefKey" = $This.Int2Uint($Hive); "sSubKeyName" = $SubKey; "sValueName" = $Value }).ReturnValue)
    {
      return [MyRegBinary]::New($Result.ReturnValue, @())
    }
    else
    {
      return [MyRegBinary]::New($Result.ReturnValue, $Result.uValue)
    }
  }
  
  #endregion ******** BinaryValue ********
  
  #region ******** DeleteValue ********
  
  # -------------------------------------------------------
  # Delete Registry Key From Specified Key and Default Hive
  # -------------------------------------------------------
  [MyRegResult] DeleteValue ([String]$SubKey, [String]$Value)
  {
    return $This.DeleteValue($This.DefaultHive, $SubKey, $Value)
  }
  
  # -----------------------------------------------
  # Delete Registry Key From Specified Key and Hive
  # -----------------------------------------------
  [MyRegResult] DeleteValue ([RegHive]$Hive, [String]$SubKey, [String]$Value)
  {
    return [MyRegResult]::New((Invoke-CimMethod -CimSession $This.CimSession -CimClass $This.StdRegProv -MethodName "DeleteValue" -Arguments @{ "hDefKey" = $This.Int2Uint($Hive); "sSubKeyName" = $SubKey; "sValueName" = $Value }).ReturnValue)
  }
  
  #endregion ******** DeleteValue ********
}
#endregion ******** Registry Class - MyWMIRegistry Class ********

#region ******** My Custom Class *********

#region Class MyDesktopMenu
Class MyDesktopMenu
{
  [String]$ID
  [String]$Name
  [String]$IconPath
  [Int]$Index
  [Object[]]$SubMenu
  [Object[]]$Command
  
  
  MyDesktopMenu ([String]$ID, [String]$Name, [String]$IconPath, [Int]$Index)
  {
    $This.ID = $ID
    $This.Name = $Name
    $This.IconPath = $IconPath
    $This.Index = $Index
    $This.SubMenu = @()
    $This.Command = @()
  }
  
  MyDesktopMenu ([String]$Name, [String]$IconPath, [Int]$Index)
  {
    $This.Name = $Name
    $This.IconPath = $IconPath
    $This.Index = $Index
    $This.SubMenu = @()
    $This.Command = @()
  }
  
  [Void] UpdateMenu ([String]$Name, [String]$IconPath, [int]$Index)
  {
    $This.Name = $Name
    $This.IconPath = $IconPath
    $This.Index = $Index
  }
}
#endregion Class MyDesktopMenu

#region Class MySubMenu
Class MySubMenu
{
  [String]$ID
  [String]$Name
  [Int]$CommandFlags
  [String]$IconPath
  [Int]$Index
  [String]$SubCommands
  [Object[]]$Command
  
  MySubMenu ([String]$Name, [Int]$CommandFlags, [String]$IconPath, [Int]$Index)
  {
    $This.ID = "{$([Guid]::NewGuid().Guid)}".ToUpper()
    $This.Name = $Name
    $This.SubCommands = ""
    $This.CommandFlags = $CommandFlags
    $This.IconPath = $IconPath
    $This.Index = $Index
    $This.Command = @()
  }
  
  MySubMenu ([String]$Name, [String]$SubCommands, [Int]$CommandFlags, [String]$IconPath, [Int]$Index)
  {
    $This.ID = "{$([Guid]::NewGuid().Guid)}".ToUpper()
    $This.Name = $Name
    $This.SubCommands = $SubCommands
    $This.CommandFlags = $CommandFlags
    $This.IconPath = $IconPath
    $This.Index = $Index
    $This.Command = @()
  }
  
  MySubMenu ([String]$ID, [String]$Name, [String]$SubCommands, [Int]$CommandFlags, [String]$IconPath, [Int]$Index)
  {
    $This.ID = $ID
    $This.Name = $Name
    $This.SubCommands = $SubCommands
    $This.CommandFlags = $CommandFlags
    $This.IconPath = $IconPath
    $This.Index = $Index
    $This.Command = @()
  }
  
  [Void] UpdateSubMenu ([String]$Name, [Int]$CommandFlags, [String]$IconPath, [int]$Index)
  {
    $This.Name = $Name
    $This.CommandFlags = $CommandFlags
    $This.IconPath = $IconPath
    $This.Index = $Index
  }
  
  [Void] UpdateSubCommands ([String]$SubCommands)
  {
    $This.SubCommands = ($SubCommands.Trim(";"))
  }
}
#endregion Class MySubMenu

#region Class MyMenuCommand
Class MyMenuCommand
{
  [String]$ID
  [String]$Name
  [String]$Command
  [Int]$CommandFlags
  [String]$IconPath
  [Int]$Index
  
  MyMenuCommand ([String]$Name, [String]$Command, [Int]$CommandFlags, [String]$IconPath, [Int]$Index)
  {
    $This.ID = "{$([Guid]::NewGuid().Guid)}".ToUpper()
    $This.Name = $Name
    $This.Command = $Command
    $This.CommandFlags = $CommandFlags
    $This.IconPath = $IconPath
    $This.Index = $Index
  }
  
  [Void] UpdateCommand ([String]$Name, [String]$Command, [Int]$CommandFlags, [String]$IconPath, [Int]$Index)
  {
    $This.Name = $Name
    $This.Command = $Command
    $This.CommandFlags = $CommandFlags
    $This.IconPath = $IconPath
    $This.Index = $Index
  }
}
#endregion Class MyMenuCommand

#endregion ******** My Custom Class *********

#region ******** My Custom Functions ********

#region ********* Show / Hide PowerShell Window *********
$WindowDisplay = @"
using System;
using System.Runtime.InteropServices;

namespace Window
{
  public class Display
  {
    [DllImport("Kernel32.dll")]
    private static extern IntPtr GetConsoleWindow();

    [DllImport("user32.dll")]
    private static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);

    public static bool Hide()
    {
      return ShowWindowAsync(GetConsoleWindow(), 0);
    }

    public static bool Show()
    {
      return ShowWindowAsync(GetConsoleWindow(), 5);
    }
  }
}
"@
Add-Type -TypeDefinition $WindowDisplay -Debug:$False
#endregion ********* Show / Hide PowerShell Window *********

#region function New-TreeNode
function New-TreeNode()
{
  <#
    .SYNOPSIS
      Makes and adds a New TreeNode to a TreeView Node
    .DESCRIPTION
      Makes and adds a New TreeNode to a TreeView Node
    .PARAMETER TreeNode
    .PARAMETER Text
    .PARAMETER Name
    .PARAMETER Tag
    .PARAMETER FontFamily
    .PARAMETER FontSize
    .PARAMETER FontStyle
    .PARAMETER BackColor
    .PARAMETER ForeColor
    .PARAMETER ImageIndex
    .PARAMETER SelectedImageIndex
    .PARAMETER ToolTip
    .PARAMETER AtTop
    .PARAMETER Checked
    .PARAMETER Expand
    .PARAMETER PassThru
    .EXAMPLE
      New-TreeNode -TreeNode $TreeNode -Text "Text" -Tag "Tag"
    .NOTES
      Original Function By Ken Sweet
    .LINK
  #>
  [CmdletBinding(DefaultParameterSetName = "Index")]
  param (
    [parameter(Mandatory = $True)]
    [Object]$TreeNode,
    [parameter(Mandatory = $True)]
    [String]$Text,
    [String]$Name,
    [Object]$Tag,
    [System.Drawing.FontFamily]$FontFamily = $MyDMConfig.FontFamily,
    [Int]$FontSize = $MyDMConfig.FontSize,
    [System.Drawing.FontStyle]$FontStyle = "Regular",
    [System.Drawing.Color]$BackColor = $MyDMColor.TextBackColor,
    [System.Drawing.Color]$ForeColor = $MyDMColor.TextForeColor,
    [parameter(Mandatory = $False, ParameterSetName = "Index")]
    [Int]$ImageIndex = -1,
    [parameter(Mandatory = $False, ParameterSetName = "Index")]
    [Int]$SelectedImageIndex = -1,
    [parameter(Mandatory = $True, ParameterSetName = "Key")]
    [String]$ImageKey,
    [parameter(Mandatory = $False, ParameterSetName = "Key")]
    [String]$SelectedImageKey,
    [String]$ToolTip,
    [switch]$AtTop,
    [switch]$Checked,
    [switch]$Expand,
    [switch]$AddChild,
    [switch]$PassThru
  )
  Write-Verbose -Message "Enter Function New-TreeNode"
  Try
  {
    #region $TempTreeNode = System.Windows.Forms.TreeNode
    if ($AddChild.IsPresent)
    {
      $TempTreeNode = New-Object -TypeName System.Windows.Forms.TreeNode($Text, [System.Windows.Forms.TreeNode[]](@("$*$")))
    }
    else
    {
      $TempTreeNode = New-Object -TypeName System.Windows.Forms.TreeNode($Text)
    }
    if ($AtTop.IsPresent)
    {
      [Void]$TreeNode.Nodes.Insert(0, $TempTreeNode)
    }
    else
    {
      [Void]$TreeNode.Nodes.Add($TempTreeNode)
    }
    $TempTreeNode.Checked = $Checked
    $TempTreeNode.BackColor = $BackColor
    $TempTreeNode.ForeColor = $ForeColor
    If ($PSBoundParameters.ContainsKey("Name"))
    {
      $TempTreeNode.Name = $Name
    }
    else
    {
      $TempTreeNode.Name = $Text
    }
    $TempTreeNode.Tag = $Tag
    $TempTreeNode.NodeFont = New-Object -TypeName System.Drawing.Font($FontFamily, $FontSize, $FontStyle, [System.Drawing.GraphicsUnit]::Point)
    Switch ($PSCmdlet.ParameterSetName)
    {
      "Index"
      {
        if ($ImageIndex -gt -1)
        {
          $TempTreeNode.ImageIndex = $ImageIndex
          $TempTreeNode.StateImageIndex = $ImageIndex
          if ($SelectedImageIndex -eq -1)
          {
            $TempTreeNode.SelectedImageIndex = $ImageIndex
          }
          else
          {
            $TempTreeNode.SelectedImageIndex = $SelectedImageIndex
          }
        }
        Break
      }
      "Key"
      {
        $TempTreeNode.ImageKey = $ImageKey
        $TempTreeNode.StateImageKey = $ImageKey
        if ($PSBoundParameters.ContainsKey("SelectedImageKey"))
        {
          $TempTreeNode.SelectedImageKey = $SelectedImageKey
        }
        else
        {
          $TempTreeNode.SelectedImageKey = $ImageKey
        }
        Break
      }
    }
    $TempTreeNode.ToolTipText = $ToolTip
    #endregion
    if ($Expand.IsPresent)
    {
      $TempTreeNode.Expand()
    }
    If ($PassThru.IsPresent)
    {
      $TempTreeNode
    }
    $TempTreeNode = $Null
    [System.GC]::Collect()
    [System.GC]::WaitForPendingFinalizers()
  }
  Catch
  {
    Write-Debug -Message "ErrMsg: $($Error[0].Exception.Message)"
    Write-Debug -Message "Line: $($Error[0].InvocationInfo.ScriptLineNumber)"
    Write-Debug -Message "Code:$($Error[0].InvocationInfo.Line)"
  }
  Write-Verbose -Message "Exit Function New-TreeNode"
}
#endregion function New-TreeNode

#region function New-MenuItem
function New-MenuItem()
{
  <#
    .SYNOPSIS
      Makes and Adds a New MenuItem for a Menu or ToolStrip Control
    .DESCRIPTION
      Makes and Adds a New MenuItem for a Menu or ToolStrip Control
    .PARAMETER Control
    .PARAMETER Text
    .PARAMETER Name
    .PARAMETER ToolTip
    .PARAMETER Icon
    .PARAMETER DisplayStyle
    .PARAMETER Alignment
    .PARAMETER Tag
    .PARAMETER Disable
    .PARAMETER Check
    .PARAMETER ClickOnCheck
    .PARAMETER ShortcutKeys
    .PARAMETER Disable
    .PARAMETER FontFamily
    .PARAMETER FontSize
    .PARAMETER FontStyle
    .PARAMETER BackColor
    .PARAMETER ForeColor
    .PARAMETER PassThru
    .EXAMPLE
      $NewItem = New-MenuItem -Text "Text" -Tag "Tag"
    .NOTES
      Original Function By Ken Sweet
    .LINK
  #>
  [CmdletBinding()]
  param (
    [parameter(Mandatory = $True)]
    [Object]$Menu,
    [parameter(Mandatory = $True)]
    [String]$Text,
    [String]$Name,
    [String]$ToolTip,
    [System.Drawing.Icon]$Icon,
    [System.Windows.Forms.ToolStripItemDisplayStyle]$DisplayStyle = "Text",
    [System.Drawing.ContentAlignment]$Alignment = "MiddleCenter",
    [Object]$Tag,
    [Switch]$Disable,
    [Switch]$Check,
    [Switch]$ClickOnCheck,
    [System.Windows.Forms.Keys]$ShortcutKeys = "None",
    [System.Drawing.FontFamily]$FontFamily = $MyDMConfig.FontFamily,
    [Int]$FontSize = $MyDMConfig.FontSize,
    [System.Drawing.FontStyle]$FontStyle = "Regular",
    [System.Drawing.Color]$BackColor = $MyDMColor.BackColor,
    [System.Drawing.Color]$ForeColor = $MyDMColor.ForeColor,
    [switch]$PassThru
  )
  Write-Verbose -Message "Enter Function New-MenuItem"
  Try
  {
    #region $TempMenuItem = System.Windows.Forms.ToolStripMenuItem
    Write-Verbose -Message "Creating Form Control `$TempMenuItem"
    $TempMenuItem = New-Object -TypeName System.Windows.Forms.ToolStripMenuItem($Text)
    if ($Menu.GetType().Name -eq "ToolStripMenuItem")
    {
      [Void]$Menu.DropDownItems.Add($TempMenuItem)
    }
    else
    {
      [Void]$Menu.Items.Add($TempMenuItem)
    }
    $TempMenuItem.TextAlign = $Alignment
    $TempMenuItem.BackColor = $BackColor
    $TempMenuItem.Checked = $Check
    $TempMenuItem.CheckOnClick = $ClickOnCheck
    $TempMenuItem.DisplayStyle = $DisplayStyle
    $TempMenuItem.Enabled = (-not $Disable)
    $TempMenuItem.Font = New-Object -TypeName System.Drawing.Font($FontFamily, $FontSize, $FontStyle, [System.Drawing.GraphicsUnit]::Point)
    $TempMenuItem.ForeColor = $ForeColor
    if ($PSBoundParameters.ContainsKey("Icon"))
    {
      $TempMenuItem.Image = $Icon
      $TempMenuItem.ImageAlign = $Alignment
      $TempMenuItem.TextImageRelation = [System.Windows.Forms.TextImageRelation]::ImageBeforeText
    }
    else
    {
      $TempMenuItem.TextImageRelation = [System.Windows.Forms.TextImageRelation]::TextBeforeImage
    }
    If ($PSBoundParameters.ContainsKey("Name"))
    {
      $TempMenuItem.Name = $Name
    }
    else
    {
      $TempMenuItem.Name = $Text
    }
    $TempMenuItem.ShortcutKeys = $ShortcutKeys
    $TempMenuItem.Tag = $Tag
    $TempMenuItem.ToolTipText = $ToolTip
    #endregion
    If ($PassThru)
    {
      $TempMenuItem
    }
    $TempMenuItem = $Null
    [System.GC]::Collect()
    [System.GC]::WaitForPendingFinalizers()
  }
  Catch
  {
    Write-Debug -Message "ErrMsg: $($Error[0].Exception.Message)"
    Write-Debug -Message "Line: $($Error[0].InvocationInfo.ScriptLineNumber)"
    Write-Debug -Message "Code:$($Error[0].InvocationInfo.Line)"
  }
  Write-Verbose -Message "Exit Function New-MenuItem"
}
#endregion function New-MenuItem

#region function New-MenuLabel
function New-MenuLabel()
{
  <#
    .SYNOPSIS
      Makes and Adds a New MenuLabel for a Menu or ToolStrip Control
    .DESCRIPTION
      Makes and Adds a New MenuLabel for a Menu or ToolStrip Control
    .PARAMETER Control
    .PARAMETER Text
    .PARAMETER Name
    .PARAMETER ToolTip
    .PARAMETER Icon
    .PARAMETER DisplayStyle
    .PARAMETER Alignment
    .PARAMETER Tag
    .PARAMETER Disable
    .PARAMETER FontFamily
    .PARAMETER FontSize
    .PARAMETER FontStyle
    .PARAMETER BackColor
    .PARAMETER ForeColor
    .PARAMETER PassThru
    .EXAMPLE
      $NewItem = New-MenuLabel -Text "Text" -Tag "Tag"
    .NOTES
      Original Function By Ken Sweet
    .LINK
  #>
  [CmdletBinding()]
  param (
    [parameter(Mandatory = $True)]
    [Object]$Menu,
    [parameter(Mandatory = $True)]
    [String]$Text,
    [String]$Name,
    [String]$ToolTip,
    [System.Drawing.Icon]$Icon,
    [System.Windows.Forms.ToolStripItemDisplayStyle]$DisplayStyle = "Text",
    [System.Drawing.ContentAlignment]$Alignment = "MiddleCenter",
    [Object]$Tag,
    [Switch]$Disable,
    [System.Drawing.FontFamily]$FontFamily = $MyDMConfig.FontFamily,
    [Int]$FontSize = $MyDMConfig.FontSize,
    [System.Drawing.FontStyle]$FontStyle = "Regular",
    [System.Drawing.Color]$BackColor = $MyDMColor.BackColor,
    [System.Drawing.Color]$ForeColor = $MyDMColor.ForeColor,
    [switch]$PassThru
  )
  Write-Verbose -Message "Enter Function New-MenuLabel"
  Try
  {
    #region $TempMenuLabel = System.Windows.Forms.ToolStripMenuLabel
    Write-Verbose -Message "Creating Form Control `$TempMenuLabel"
    $TempMenuLabel = New-Object -TypeName System.Windows.Forms.ToolStripLabel($Text)
    if ($Menu.GetType().Name -eq "ToolStripMenuItem")
    {
      [Void]$Menu.DropDownItems.Add($TempMenuLabel)
    }
    else
    {
      [Void]$Menu.Items.Add($TempMenuLabel)
    }
    $TempMenuLabel.TextAlign = $Alignment
    $TempMenuLabel.BackColor = $BackColor
    $TempMenuLabel.DisplayStyle = $DisplayStyle
    $TempMenuLabel.Enabled = (-not $Disable)
    $TempMenuLabel.Font = New-Object -TypeName System.Drawing.Font($FontFamily, $FontSize, $FontStyle, [System.Drawing.GraphicsUnit]::Point)
    $TempMenuLabel.ForeColor = $ForeColor
    if ($PSBoundParameters.ContainsKey("Icon"))
    {
      $TempMenuLabel.Image = $Icon
      $TempMenuLabel.ImageAlign = $Alignment
      $TempMenuLabel.TextImageRelation = [System.Windows.Forms.TextImageRelation]::ImageBeforeText
    }
    else
    {
      $TempMenuLabel.TextImageRelation = [System.Windows.Forms.TextImageRelation]::TextBeforeImage
    }
    If ($PSBoundParameters.ContainsKey("Name"))
    {
      $TempMenuLabel.Name = $Name
    }
    else
    {
        $TempMenuLabel.Name = $Text
    }
    $TempMenuLabel.Tag = $Tag
    $TempMenuLabel.ToolTipText = $ToolTip
    #endregion
    If ($PassThru)
    {
      $TempMenuLabel
    }
    $TempMenuLabel = $Null
    [System.GC]::Collect()
    [System.GC]::WaitForPendingFinalizers()
  }
  Catch
  {
    Write-Debug -Message "ErrMsg: $($Error[0].Exception.Message)"
    Write-Debug -Message "Line: $($Error[0].InvocationInfo.ScriptLineNumber)"
    Write-Debug -Message "Code:$($Error[0].InvocationInfo.Line)"
  }
  Write-Verbose -Message "Exit Function New-MenuLabel"
}
#endregion function New-MenuLabel

#region function New-MenuSeparator
function New-MenuSeparator()
{
  <#
    .SYNOPSIS
      Makes and Adds a New MenuSeparator for a Menu or ToolStrip Control
    .DESCRIPTION
      Makes and Adds a New MenuSeparator for a Menu or ToolStrip Control
    .PARAMETER Menu
    .PARAMETER BackColor
    .PARAMETER ForeColor
    .EXAMPLE
      New-MenuSeparator -Menu $Menu
    .NOTES
      Original Function By Ken Sweet
    .LINK
  #>
  [CmdletBinding()]
  param(
    [parameter(Mandatory = $True)]
    [Object]$Menu,
    [System.Drawing.Color]$BackColor = $MyDMColor.BackColor,
    [System.Drawing.Color]$ForeColor = $MyDMColor.ForeColor
  )
  Write-Verbose -Message "Enter Function New-MenuSeparator"
  Try
  {
    #region $TempSeparator = System.Windows.Forms.ToolStripSeparator
    Write-Verbose -Message "Creating Form Control `$TempSeparator"
    $TempSeparator = New-Object -TypeName System.Windows.Forms.ToolStripSeparator
    if ($Menu.GetType().Name -eq "ToolStripMenuItem")
    {
      [Void]$Menu.DropDownItems.Add($TempSeparator)
    }
    else
    {
      [Void]$Menu.Items.Add($TempSeparator)
    }
    $TempSeparator.BackColor = $BackColor
    $TempSeparator.ForeColor = $ForeColor
    $TempSeparator.Name = "TempSeparator"
    $TempSeparator.Text = "TempSeparator"
    #endregion
    $TempSeparator = $Null
    [System.GC]::Collect()
    [System.GC]::WaitForPendingFinalizers()
  }
  Catch
  {
    Write-Debug -Message "ErrMsg: $($Error[0].Exception.Message)"
    Write-Debug -Message "Line: $($Error[0].InvocationInfo.ScriptLineNumber)"
    Write-Debug -Message "Code:$($Error[0].InvocationInfo.Line)"
  }
  Write-Verbose -Message "Exit Function New-MenuSeparator"
}
#endregion function New-MenuSeparator

#region function New-ListViewItem
function New-ListViewItem()
{
  <#
    .SYNOPSIS
      Makes and adds a New ListViewItem to a ListView Control
    .DESCRIPTION
      Makes and adds a New ListViewItem to a ListView Control
    .PARAMETER ListView
    .PARAMETER BackColor
    .PARAMETER ForeColor
    .PARAMETER FontFamily
    .PARAMETER FontSize
    .PARAMETER FontStyle
    .PARAMETER Name
    .PARAMETER Text
    .PARAMETER SubItems
    .PARAMETER Tag
    .PARAMETER IndentCount
    .PARAMETER ImageIndex
    .PARAMETER Imagekey
    .PARAMETER Group
    .PARAMETER ToolTip
    .PARAMETER Checked
    .PARAMETER PassThru
    .EXAMPLE
      $NewItem = New-ListViewItem -ListView $listView -Text "Text" -Tag "Tag"
    .NOTES
      Original Function By Ken Sweet
    .LINK
  #>
  [CmdletBinding(DefaultParameterSetName = "Default")]
  param(
    [parameter(Mandatory = $True)]
    [System.Windows.Forms.ListView]$ListView,
    [System.Drawing.Color]$BackColor = $MyDMColor.TextBackColor,
    [System.Drawing.Color]$ForeColor = $MyDMColor.TextForeColor,
    [System.Drawing.FontFamily]$FontFamily = $MyDMConfig.FontFamily,
    [String]$FontSize = $MyDMConfig.FontSize,
    [System.Drawing.FontStyle]$FontStyle = "Regular",
    [String]$Name,
    [parameter(Mandatory = $True)]
    [String]$Text,
    [String[]]$SubItems,
    [Object]$Tag,
    [parameter(Mandatory = $False, ParameterSetName = "Index")]
    [parameter(Mandatory = $False, ParameterSetName = "Key")]
    [Int]$IndentCount = 0,
    [parameter(Mandatory = $True, ParameterSetName = "Index")]
    [Int]$ImageIndex = -1,
    [parameter(Mandatory = $True, ParameterSetName = "Key")]
    [String]$ImageKey,
    [Object]$Group,
    [String]$ToolTip,
    [Switch]$Checked,
    [Switch]$PassThru
  )
  Write-Verbose -Message "Enter Function New-ListViewItem"
  Try
  {
    #region $TempListViewItem = System.Windows.Forms.ListViewItem
    if ($PSCmdlet.ParameterSetName -eq "Default")
    {
      $TempListViewItem = New-Object -TypeName System.Windows.Forms.ListViewItem($Text, $Group)
    }
    else
    {
      if ($PSCmdlet.ParameterSetName -eq "Index")
      {
        $TempListViewItem = New-Object -TypeName System.Windows.Forms.ListViewItem($Text, $ImageIndex, $Group)
      }
      else
      {
        $TempListViewItem = New-Object -TypeName System.Windows.Forms.ListViewItem($Text, $ImageKey, $Group)
      }
      $TempListViewItem.IndentCount = $IndentCount
    }
    $TempListViewItem.BackColor = $BackColor
    $TempListViewItem.ForeColor = $ForeColor
    $TempListViewItem.Font = New-Object -TypeName System.Drawing.Font($FontFamily, $FontSize, $FontStyle, [System.Drawing.GraphicsUnit]::Point)
    if ($PSBoundParameters.ContainsKey("Name"))
    {
      $TempListViewItem.Name = $Name
    }
    else
    {
      $TempListViewItem.Name = $Text
    }
    $TempListViewItem.Tag = $Tag
    if ($PSBoundParameters.ContainsKey("SubItems"))
    {
      $TempListViewItem.SubItems.AddRange($SubItems)
    }
    $TempListViewItem.ToolTipText = $ToolTip
    $TempListViewItem.Checked = $Checked.IsPresent
    #endregion
    If ($PassThru.IsPresent)
    {
      $TempListViewItem
    }
    Else
    {
      [Void]$ListView.Items.Add($TempListViewItem)
    }
    $TempListViewItem = $Null
    [System.GC]::Collect()
    [System.GC]::WaitForPendingFinalizers()
  }
  Catch
  {
    Write-Debug -Message "ErrMsg: $($Error[0].Exception.Message)"
    Write-Debug -Message "Line: $($Error[0].InvocationInfo.ScriptLineNumber)"
    Write-Debug -Message "Code:$($Error[0].InvocationInfo.Line)"
  }
  Write-Verbose -Message "Exit Function New-ListViewItem"
}
#endregion function New-ListViewItem

#region function New-ColumnHeader
function New-ColumnHeader()
{
  <#
    .SYNOPSIS
      Makes and Adds a New ColumnHeader for a ListView Control
    .DESCRIPTION
      Makes and Adds a New ColumnHeader for a ListView Control
    .PARAMETER ListView
    .PARAMETER Text
    .PARAMETER Tag
    .PARAMETER Width
    .PARAMETER PassThru
    .EXAMPLE
      $NewItem = New-ColumnHeader -Text "Text" -Tag "Tag"
    .NOTES
      Original Function By Ken Sweet
    .LINK
  #>
  [CmdletBinding()]
  param(
    [parameter(Mandatory = $True)]
    [System.Windows.Forms.ListView]$ListView,
    [parameter(Mandatory = $True)]
    [String]$Text,
    [Object]$Tag,
    [Int]$Width = -2,
    [switch]$PassThru
  )
  Write-Verbose -Message "Enter Function New-ColumnHeader"
  Try
  {
    #region $TempColumnHeader = System.Windows.Forms.ColumnHeader
    $TempColumnHeader = New-Object -TypeName System.Windows.Forms.ColumnHeader
    [Void]$ListView.Columns.Add($TempColumnHeader)
    $TempColumnHeader.Tag = $Tag
    $TempColumnHeader.Text = $Text
    $TempColumnHeader.Name = $Text
    $TempColumnHeader.Width = $Width
    #endregion
    If ($PassThru)
    {
      $TempColumnHeader
    }
    $TempColumnHeader = $Null
    [System.GC]::Collect()
    [System.GC]::WaitForPendingFinalizers()
  }
  Catch
  {
    Write-Debug -Message "ErrMsg: $($Error[0].Exception.Message)"
    Write-Debug -Message "Line: $($Error[0].InvocationInfo.ScriptLineNumber)"
    Write-Debug -Message "Code:$($Error[0].InvocationInfo.Line)"
  }
  Write-Verbose -Message "Exit Function New-ColumnHeader"
}
#endregion function New-ColumnHeader

#region function Set-MyClipboard
function Set-MyClipboard()
{
  <#
    .SYNOPSIS
      Copies Object Data to the ClipBoard
    .DESCRIPTION
      Copies Object Data to the ClipBoard
    .PARAMETER MyData
    .PARAMETER Title
    .PARAMETER TitleColor
    .PARAMETER Columns
    .PARAMETER ColumnColor
    .PARAMETER RowEven
    .PARAMETER RowOdd
    .PARAMETER OfficeFix
    .PARAMETER PassThru
    .EXAMPLE
      Set-MyClipBoard -MyData $MyData -Title "This is My Title"
    .EXAMPLE
      $MyData | Set-MyClipBoard -Title "This is My Title"
    .EXAMPLE
      Set-MyClipBoard -MyData $MyData -Title "This is My Title" -Property "Property1", "Property2", "Property3"
    .EXAMPLE
      Set-MyClipBoard -MyData $MyData -Title "This is My Title" -Columns ([Ordered@{"Property1" = "Left"; "Property2" = "Right"; "Property3" = "Center"})
    .NOTES
      Original Function By Ken Sweet
    .LINK
  #>
  [CmdletBinding(DefaultParameterSetName = "Default")]
  param (
    [parameter(Mandatory = $True, ValueFromPipeline = $True)]
    [Object[]]$MyData,
    [String]$Title,
    [String]$TitleColor = "DodgerBlue",
    [parameter(Mandatory = $True, ParameterSetName = "Columns")]
    [System.Collections.Specialized.OrderedDictionary]$Columns,
    [parameter(Mandatory = $True, ParameterSetName = "Names")]
    [String[]]$Property,
    [String]$ColumnColor = "SkyBlue",
    [String]$RowEven = "White",
    [String]$RowOdd = "Gainsboro",
    [Switch]$OfficeFix,
    [Switch]$PassThru
  )
  Begin
  {
    Write-Verbose -Message "Enter Function Set-MyClipboard Begin Block"
    
    $HTMLStringBuilder = New-Object -TypeName System.Text.StringBuilder
    
    [Void]$HTMLStringBuilder.Append("Version:1.0`r`nStartHTML:000START`r`nEndHTML:00000END`r`nStartFragment:00FSTART`r`nEndFragment:0000FEND`r`n")
    [Void]$HTMLStringBuilder.Replace("000START", ("{0:X8}" -f $HTMLStringBuilder.Length))
    [Void]$HTMLStringBuilder.Append("<html><head><style>`r`nth { text-align: center; color: black; font: bold; background:$ColumnColor; }`r`ntd:nth-child(1) { text-align:right; }`r`ntable, th, td { border: 1px solid black; border-collapse: collapse; }`r`ntr:nth-child(odd) {background: $RowEven;}`r`ntr:nth-child($RowOdd) {background: gainsboro;}`r`n</style><title>$Title</title></head><body><!--StartFragment-->")
    [Void]$HTMLStringBuilder.Replace("00FSTART", ("{0:X8}" -f $HTMLStringBuilder.Length))
    
    $ObjectList = New-Object -TypeName System.Collections.ArrayList
    
    $GetColumns = $True
    
    Write-Verbose -Message "Exit Function Set-MyClipboard Begin Block"
  }
  Process
  {
    Write-Verbose -Message "Enter Function Set-MyClipboard Process Block"
    
    if ($GetColumns)
    {
      $Cols = [Ordered]@{ }
      Switch ($PSCmdlet.ParameterSetName)
      {
        "Columns"
        {
          $Cols = $Columns
          Break
        }
        "Names"
        {
          $Property | ForEach-Object -Process { $Cols.Add($PSItem, "Left") }
          Break
        }
        Default
        {
          $MyData[0].PSObject.Properties | Where-Object -FilterScript { $PSItem.MemberType -match "Property|NoteProperty" } | ForEach-Object -Process { $Cols.Add($PSItem.Name, "Left") }
          Break
        }
      }
      $ColNames = @($Cols.Keys)
      $GetColumns = $False
    }
    
    $ObjectList.AddRange(@($MyData | Select-Object -Property $ColNames))
    
    if ($PassThru.IsPresent)
    {
      $MyData
    }
    
    Write-Verbose -Message "Exit Function Set-MyClipboard Process Block"
  }
  End
  {
    Write-Verbose -Message "Enter Function Set-MyClipboard End Block"
    
    if ($OfficeFix.IsPresent)
    {
      if ($PSBoundParameters.ContainsKey("Title"))
      {
        [Void]$HTMLStringBuilder.Append("<table><tr><th style='background:$TitleColor;' colspan='$($Cols.Keys.Count)'>&nbsp;$($Title)&nbsp;</th></tr>")
      }
      else
      {
        [Void]$HTMLStringBuilder.Append("<table>")
      }
      [Void]$HTMLStringBuilder.Append(("<tr style='background:$ColumnColor;'><th>&nbsp;" + ($Cols.Keys -join "&nbsp;</th><th>&nbsp;") + "&nbsp;</th></tr>"))
      $Row = -1
      $RowColor = @($RowEven, $RowOdd)
      ForEach ($Item in $ObjectList)
      {
        [Void]$HTMLStringBuilder.Append("<tr style='background: $($RowColor[($Row = ($Row + 1) % 2)])'>")
        ForEach ($Key in $Cols.Keys)
        {
          [Void]$HTMLStringBuilder.Append("<td style='text-align:$($Cols[$Key])'>&nbsp;$($Item.$Key)&nbsp;</td>")
        }
        [Void]$HTMLStringBuilder.Append("</tr>")
      }
      [Void]$HTMLStringBuilder.Append("</table><br><br>")
    }
    else
    {
      [Void]$HTMLStringBuilder.Append(($ObjectList | ConvertTo-Html -Property $ColNames -Fragment | Out-String))
    }
    [Void]$HTMLStringBuilder.Replace("0000FEND", ("{0:X8}" -f $HTMLStringBuilder.Length))
    [Void]$HTMLStringBuilder.Append("<!--EndFragment--></body></html>")
    [Void]$HTMLStringBuilder.Replace("00000END", ("{0:X8}" -f $HTMLStringBuilder.Length))
    
    [System.Windows.Forms.Clipboard]::Clear()
    $DataObject = New-Object -TypeName System.Windows.Forms.DataObject
    $DataObject.SetData("Text", ($ObjectList | Select-Object -Property $ColNames | ConvertTo-Csv -NoTypeInformation | Out-String))
    $DataObject.SetData("HTML Format", $HTMLStringBuilder.ToString())
    [System.Windows.Forms.Clipboard]::SetDataObject($DataObject)
    
    $ObjectList = $Null
    $HTMLStringBuilder = $Null
    $DataObject = $Null
    $Cols = $Null
    $ColNames = $Null
    $Row = $Null
    $RowColor = $Null
    
    [System.GC]::Collect()
    [System.GC]::WaitForPendingFinalizers()
    
    Write-Verbose -Message "Exit Function Set-MyClipboard End Block"
  }
}
#endregion function Set-MyClipboard

#region function Compress-MyData
function Compress-MyData()
{
  <#
    .SYNOPSIS
      Compress String Data
    .DESCRIPTION
      Compress String Data
    .PARAMETER Data
      Data to Compress
    .PARAMETER LineLength
      Max Line Length
    .INPUTS
    .OUTPUTS
    .EXAMPLE
      Compress-MyData -Data "String"
    .NOTES
    .LINK
  #>
  [CmdletBinding()]
  param (
    [parameter(Mandatory = $True)]
    [String]$Data,
    [Int]$LineLength = 160
  )
  Write-Verbose -Message "Enter Function Compress-MyData"
  Try
  {
    $MemoryStream = New-Object -TypeName System.IO.MemoryStream
    $GZipStream = New-Object -TypeName System.IO.Compression.GZipStream($MemoryStream, [System.IO.Compression.CompressionMode]::Compress)
    $StreamWriter = New-Object -TypeName System.IO.StreamWriter($GZipStream, [System.Text.Encoding]::UTF8)
    $StreamWriter.Write($Data)
    $StreamWriter.Close()
    $Code = New-Object -TypeName System.Text.StringBuilder
    ForEach ($Line in @([System.Convert]::ToBase64String($MemoryStream.ToArray()) -split "(?<=\G.{$LineLength})(?=.)"))
    {
      [Void]$Code.AppendLine($Line)
    }
    $Code.ToString()
    $GZipStream.Close()
    $MemoryStream.Close()
    $MemoryStream = $Null
    $GZipStream = $Null
    $StreamWriter = $Null
    $Code = $Null
    $Line = $Null
    [System.GC]::Collect()
    [System.GC]::WaitForPendingFinalizers()
  }
  Catch
  {
    Write-Debug -Message "ErrMsg: $($Error[0].Exception.Message)"
    Write-Debug -Message "Line: $($Error[0].InvocationInfo.ScriptLineNumber)"
    Write-Debug -Message "Code:$($Error[0].InvocationInfo.Line)"
  }
  Write-Verbose -Message "Exit Function Compress-MyData"
}
#endregion function Compress-MyData

#region function Decompress-MyData
function Decompress-MyData()
{
  <#
    .SYNOPSIS
      Decompress Compresed String Data
    .DESCRIPTION
      Decompress Compresed String Data
    .PARAMETER Data
      Data to Decompress
    .INPUTS
    .OUTPUTS
    .EXAMPLE
      Decompress-MyData -Data "String"
    .NOTES
    .LINK
  #>
  [CmdletBinding()]
  param (
    [parameter(Mandatory = $True)]
    [String]$Data,
    [Switch]$AsString
  )
  Write-Verbose -Message "Enter Function Decompress-MyData"
  Try
  {
    $CompressedData = [System.Convert]::FromBase64String($Data)
    $MemoryStream = New-Object -TypeName System.IO.MemoryStream
    $MemoryStream.Write($CompressedData, 0, $CompressedData.Length)
    [Void]$MemoryStream.Seek(0, 0)
    $GZipStream = New-Object -TypeName System.IO.Compression.GZipStream($MemoryStream, [System.IO.Compression.CompressionMode]::Decompress)
    $StreamReader = New-Object -TypeName System.IO.StreamReader($GZipStream, [System.Text.Encoding]::UTF8)
    if ($AsString.IsPresent)
    {
      $StreamReader.ReadToEnd()
    }
    else
    {
      $ArrayList = New-Object -TypeName System.Collections.ArrayList
      $Buffer = New-Object -TypeName System.Char[] -ArgumentList 4096
      While ($StreamReader.EndOfStream -eq $False)
      {
        $Bytes = $StreamReader.Read($Buffer, 0, 4096)
        if ($Bytes)
        {
          $ArrayList.AddRange($Buffer[0..($Bytes - 1)])
        }
      }
      $ArrayList
      $ArrayList.Clear()
    }
    $StreamReader.Close()
    $GZipStream.Close()
    $MemoryStream.Close()
    $MemoryStream = $Null
    $GZipStream = $Null
    $StreamReader = $Null
    $CompressedData = $Null
    $ArrayList = $Null
    $Buffer = $Null
    $Bytes = $Null
    [System.GC]::Collect()
    [System.GC]::WaitForPendingFinalizers()
  }
  Catch
  {
    Write-Debug -Message "ErrMsg: $($Error[0].Exception.Message)"
    Write-Debug -Message "Line: $($Error[0].InvocationInfo.ScriptLineNumber)"
    Write-Debug -Message "Code:$($Error[0].InvocationInfo.Line)"
  }
  Write-Verbose -Message "Exit Function Decompress-MyData"
}
#endregion function Decompress-MyData

#region function Verify-MyWorkstation
function Verify-MyWorkstation()
{
  <#
    .SYNOPSIS
      Verify Remote Workstation is the Correct One
    .DESCRIPTION
      Verify Remote Workstation is the Correct One
    .PARAMETER ComputerName
      Name of the Computer to Verify
    .PARAMETER Credential
      Credentials to use when connecting to the Remote Computer
    .PARAMETER Wait
      How Long to Wait for Job to be Completed
    .PARAMETER Serial
      Return Serial Number
    .PARAMETER Mobile
      Check if System is Desktop / Laptop
    .EXAMPLE
      Verify-MyWorkstation -ComputerName "MyWorkstation"
    .NOTES
      Original Function By Ken Sweet
    .LINK
  #>
  [CmdletBinding()]
  param (
    [parameter(Mandatory = $False, ValueFromPipeline = $True, ValueFromPipelineByPropertyName = $True)]
    [String[]]$ComputerName = [System.Environment]::MachineName,
    [PSCredential]$Credential,
    [ValidateRange(30, 300)]
    [Int]$Wait = 120,
    [Switch]$Serial,
    [Switch]$Mobile
  )
  Begin
  {
    Write-Verbose -Message "Enter Function Verify-MyWorkstation"

    # Primay Job Script to Verify Computer Name and WMI Functionality and Return Commonly used Properties
    # Accepts ComputerName and Credentials as Parameters to make connection to remote computer
    #region ******** $MyCompDataJob ScriptBlock ********
    $MyCompDataJob = {
      param (
        [HashTable]$Params
      )
      $ErrorActionPreference = "Stop"
      Try
      {
        Write-Output -InputObject (Get-WmiObject @Params -Class Win32_ComputerSystem | Select-Object -Property "UserName", "Name", "PartOfDomain", "Domain", "Manufacturer", "Model", "TotalPhysicalMemory", @{ "Name" = "Error"; "Expression" = { $False } }, @{ "Name" = "ErrorMessage"; "Expression" = { "" } })
      }
      Catch
      {
        Write-Output -InputObject ([PSCustomObject]@{ "Error" = $True; "ErrorMessage" = $($Error[0]) })
      }
    }
    #endregion

    # Secondary Job Script to Verify WMI Functionality and Return Commonly used Properties
    # Accepts ComputerName and Credentials as Parameters to make connection to remote computer
    #region ******** $MyOSDataJob ScriptBlock ********
    $MyOSDataJob = {
      param (
        [HashTable]$Params
      )
      $ErrorActionPreference = "Stop"
      Try
      {
        Write-Output -InputObject (Get-WmiObject @Params -Class Win32_OperatingSystem | Select-Object -Property "Caption", "CSDVersion", "OSArchitecture", "ProductType", "LocalDateTime", "InstallDate", "LastBootUpTime", @{ "Name" = "Error"; "Expression" = { $False } }, @{ "Name" = "ErrorMessage"; "Expression" = { "" } })
      }
      Catch
      {
        Write-Output -InputObject ([PSCustomObject]@{ "Error" = $True; "ErrorMessage" = $($Error[0]) })
      }
    }
    #endregion

    # Optional SerialNumber Job Script to Return Computer Serial Number
    # Accepts ComputerName and Credentials as Parameters to make connection to remote computer
    #region ******** $MyBIOSDataJob ScriptBlock ********
    $MyBIOSDataJob = {
      param (
        [HashTable]$Params
      )
      $ErrorActionPreference = "Stop"
      Try
      {
        Write-Output -InputObject (Get-WmiObject @Params -Class Win32_Bios | Select-Object -Property "SerialNumber", @{ "Name" = "Error"; "Expression" = { $False } }, @{ "Name" = "ErrorMessage"; "Expression" = { "" } })
      }
      Catch
      {
        Write-Output -InputObject ([PSCustomObject]@{ "Error" = $True; "ErrorMessage" = $($Error[0]) })
      }
    }
    #endregion

    # Optional Mobile / ChassiType Job Script to Return Computer ChassisType (Desktop / Laptop)
    # Accepts ComputerName and Credentials as Parameters to make connection to remote computer
    #region ******** $MyChassisDataJob ScriptBlock ********
    $MyChassisDataJob = {
      param (
        [HashTable]$Params
      )
      $ErrorActionPreference = "Stop"
      Try
      {
        Write-Output -InputObject ([PSCustomObject]@{ "IsMobile" = $((@(8, 9, 10, 11, 12, 14) -contains (((Get-WmiObject @Params -Class Win32_SystemEnclosure).ChassisTypes)[0]))); "Error" = $False; "ErrorMessage" = "" })
      }
      Catch
      {
        Write-Output -InputObject ([PSCustomObject]@{ "Error" = $True; "ErrorMessage" = $($Error[0]) })
      }
    }
    #endregion
  }
  Process
  {
    Write-Verbose -Message "Enter Function Verify-MyWorkstation - Process"

    ForEach ($Computer in $ComputerName)
    {
      # Used to Calculate Verify Time
      $StartTime = [DateTime]::Now

      # Default Custom Object for the Verify Function to Return, Since it will always return a value I create the Object with the default error / failure values and update the poperties as needed
      #region ******** Custom Return Object $VerifyObject ********
      $VerifyObject = [PSCustomObject]@{
        "ComputerName" = $Computer.ToUpper();
        "Found" = $False;
        "UserName" = "";
        "Domain" = "";
        "DomainMember" = "";
        "ProductType" = 0;
        "Manufacturer" = "";
        "Model" = "";
        "IsMobile" = $False;
        "SerialNumber" = "";
        "Memory" = "";
        "OperatingSystem" = "";
        "ServicePack" = "";
        "Architecture" = "";
        "LocalDateTime" = "";
        "InstallDate" = "";
        "LastBootUpTime" = "";
        "IPAddress" = "";
        "Status" = "Off-Line";
        "Time" = [TimeSpan]::Zero;
        "ErrorMessage" = ""
      }
      #endregion

      if ($Computer -match "^(([a-zA-Z]|[a-zA-Z][a-zA-Z0-9\-]*[a-zA-Z0-9])\.)*([A-Za-z]|[A-Za-z][A-Za-z0-9\-]*[A-Za-z0-9])$")
      {
        Try
        {
          # Get IP Address from DNS, you want to do all remote checks using IP rather than ComputerName.  If you connect to a computer using the wrong name Get-WmiObject will fail and using the IP Address will not
          $IPAddresses = @([System.Net.Dns]::GetHostAddresses($Computer) | Where-Object -FilterScript { $_.AddressFamily -eq [System.Net.Sockets.AddressFamily]::InterNetwork } | Select-Object -ExpandProperty IPAddressToString)
          ForEach ($IPAddress in $IPAddresses)
          {
            # I think this is Faster than using Test-Connection
            if (((New-Object -TypeName System.Net.NetworkInformation.Ping).Send($IPAddress)).Status -eq [System.Net.NetworkInformation.IPStatus]::Success)
            {
              # Default Common Get-WmiObject Options
              if ($PSBoundParameters.ContainsKey("Credential"))
              {
                $Params = @{
                  "ComputerName" = $IPAddress;
                  "Credential" = $Credential
                }
              }
              else
              {
                $Params = @{
                  "ComputerName" = $IPAddress
                }
              }

              # Start Setting Return Values as they are Found
              $VerifyObject.Status = "On-Line"
              $VerifyObject.IPAddress = $IPAddress

              # Start Primary Job, Pass IP Address and Credentials to Job Script to make Connection to Remote Computer
              [Void]($MyJob = Start-Job -ArgumentList $Params -ScriptBlock $MyCompDataJob)
              # Wait for Job to Finish or Wait Time has Elasped
              [Void](Wait-Job -Job $MyJob -Timeout $Wait)

              # Check if Job is Complete and has Data
              if ($MyJob.State -eq "Completed" -and $MyJob.HasMoreData)
              {
                # Get Job Data
                $MyCompData = Get-Job -ID $MyJob.ID | Receive-Job -AutoRemoveJob -Wait -Force
                if ($MyCompData.Error)
                {
                  $VerifyObject.Status = "Verify Comp Error"
                  $VerifyObject.ErrorMessage = $MyCompData.ErrorMessage
                }
                else
                {
                  # Set Found Properties
                  $VerifyObject.ComputerName = "$($MyCompData.Name)"
                  $VerifyObject.UserName = "$($MyCompData.UserName)"
                  $VerifyObject.Domain = "$($MyCompData.Domain)"
                  $VerifyObject.DomainMember = "$($MyCompData.PartOfDomain)"
                  $VerifyObject.Manufacturer = "$($MyCompData.Manufacturer)"
                  $VerifyObject.Model = "$($MyCompData.Model)"
                  $VerifyObject.Memory = "$($MyCompData.TotalPhysicalMemory)"

                  # Verify Remote Computer is the Connect Computer, No need to get any more information
                  if ($MyCompData.Name -eq @($Computer.Split(".", [System.StringSplitOptions]::RemoveEmptyEntries))[0])
                  {
                    # Found Corrct Workstation
                    $VerifyObject.Found = $True

                    # Start Secondary Job, Pass IP Address and Credentials to Job Script to make Connection to Remote Computer
                    [Void]($MyJob = Start-Job -ArgumentList $Params -ScriptBlock $MyOSDataJob)
                    # Wait for Job to Finish or Wait Time has Elasped
                    [Void](Wait-Job -Job $MyJob -Timeout $Wait)

                    # Check if Job is Complete and has Data
                    if ($MyJob.State -eq "Completed" -and $MyJob.HasMoreData)
                    {
                      # Get Job Data
                      $MyOSData = Get-Job -ID $MyJob.ID | Receive-Job -AutoRemoveJob -Wait -Force
                      if ($MyOSData.Error)
                      {
                        $VerifyObject.Status = "Verify Operating System Error"
                        $VerifyObject.ErrorMessage = $MyOSData.ErrorMessage
                      }
                      else
                      {
                        # Set Found Properties
                        $VerifyObject.ProductType = $MyOSData.ProductType
                        $VerifyObject.OperatingSystem = "$($MyOSData.Caption)"
                        $VerifyObject.ServicePack = "$($MyOSData.CSDVersion)"
                        $VerifyObject.Architecture = $(if ([String]::IsNullOrEmpty($MyOSData.OSArchitecture)) { "32-bit" } else { "$($MyOSData.OSArchitecture)" })
                        $VerifyObject.LocalDateTime = [System.Management.ManagementDateTimeConverter]::ToDateTime($MyOSData.LocalDateTime)
                        $VerifyObject.InstallDate = [System.Management.ManagementDateTimeConverter]::ToDateTime($MyOSData.InstallDate)
                        $VerifyObject.LastBootUpTime = [System.Management.ManagementDateTimeConverter]::ToDateTime($MyOSData.LastBootUpTime)

                        # Optional SerialNumber Job
                        if ($Serial)
                        {
                          # Start Optional Job, Pass IP Address and Credentials to Job Script to make Connection to Remote Computer
                          [Void]($MyJob = Start-Job -ArgumentList $Params -ScriptBlock $MyBIOSDataJob)
                          # Wait for Job to Finish or Wait Time has Elasped
                          [Void](Wait-Job -Job $MyJob -Timeout $Wait)

                          # Check if Job is Complete and has Data
                          if ($MyJob.State -eq "Completed" -and $MyJob.HasMoreData)
                          {
                            # Get Job Data
                            $MyBIOSData = Get-Job -ID $MyJob.ID | Receive-Job -AutoRemoveJob -Wait -Force
                            if ($MyBIOSData.Error)
                            {
                              $VerifyObject.Status = "Verify SerialNumber Error"
                              $VerifyObject.ErrorMessage = $MyBIOSData.ErrorMessage
                            }
                            else
                            {
                              # Set Found Property
                              $VerifyObject.SerialNumber = "$($MyBIOSData.SerialNumber)"
                            }
                          }
                          else
                          {
                            $VerifyObject.Status = "Verify SerialNumber Error"
                            [Void](Remove-Job -Job $MyJob -Force)
                          }
                        }

                        # Optional Mobile / ChassisType Job
                        if ($Mobile)
                        {
                          # Start Optional Job, Pass IP Address and Credentials to Job Script to make Connection to Remote Computer
                          [Void]($MyJob = Start-Job -ArgumentList $Params -ScriptBlock $MyChassisDataJob)
                          # Wait for Job to Finish or Wait Time has Elasped
                          [Void](Wait-Job -Job $MyJob -Timeout $Wait)

                          # Check if Job is Complete and has Data
                          if ($MyJob.State -eq "Completed" -and $MyJob.HasMoreData)
                          {
                            # Get Job Data
                            $MyChassisData = Get-Job -ID $MyJob.ID | Receive-Job -AutoRemoveJob -Wait -Force
                            if ($MyChassisData.Error)
                            {
                              $VerifyObject.Status = "Verify is Mobile Error"
                              $VerifyObject.ErrorMessage = $MyChassisData.ErrorMessage
                            }
                            else
                            {
                              # Set Found Property
                              $VerifyObject.IsMobile = $($MyChassisData.IsMobile)
                            }
                          }
                          else
                          {
                            $VerifyObject.Status = "Verify is Mobile Error"
                            [Void](Remove-Job -Job $MyJob -Force)
                          }
                        }
                      }
                    }
                    else
                    {
                      $VerifyObject.Status = "Verify Operating System Error"
                      [Void](Remove-Job -Job $MyJob -Force)
                    }
                  }
                  else
                  {
                    $VerifyObject.Status = "Wrong Workstation Name"
                  }
                }
              }
              else
              {
                $VerifyObject.Status = "Verify Workstation Error"
                [Void](Remove-Job -Job $MyJob -Force)
              }
              # Beak out of Loop, Verify was a Success no need to try other IP Address is any
              Break
            }
          }
        }
        Catch
        {
          # Workstation Not in DNS
          $VerifyObject.Status = "Workstation Not in DNS"
        }
      }
      else
      {
        $VerifyObject.Status = "Invalid Computer Name"
      }

      # Calculate Verify Time
      $VerifyObject.Time = ([DateTime]::Now - $StartTime)

      # Return Custom Object with Collected Verify Information
      Write-Output -InputObject $VerifyObject

      $VerifyObject = $Null
      $Params = $Null
      $MyJob = $Null
      $MyCompData = $Null
      $MyOSData = $Null
      $MyBIOSData = $Null
      $MyChassisData = $Null
      $StartTime = $Null

      [System.GC]::Collect()
      [System.GC]::WaitForPendingFinalizers()
    }
    Write-Verbose -Message "Exit Function Verify-MyWorkstation - Process"
  }
  End
  {
    $MyCompDataJob = $Null
    $MyOSDataJob = $Null
    $MyBIOSDataJob = $Null
    $MyChassisDataJob = $Null

    [System.GC]::Collect()
    [System.GC]::WaitForPendingFinalizers()
    Write-Verbose -Message "Exit Function Verify-MyWorkstation"
  }
}
#endregion function Verify-MyWorkstation

#region function Write-MyLogFile
function Write-MyLogFile()
{
  <#
    .SYNOPSIS
    .DESCRIPTION
    .PARAMETER LogFile
    .PARAMETER Severity
    .PARAMETER Message
    .PARAMETER Context
    .PARAMETER Thread
    .EXAMPLE
      Write-MyLogFile -LogFile $LogFile -Message "This is My Info Log File Message"
    .EXAMPLE
      Write-MyLogFile -LogFile $LogFile -Severity "Info" -Message "This is My Info Log File Message"
    .EXAMPLE
      Write-MyLogFile -LogFile $LogFile -Severity "Warning" -Message "This is My Warning Log File Message"
    .EXAMPLE
      Write-MyLogFile -LogFile $LogFile -Severity "Error" -Message "This is My Error Log File Message"
    .NOTES
      Original Function By Ken Sweet
    .LINK
  #>
  [CmdletBinding()]
  param (
    [parameter(Mandatory = $True)]
    [ValidateScript({ [System.IO.Directory]::Exists([System.IO.Path]::GetDirectoryName($PSItem)) })]
    [String]$LogFile,
    [ValidateSet("Info", "Warning", "Error")]
    [String]$Severity = "Info",
    [parameter(Mandatory = $True)]
    [String]$Message,
    [String]$Context = "",
    [Int]$Thread = $PID
  )
  Write-Verbose -Message "Enter Function Write-MyLogFile"
  Try
  {
    $TempDate = [DateTime]::Now
    $TempStack = @(Get-PSCallStack)
    Switch ($Severity)
    {
      "Info" { $TempSeverity = 1; Break }
      "Warning" { $TempSeverity = 2; Break }
      "Error" { $TempSeverity = 3; Break }
    }
    Add-Content -Path $LogFile -Value ("<![LOG[{0}]LOG]!><time=`"{1}`" date=`"{2}`" component=`"{3}`" context=`"{4}`" type=`"{5}`" thread=`"{6}`" file=`"{7}`">" -f $Message, $($TempDate.ToString("HH:mm:ss.fff+000")), $($TempDate.ToString("MM-dd-yyyy")), $TempStack[1].Command, $Context, $TempSeverity, $Thread, "$([System.IO.Path]::GetFileName($TempStack[1].ScriptName)):$($TempStack[1].ScriptLineNumber)-$($TempStack.Count - 3)") -Encoding "Ascii"

    $TempDate = $Null
    $TempStack = $Null
    $TempSeverity = $Null

    [System.GC]::Collect()
    [System.GC]::WaitForPendingFinalizers()
  }
  Catch
  {
    Write-Debug -Message "ErrMsg: $($Error[0].Exception.Message)"
    Write-Debug -Message "Line: $($Error[0].InvocationInfo.ScriptLineNumber)"
    Write-Debug -Message "Code: $(($Error[0].InvocationInfo.Line).Trim())"
  }
  Write-Verbose -Message "Exit Function Write-MyLogFile"
}
#endregion function Write-MyLogFile

#region function Scale-MyForm
function Scale-MyForm()
{
  <#
    .SYNOPSIS
      Scale Form
    .DESCRIPTION
      Scale Form
    .PARAMETER Control
    .PARAMETER Scale
    .EXAMPLE
      Scale-MyForm -Control $Control -$Scale
    .NOTES
      Original Function By Ken Sweet
    .LINK
  #>
  [CmdletBinding()]
  param (
    [Object]$Control,
    [Single]$Scale
  )
  Write-Verbose -Message "Enter Function Scale-MyForm"
  Try
  {
    if ($Control -is [System.Windows.Forms.Form])
    {
      $Control.Scale($Scale)
    }
    $Control.Font = New-Object -TypeName System.Drawing.Font($Control.Font.FontFamily, ($Control.Font.Size * $Scale), $Control.Font.Style, $Control.Font.Unit)
    if ([String]::IsNullOrEmpty($Control.PSObject.Properties.Match("Items")))
    {
      if ($Control.Controls.Count)
      {
        ForEach ($ChildControl in $Control.Controls)
        {
          Scale-MyForm -Control $ChildControl -Scale $Scale
        }
      }
    }
    else
    {
      ForEach ($Item in $Control.Items)
      {
        Scale-MyForm -Control $Item -Scale $Scale
      }
    }
  }
  Catch
  {
    Write-Debug -Message "ErrMsg: $($Error[0].Exception.Message)"
    Write-Debug -Message "Line: $($Error[0].InvocationInfo.ScriptLineNumber)"
    Write-Debug -Message "Code: $(($Error[0].InvocationInfo.Line).Trim())"
  }
  Write-Verbose -Message "Exit Function Scale-MyForm"
}
#endregion

#region function Get-MyFontData
function Get-MyFontData()
{
  <#
    .SYNOPSIS
      Get New Font Size Based on Current Dpi
    .DESCRIPTION
      Get New Font Size Based on Current Dpi
    .PARAMETER FontFamily
    .PARAMETER FontSize
    .PARAMETER TextString
    .EXAMPLE
      $FontData = Get-MyFontData
    .EXAMPLE
      $FontData = Get-MyFontData -FontFamily "Verdana" -FontSize 10
    .EXAMPLE
      $FontData = Get-MyFontData -FontFamily "Verdana" -FontSize 10 -TextString "Sample Text"
    .NOTES
      Original Function By Ken Sweet
    .LINK
  #>
  [CmdletBinding(DefaultParameterSetName = "Default")]
  param (
    [System.Drawing.FontFamily]$FontFamily = $MyDMConfig.FontFamily,
    [Single]$FontSize = $MyDMConfig.FontSize,
    [String]$TextString = "The quick brown fox jumped over the lazy dogs back",
    [Parameter(Mandatory = $True, ParameterSetName = "Down")]
    [Switch]$Down,
    [Parameter(Mandatory = $True, ParameterSetName = "Up")]
    [Switch]$Up
  )
  Write-Verbose -Message "Enter Function Get-MyFontData"
  Try
  {
    $Graphics = [System.Drawing.Graphics]::FromHwnd([System.IntPtr]::Zero)
    Switch ($PSCmdlet.ParameterSetName)
    {
      "Up"
      {
        $Ratio = $Graphics.DpiX / 96
        Break
      }
      "Down"
      {
        $Ratio = 96 / $Graphics.DpiX
        Break
      }
      Default
      {
        $Ratio = 1
        Break
      }
    }
    $BoldFont = New-Object -TypeName System.Drawing.Font($FontFamily, $FontSize, [System.Drawing.FontStyle]::Bold, [System.Drawing.GraphicsUnit]::Point)
    $MeasureString = $Graphics.MeasureString($TextString, $BoldFont)
    [PSCustomObject]@{
      "Ratio" = $Ratio;
      "Width" = [Math]::Floor($MeasureString.Width / $TextString.Length);
      "Height" = [Math]::Ceiling($MeasureString.Height);
      "DpiX" = $Graphics.DpiX;
      "DpiY" = $Graphics.DpiY;
      "Bold" = $BoldFont
      "Regular" = New-Object -TypeName System.Drawing.Font($FontFamily, $FontSize, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Point)
    }
    $BoldFont = $Null
    $MeasureString = $Null
    $Graphics.Dispose()
    $Graphics = $Null
    $Ratio = $Null

    [System.GC]::Collect()
    [System.GC]::WaitForPendingFinalizers()
  }
  Catch
  {
    Write-Debug -Message "ErrMsg: $($Error[0].Exception.Message)"
    Write-Debug -Message "Line: $($Error[0].InvocationInfo.ScriptLineNumber)"
    Write-Debug -Message "Code: $(($Error[0].InvocationInfo.Line).Trim())"
  }
  Write-Verbose -Message "Exit Function Get-MyFontData"
}
#endregion function Get-MyFontData

# MyDM Script Default Font Settings
$MyDMConfig.FontData = Get-MyFontData -Up

#endregion ******** My Custom Functions ********

#region ******** MyDM Custom Code ********

#region ******** $MyDMFormICO ********
# Icons for Forms are 16x16
$MyDMFormICO = @"
AAABAAEAEBAAAAEAIABoBAAAFgAAACgAAAAQAAAAIAAAAAEAIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAn4KCr5+Cgv+fgoL/n4KC/5+Cgu+fgoK/n4KCv5+Cgr+fgoKvn4KCgJ+C
goCfgoJgn4KCIAAAAAAAAAAAAAAAAJ+Cgu/r3t7/9uzr//bs7P/37e3/4dPT/+LU1P/i1NT/3c7O/8y6uv/Mu7r/wa2t/5+Cgu8AAAAAAAAAAAAAAACfgoL/+fHw//Oda//4j03/+JFR//iXXP/8nWP//p5i//ml
df/6sYb/+eHW//z4+P+fgoL/AAAAAAAAAACfgoJAq5GR//rz8///mz3//6ZT//+4dv//uHX//7t6//+5df//tm///5pK//nSvP/+/f3/n4KC/wAAAAAAAAAAn4KCQLagoP/67uj/3bV0/4XV1v//rmH//7x7//+t
Xf//pE3//6VO//+mWv/618H/5+Dg/5+Cgv8AAAAAAAAAAJ+CgoDDsLD//ubQ/8zNnP957fT//7Nn//+3b///qlX//6pW//+rV///nUj/+9rE/+fg4P+fgoK/AAAAAAAAAACfgoKAz8HB//3hxv+/jIH/v5iU//+3
bf//tmv//7Be//+wX///sWD//6NR//3hy//n4OD/n4KCvwAAAAAAAAAAn4KCv+HY2P//16//QGHM/0Bw2///t2v//8OB//+1Z///tmj//7dp//+qWf//59L/5+Dg/5+Cgr8AAAAAAAAAAJ+Cgs/n4OD//dy4/7+k
kP/Pqoj//7tx//+7b///u3D//7xx//+9c///sGL//+jT/+fg4P+fgoK/AAAAAAAAAACfgoL/+ff3///+/v/+/Pv//vDh//7lyP/+2a///s2W///Cev//w3z//7Zp///q1f/n4OD/n4KCvwAAAAAAAAAAn4KCv5+C
gv+xmZn/w7Gx/8/Bwf/n4OD/+ff3///////+/v3//vPm//7hw//++fP/29DQ/5+Cgr8AAAAAAAAAAAAAAAAAAAAAn4KCQJ+CgmCfgoKPn4KCv5+Cgv+lior/t6Gh/8/Bwf/h2Nj/8+/v/8/Bwf+fgoKPAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAn4KCIJ+CglCfgoKAn4KCv5+Cgt+fgoL/n4KCUAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAA//+sQf//rEHAAaxBwAGsQcABrEGAAaxBgAGsQYABrEGAAaxBgAGsQYABrEGAAaxBgAGsQeABrEH/AaxB//+sQQ==
"@
#endregion ******** $MyDMFormICO ********

#region ******** $Userico ********
$Userico = @"
AAABAAEAEBAAAAEAIABoBAAAFgAAACgAAAAQAAAAIAAAAAEAIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAVE9KAjw4M2s8NTDLNC8p7zcwKPkxKiT0KiQe4zs1MOY5NDCsT0tHDwAA
AAAAAAAAAAAAAAAAAAAAAAAAS0dEKS4mHvk3LiT/QTct/01COP9HPTP/OjAn/zctI/9TST7/TEI3/zgzLNkAAAAIAAAAAAAAAAAAAAAAUkxHcS0mHvo6MSb/QDIq/0g+Nf9OQzr/T0Q6/z0zKf8+NCv/UUY8/zwz
Kf9HQTrNAAAAAAAAAAAAAAAAAAAAAFJLRL8zKR//OTEo/0cuHf9YQTT/Mysj/zUsI/9EOjD/ST81/05DOf8nHxb/g397pgAAAAAAAAAAAAAAAAAAAABWUEqiOC8l/y4nIv98XjD/qYBJ/2ReWP83Lyf/PzYv/1dO
RP9WTEH/JR0V/5WUkWQAAAAAAAAAAAAAAAAAAAAAdG9pg2heVP42Lyn/j4Jl/72KRf/a2tn/gnlw/5+Xjv95b2b/Vk1D/zIrJfuHhIEUAAAAAAAAAAAAAAAAAAAAAHdzbk2SioH4cmhd/7y3s//KuKT//////9TR
zv+RiH7/XVRL/1NJPv9HPzrbAAAAAAAAAAAAAAAAAAAAAAAAAAB9eXQCfXdxtGJYTv+XjYP/yNLd/8LM1P/n6On/jYiC/zYuJv9PSEK+XVhTDgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABiYF0hb3d+8l92
jf9MXnj/uMXQ/4iFgPpIRD9FAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAlJ2lH6O2yP6ltsf/aoKZ/3eOpP+MkJRiAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAJeh
qoi3x9T/usnV/5aqvP9gcYH/V1NSlAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAC0vcXI3+ju/9Xg6f+aqrj/YWdv/zw2NO4AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAo6qy5Kawu/95hZH/dH6J/2pgVf9HPjX9XVhTCgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAR0JBCFFJRfwqIyH/FxEP/zkwLP+1sKr/Ukg//mhjXhQAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAACBenSS087L/4uCfP9aUUr/e3Jq/3NsZeoAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAGxmYmKwrKfst7Kt+3dxauhoY10oAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAA8AOsQeABrEHAA6xBwAOsQcADrEHAA6xBwAesQcAHrEHwH6xB8D+sQfA/rEHwP6xB8B+sQeAfrEHwP6xB+D+sQQ==
"@
#endregion

#region ******** $Systemico ********
$Systemico = @"
AAABAAEAEBAAAAEAIABoBAAAFgAAACgAAAAQAAAAIAAAAAEAIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADo6OjRKSkpZXV1dV0pKSjAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADw8PLFRUVH/Z2dn/3l5ef9aWlr/Ly8vrQ4ODhIAAAAHAAAAAAAAAAAAAAAAFRUVSA4ODjZDQ0MxR0dHXRgYGD46OjrnZmZm/3h5ef9UVlb/KjAw/xUd
HfsAAgJ0AAAANQAAAAoAAAAAAAAAABUVFe0mJib/Li4u/zo7O/8ZHx/4DRkZ0ik4ON0pNjb/ExMT/ygTE/87GRn/DAwM9wAAAFAAAAAvAAAABAAAAAAjIyPoPDw8/zExMf8nJSX/OSUl/1QhIf9tFhb+ig0N/7Ah
IP/ZUE//wz48/yUfH/8FDw9iAAAAPQAAACkAAAACKioq7FJSUv9DTk//YSws/8cICP/KAgD/ywAA/8gAAP/TOTj/1UFA/8g3Nv9HNTX/GSkpYwAAABgAAAAiAAAACS41NOtsbGz/Y21t/2hBQf/CAAD/wwYE/8QL
Cf/NLCr/11JQ/9hJR//dUVD/a1BP/zhKSmcAAAAAAAAAAQAAAAFYWE7zg4OD/3+EhP9zZWX/yTMx/9pAPv/bT03/421s/+Vzcf/ndHL/83x7/5Bubv9OXV2GAAAAAAAAAAAAAAAAXFpcmIODg9qDhIT7gH9//9Nv
bv/wfHr/74eG//OUk//3mpj//KCe//+sq/+5lJP/ZG5urQAAAAAAAAAAAAAAAAAAAACqqqoDioqKI3N8fHnfnp3//7a0//+2tf/+uLf/97i3/+y1tP/fsbD/tJ2d/3V5ebAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AABic3Mfn46O7rKbm9ylk5PEnJCQqpGMjI6Hh4dxe4SEVY6Xlzupm5sSAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA/6qqA2uhoRMAf38EAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAA//+sQf//rEH8P6xB+AesQQADrEEAAaxBAACsQQAArEEABKxBAAesQQAHrEGAB6xB4AesQeP/rEH//6xB//+sQQ==
"@
#endregion

#region ******** $Noneico ********
$Noneico = @"
AAABAAEAEBAAAAEAIABoBAAAFgAAACgAAAAQAAAAIAAAAAEAIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAwAAAAkAAAAPAAAAFgAAABgAAAAYAAAAGAAAABgAAAAYAAAAGAAAABgAAAAYAAAAFgAA
ABAAAAALAAAAAAAAAAQAAAANAAAARAAAAE4AAABRAAAAUQAAAFEAAABRAAAAUQAAAFEAAABRAAAAUQAAAE4AAABIAAAAEAAAAAAAAAAF8alk//GrZ//xrGn/8q5s//KubP/yrm3/8q5t//Kubf/yrmz/8axp//Gr
Z//xqWT/AAAATgAAABYAAAAAAAAABvGoYf/s7Oz/7Ozs/+zs7P/s7Oz/7Ozs/+zs7P/s7Oz/7Ozs/+zs7P/s7Oz/8ahh/wAAAFEAAAAYAAAAAAAAAAbwpl7/7e3t/+3t7f/t7e3/7e3t/+3t7f/t7e3/7e3t/+3t
7f/t7e3/7e3t//CmXv8AAABRAAAAGAAAAAAAAAAG8KNZ/+vr6//r6+v/6+vr/+vr6//r6+v/6+vr/+vr6//r6+v/6+vr/+vr6//wo1n/AAAAUQAAABgAAAAAAAAABvChVP/r6+v/6+vr/+vr6//r6+v/6+vr/+vr
6//r6+v/6+vr/+vr6//q6ur/8KFU/wAAAFEAAAAYAAAAAAAAAAbwoVT/6+vr/+vr6//r6+v/6+vr/+vr6//r6+v/6+vr/+vr6//r6+v/6urq//ChVP8AAABRAAAAGAAAAAAAAAAG8KNZ/+7u7v/u7u7/7u7u/+7u
7v/u7u7/7u7u/+7u7v/u7u7/7u7u/+zs7P/wo1n/AAAAUQAAABgAAAAAAAAABvCnYP/w8PD/8PDw//Dw8P/w8PD/8PDw//Dw8P/w8PD/8PDw//Dw8P/t7e3/8Kdg/wAAAFEAAAAYAAAAAAAAAAbwp2D/8PDw//Dw
8P/w8PD/8PDw//Dw8P/w8PD/8PDw//Dw8P/w8PD/7e3t//CnYP8AAABQAAAAFwAAAAAAAAAG8Kto//Hx8f/x8fH/8fHx//Hx8f/x8fH/8fHx//Hx8f/x8fH/8fHx//Dw8P/wq2j/AAAASgAAABEAAAAAAAAABvGx
cv/z8/P/9PT0//T09P/09PT/9PT0//T09P/09PT/8bFy//Gxcv/xsXL/8bFy/wAAABQAAAALAAAAAAAAAAXyt33/9vb2//b29v/29vb/9vb2//b29v/29vb/9vb2//O3fv/34M7/8rd9/wAAABQAAAALAAAABQAA
AAAAAAAE9L2J//n5+f/6+vr/+vr6//r6+v/6+vr/+vr6//r6+v/0von/9L6J/wAAABQAAAALAAAABAAAAAEAAAAAAAAAA/XFlv/1xZb/9cWW//XFlv/1xZb/9cWW//XFlv/1xZb/9cWW/wAAABEAAAALAAAABQAA
AAEAAAAAgACsQYAArEGAAKxBgACsQYAArEGAAKxBgACsQYAArEGAAKxBgACsQYAArEGAAKxBgACsQYAArEGAAKxBgAGsQQ==
"@
#endregion

#region ******** $Newico ********
$Newico = @"
AAABAAEAEBAAAAEAIABoBAAAFgAAACgAAAAQAAAAIAAAAAEAIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAMJjLr/EZS//x2cw/8pqMP/NbDH/0G4yvwAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADBYy7/9L2G/+6cT//ulkH/8ZxH/9BuMv8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAwWIu//S9h//ok0//6Y9B//KeSf/PbjL/AAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAMBiLv/0vYf/5o9O/+iLQf/ynkj/zm0x/wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADAYS3/9LyG/+aOTf/niT//8ZxG/81s
Mf8AAAAAAAAAAAAAAAAAAAAAAAAAALBWKb+zWCr/tlor/7lcK/+8Xiz/vmAt//O8hv/ki0v/5YY9/++YQ//LajD/zWwx/85tMf/PbjL/0G4y/9BuMt+vVSn/8LmK/+aTU//jh0D/44I2/+OCMv/pk0n/4H46/+OB
Of/tlD//75lD//GcRv/ynkj/8p5J//GdR//NbDH/rlQo//C5iv/dg0z/2HM5/9p2Ov/beDr/3Hc2/9t0M//eeDX/44E5/+WGPf/niUD/6IxB/+qPQv/ulkH/ymow/61TKP/wuYv/34xa/9p+S//cgUz/3oRO/+CH
T//dfUL/3n5A/+KGRP/mkVT/55JU/+iUVf/qmFb/76FX/8dnMP+sUij/77mL//C5i//xuor/8buL//G8i//yvYv/4IdQ/95+P//rnVf/9MCN//XBjf/1wY3/9cGN//XBjf/EZS//qlEnv61SKP+vVCj/sVYp/7NY
Kv+2Wir/8byL/96ETv/cej3/5o5E/75gLf/AYS3/wGIu/8FiLv/BYy7/wmMupgAAAAAAAAAAAAAAAAAAAAAAAAAAs1gq//G7i//cgU3/2nY7/+WLQv+8Xiz/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAALFWKf/xuov/239L/9hzOv/jiUL/uVwr/wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACvVCj/8LqL/9+MW//dg03/5pRT/7ZaK/8AAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAArVIo//C6i//wuov/8LqL//C6i/+zWCr/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAKpRJ7+sUij/rVMo/65UKP+vVSn/sFYpvwAAAAAAAAAAAAAAAAAA
AAAAAAAA+B+sQfgfrEH4H6xB+B+sQfgfrEEAAKxBAACsQQAArEEAAKxBAACsQQAArEH4H6xB+B+sQfgfrEH4H6xB+B+sQQ==
"@
#endregion

#region ******** $Commandico ********
$Commandico = @"
AAABAAEAEBAAAAEAIABoBAAAFgAAACgAAAAQAAAAIAAAAAEAIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgHx4gJWQit+MhX3vfndtIH1zZDCfl4rvk4Zw331uVYAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAKKfnP/29PD/5uDY/4iBds+RiX3f7+ng/+reyf+Zi3L/AAAAAAAAAAAAAAAAAAAAAAAAAACShoYgj4aFIAAAAACkoZ//+/n3//Tu5//m3tT/5dzP//Lo1//w5NH/nI53/wAA
AACAb1NAf21PIAAAAAAAAAAAo5iZz8fBwf+hnZzv0c7L//z49P/k39j/xr+2/8W9sf/h18n/9erY/8m8p/+kln7/t6eN/45+Yd8AAAAAloSGYNfR0v///Pv//fj3//Xy8P+1sa3/wsC9/+Df3f/g3tv/ycW//6+l
l//v5NH/8+fS/+/iyv/DtJv/fm9VYJeEhlC9s7P///////r29f/AvLr/5+Ti///////S0M7/0s/M///////o5uP/r6aX//br2f/z59X/qp+M/35wWUAAAAAAloWGcNDKyv/p4+P/vLe1//z59/+in5zviYR+YIeB
eWCemZLv/////8G8tf/q4NH/wrin/390YnAAAAAAnIOGUKWRk9/azM3/1svL/8/Ix//V0dD/i4iFcAAAAAAAAAAAh4F5YNLQzP/g3tv/1c3B/9nQw/+elIXvfnRlgMOytP/47u//6tjZ/9HDxP/Gu7v/0MrJ/4uH
hXAAAAAAAAAAAImEfmDS0M7/4N/d/9fQx//38OX/8end/66lmf+4oqX//vz8//Xu7//l3Nz/raCg/+HY1/+gmpnvi4eFYIuIhWCin5zv/////8PAvf/v6uP/+/fy//z69/+kn5f/rJCUj7mkp++0oqT/+ff4/7uv
r/+9sLH/4djX/8nDwv/Oysn//Pn3/+fk4f+0sKz/9/Pv/6qmov+hnZi/f3pzgAAAAAAAAAAAnYOGj+rk5P/UwcP/r5+g/62goP/FvLv/z8jH/8G9u/+xrqv/8e7r/+/r6f+Ggn6fAAAAAAAAAAAAAAAAAAAAAK6U
mN/28vL/0ru+/+PV1//r5ub/xry8/8G2tf/c1dT/+ff3//z6+f/9+vn/rquo7wAAAAAAAAAAAAAAAAAAAACwk5fv+ff4//bz8/+7qqz/08nK//fx8v/o2dr/0sbG/7Wtre/q6Oj/+Pf3/6Oene+IhIIgAAAAAAAA
AAAAAAAApIKHEKqLkM+pjZG/noOGIKuWmc//////9ezt/7Chou+ShYYQkoaGn5qPj8+PhoUgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACfg4eAybm7/87Bw/+ahIafAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAA8A+sQfAPrEGQCaxBgAGsQQAArEEAAKxBgAGsQQGArEEBgKxBAACsQQAArEHAA6xBwAOsQcABrEHAA6xB/D+sQQ==
"@
#endregion

#region ******** $Deleteico ********
$Deleteico = @"
AAABAAEAEBAAAAEAIABoBAAAFgAAACgAAAAQAAAAIAAAAAEAIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA8Ps48SErOvGhqtEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAB4eqRAqKsmvLy/TjwAA
AAAAAAAAAAAAAA0Nsp8GBrf/CQm6/xQUtM8bG60QAAAAAAAAAAAAAAAAAAAAAB0dqhAnJ8bPODju/0BA9/81NdqfAAAAADc3v48HB7X/Bga3/wkJuv8MDL3/FRW1zxsbrBAAAAAAAAAAAB0dqhAjI8LPLy/k/zY2
7P87O/L/PT30/y4u0I9ERMSvVFTO/wkJt/8ICLn/Cwu8/w4OwP8WFrfPHBysEBwcqxAfH77PJiba/yws4P8xMeb/NTXr/zY27P8pKcevGRmvEEVFxM9VVc//Cwu5/woKu/8NDb//ERHD/xgYuM8bG7vPHh7R/yMj
1v8nJ9v/Kyvg/y4u4/8mJsXPHh6pEAAAAAAZGa8QRUXEz1VV0P8MDLv/DAy+/w8Pwf8TE8X/FxfJ/xsbzv8fH9L/IiLW/yUl2f8iIsHPHR2qEAAAAAAAAAAAAAAAABkZrhBGRsTPVlbQ/w4OvP8ODr//ERHD/xQU
xv8XF8r/GhrN/x4e0f8eHr7PHR2qEAAAAAAAAAAAAAAAAAAAAAAAAAAAGhquEEZGxc9NTc//DAy9/w4OwP8REcP/FBTG/xYWyf8bG7rPHByrEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABkZrhAlJbjPLi7E/x0d
wf8ODr7/Dg7A/xAQwv8TE8X/GBi4zxwcrBAAAAAAAAAAAAAAAAAAAAAAAAAAABkZrxAmJrnPNDTE/zIyxf8wMMX/Ly/G/ygoxf8gIMT/Hx/F/x8fxv8jI7rPGxusEAAAAAAAAAAAAAAAABgYsBAoKLnPOTnE/zY2
xP80NMT/MjLF/zAwxf9oaNf/MTHH/y4ux/8uLsj/LS3J/yMjuc8bG60QAAAAABcXsRArK7rPPj7F/zs7xf85OcT/NjbE/zQ0xP8lJbjPT0/Hz3Bw2f8yMsb/Ly/G/y4uxv8uLsf/JCS5zxoarRBTU8qvVFTM/0FB
xv8+PsX/OzvF/zk5xP8mJrnPGRmuEBoarhBQUMfPcXHY/zMzxf8wMMX/MDDF/zAwxf8kJLivY2PQj5iY5v9TU8z/QUHG/z4+xf8oKLnPGRmvEAAAAAAAAAAAGhquEFBQx89yctj/NTXF/zIyxP8yMsT/Jye6jwAA
AABpadOfmJjm/1RUzP8rK7rPGBiwEAAAAAAAAAAAAAAAAAAAAAAZGa8QUFDIz3R02P84OMT/KSm7nwAAAAAAAAAAAAAAAGNj0I9TU8qvFxewEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABkZrxBQUMivSkrFjwAA
AAAAAAAAx+OsQYPBrEEBgKxBAACsQQAArEGAAaxBwAOsQeAHrEHgB6xBwAOsQYABrEEAAKxBAACsQQGArEGDwaxBx+OsQQ==
"@
#endregion

#region ******** $Editico ********
$Editico = @"
AAABAAEAEBAAAAEAIABoBAAAFgAAACgAAAAQAAAAIAAAAAEAIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAlJSavK0tcQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAe6/AUHG10/83c5OfK1lxEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAB/z+mvZrS4/zOHR+8fiB9gAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAZL7aIH/Po+9gwmD/MZIx/x+IH2AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABsx2xgg9GD/2DCYP8xkjH/H4gfYAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAGzHbGCD0YP/YMJg/zGSMf8fiB9gAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAbMdsYIPRg/9gwmD/MZIx/x+I
H2AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABsx2xgg9GD/2DCYP8xkjH/H4gfYAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAGzH
bGCD0YP/YMJg/zGSMf8fiB9gAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAbMdsYIPRg/9gwmD/MZIx/x+IH2AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAABsx2xgg9GD/2DCYP8xkjH/H4gfYAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAGzHbGCD0YP/YMJg/zeSN/99j4BgAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAbMdsYInSif+1y7f/fn5//5OUl2AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACvvq9g1tbW/8zNz/9+f3//ZGi3YAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAALy8vGDY2Nj/jZLQ/0FGvu8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAqK7fYIKJ
4u9SWMefP/+sQQ//rEGH/6xBg/+sQcH/rEHg/6xB8H+sQfg/rEH8H6xB/g+sQf8HrEH/g6xB/8GsQf/grEH/8KxB//isQQ==
"@
#endregion

#region ******** $Exportico ********
$Exportico = @"
AAABAAEAEBAAAAEAIABoBAAAFgAAACgAAAAQAAAAIAAAAAEAIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAC/TRswAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAC9SRhAv0sajwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAC5RRYQvEcX775KGSAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAu0YYgLxHGM8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAtT8TEMJNHu+8RxiPAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAALpMImDJWCr/uEMVcAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAC/Vi2v0Gg8/7ZCE0AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAw101v9Z2S/++VSpQAAAAAAAAAAAAAAAAAAAAAAAAAADRYCn/0WAp/9FgKf/RYCn/0WAp/9FgKf/RYCn/0WAp/8NbMt/ehFr/vFMogAAAAAAAAAAAAAAAAAAA
AAAAAAAAxlUfEMtZJM/gcTj/43k7/+F7Of/ifTv/5H4+/9FgKf/BXje/4Yti/8BZMM8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADGVB8QyVgj3+ByOf/ddTT/3XY0/+B4OP/RYCn/vFYwr+CNZf/PcEn/uUwiUAAA
AAAAAAAAAAAAAAAAAAAAAAAAwVIfMM9eK//gdj3/3Xo9/+F/RP/ig0j/0WAp/7dMJWDWgV3/4Yxj/8ReNu+4Sh9AAAAAAAAAAAAAAAAAvUsbcMtZJ//dcDn/2nU6/+F6Qv/ieUT/5INN/9FgKf+2TCQQwF04796K
Yv/dhVv/zm5F/8FYL8/AVCm/wlQn39FjM//cbjf/1200/950Pf/WaTf/yV8v7+B4Rf/RYCn/AAAAALRHIFDKcEz/3ode/9l4Sf/ce0z/3XlJ/9tzQf/WajT/12w1/91wO//OYDD/w1cpj8RcLRDIYDHP0WAp/wAA
AAAAAAAAtkskUMJhPO/Wf1n/239U/9l2Rv/adkX/23dI/9NsPv/FWCvfvlElUAAAAAAAAAAAwlstENFgKf8AAAAAAAAAAAAAAAC2SyMQtUoicLxWL7+/WDK/wFcwv71RKa+5TCJgAAAAAAAAAAAAAAAAAAAAAAAA
AADAVywQ7/+sQc//rEGP/6xBn/+sQR//rEEf/6xBH/+sQR8ArEEfAKxBH4CsQQ+ArEEHAKxBAACsQYAArEHADKxB4D6sQQ==
"@
#endregion

#region ******** $Openico ********
$Openico = @"
AAABAAEAEBAAAAEAIABoBAAAFgAAACgAAAAQAAAAIAAAAAEAIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAFyqyVBcqsnvXKrJ/0J6kC0AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAXKrJEFyqya9hsM7/ccHb/2Gvzf81YnRvAAAAIgAAAAAAAAAABnAMEARqCa8DYwafAAAAAAAAAAAAAAAAAAAAAFyqye9rvdf/eMzj/3fK4v9cqsn/SYeg/0N8k/9Oj6r/UZyx/xiCM/8YpzD/CXoS/1af
vDAAAAAAAAAAAAAAAABcqsn/etLn/3nQ5v94zuT/XKrJ/1eWsP9WkKj/W6Cy/x+QPf8erzv/HLU5/wp+FP89j4X/AAAAAAAAAAAAAAAAXKrJ/3zW6v971Oj/etLn/1yqyf9am7b/TJiX/x+WPf8jtkf/I7tG/xy1
Of8Upyn/C4oW/wRrCN8CYwUwAAAAAFyqyf992ez/fdfr/3zW6v9cqsn/XKnI/y+rRP9HyGj/KcFT/yO7Rv8ctTn/Fq8t/xCpIf8KnxT/BHAH7wJiBDBcqsn/f93u/37b7f9+2u3/ftns/3fQ5f8wsUj/u/bA/0jM
av8ju0b/HLU5/xavLf8QqSH/CqMV/wWXCv8DZQe/XKrJ/4Hh8f+A4PD/gN7v/3/e7/9/3e7/T6qr/z23U/+69b//Tcxo/xy1Of8QkyD/DZUb/wqjFf8Fngn/BHUH/1yqyf+C5PP/guPz/4Lj8v+B4vL/geLx/1yq
yf9Zub//PbZU/6rtr/9e0G//EJUh/wyEF58KjxT/BZ4J/wV6Cv9cqsn/hOj2/4Pn9f+D5vX/g+b0/4Pm9P9cqsn/bMTq/17Cy/8lqz//qe2u/z+uSv8AAAAAC4YXvwWeCf8Gfwz/XKrJ/4Xr+P+F6vf/her3/4Xp
9/+F6fb/XKrJ/2/J8P9wzfX/Y8zX/yutTP8rpE3/AAAAAAyRGK8Fngn/CIAR71yqyf+H7vr/hu75/4bt+f+G7fn/hu35/1yqyf9wzPX/cs/4/3XV//911f//Xq7O/xGYIkAMmhj/CZUS/wyEF4Bcqsn/iPH8/4jx
/P+I8Pv/h/D7/4fw+/9cqsn/ctD5/3TT/f911f//ddX//1GtsP8SoCT/Dp4b/w+QHr8AAAAAXKrJ/4n0/f+J8/3/ifP9/4bu+f941+n/XKrJ/4vf//+L4P//i+D//6vv//9SsLL/FKUp/xKdJY8AAAAAAAAAAFyq
yf+K9f//eNnq/2rB2v9cqsn/f8Xa/6nk7v/M////zP///8z///+48ff/YbPT7wAAAAAAAAAAAAAAAAAAAABcqsnPXKrJ/16tzf9gsdH/YbTV/2K11v9itdb/YrXW/2K11v9jt9j/Y7fY72K01WAAAAAAAAAAAAAA
AAAAAAAAw/+sQQGPrEEAB6xBAAesQQABrEEAAKxBAACsQQAArEEAAKxBAAisQQAIrEEAAKxBAAGsQQADrEEAD6xBAA+sQQ==
"@
#endregion

#region ******** $Upico ********
$Upico = @"
AAABAAEAEBAAAAEAIABoBAAAFgAAACgAAAAQAAAAIAAAAAEAIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAH8A/wB7AP8AdwD/AHIA/wBuAP8AagD/AGYA/wBjAP8AAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAACDAP+Y05P/csVr/3fKcv99z3r/hNSC/4raiv8AZgD/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAhwD/mNOS/zOrKP87sjL/Q7g9/0y/SP+I2If/AGoA/wAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAIsA/5fSkf8wqSX/OK8v/0C2Of9IvEP/hdWD/wBuAP8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACPAP+W0Y//Laci/zSsKv88sjP/Q7g9/4HS
fv8AcgD/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAkwD/ldCN/yqkHf8wqSX/N68t/z60Nv98znj/AHcA/wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAJcA/5PPi/8moRj/LKUg/zKq
J/84ry//eMtz/wB7AP8AAAAAAAAAAAAAAAAAAAAAAJkA/wCZAP8AmQD/AJkA/wCZAP+RzYn/Ip4T/yeiGv8tpiH/Mqon/3PHbf8AfwD/AHsA/wB3AP8AcgD/AG4A/wCZAO9ywW//rden/43KhP93wGz/hcd8/x6a
Dv8jnhT/J6Ia/yymIP9vw2f/csVr/3THbv92yXD/Ybtd/wByAO8AmQAwAJkA73HBbf+b0JP/XLNP/1SwRv9JrTz/Pqkx/zenKv83qCr/M6gn/zerK/9mv17/Ybpc/wiAB+8AdwAwAAAAAACZADAAmQDvb8Fs/5nP
kv9as03/U7BF/0+vQv9Or0D/TbBB/0+yQ/9zwmr/ab1j/weHB+8AfwAwAAAAAAAAAAAAAAAAAJkAMACZAO9vwWv/mc+R/1qzTf9UsEf/UrBF/1KxRf9zwWr/aLxh/weOBu8AhwAwAAAAAAAAAAAAAAAAAAAAAAAA
AAAAmQAwAJkA72/Ba/+az5L/XLNQ/1iyS/93wGz/aLxg/waVBu8AjwAwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACZADAAmQDvcMBs/5zPlP9+w3T/cMBo/wabBe8AlwAwAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAJkAMACZAO9xwG3/jMqH/wqcCe8AmQAwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAmQAwAJkA7wCZAO8AmQAwAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAA8A+sQfAPrEHwD6xB8A+sQfAPrEHwD6xB8A+sQQAArEEAAKxBAACsQYABrEHAA6xB4AesQfAPrEH4H6xB/D+sQQ==
"@
#endregion

#region ******** $Downico ********
$Downico = @"
AAABAAEAEBAAAAEAIABoBAAAFgAAACgAAAAQAAAAIAAAAAEAIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAcHKwwHByr7xwcq+8dHaswAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAbG6wwICCu71RUwP9HR7v/HR2r7x0dqjAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAbG60wICCu71RUwP9UVMD/VFS//0hIu/8dHarvHR2qMAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAaGq0wICCv71NTwf9TU8D/ICCu/yAgrf9UVL//SEi7/x0dqu8dHaowAAAAAAAAAAAAAAAAAAAAAAAAAAAaGq4wHx+v71NTwf9TU8H/Hx+u/xwcrP8cHKz/ICCt/1RU
v/9ISLr/HR2q7x0dqjAAAAAAAAAAAAAAAAAaGq4wHx+w71JSwf9SUsH/Hx+v/xsbrP8bG6z/HBys/xwcq/8gIK3/VFS//0hIu/8dHarvHR2qMAAAAAAZGa8wHh6w71xY0P9lYdP/OjbD/zYywv8bG63/Gxus/xsb
rP8cHKz/NzPA/zs3wv9mYtH/UU3J/yQjse8dHaswGRmv72th5f+IeP//iHj//4h4//+IeP//Gxut/xsbrf8bG6z/Gxus/3lv6f+IeP//iHj//4h4//90Z+//HByr7xkZr/8ZGa//GRmu/xoarv8aGq7/iHj//xoa
rf8bG63/Gxut/xsbrP9gYMX/HBys/xwcrP8cHKz/HBys/xwcq/8AAAAAAAAAAAAAAAAAAAAAGhqu/4h4//8eHq//Ghqt/xsbrf8bG63/YGDF/xsbrP8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABkZ
rv+IeP//VFTD/z8/u/8zM7b/KSmy/2lpyf8bG63/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAZGa//iHj//1xcxf9YWMT/VVXD/1NTwv+GhtT/Gxut/wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAGRmv/4h4//9eXsb/XFzG/1paxf9XV8T/iYnV/xoarf8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABkZr/+IeP//a2fW/2ll1f9oZNT/Z2PU/4yL2f8aGq7/AAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAYGK//iHj//4h4//+IeP//iHj//4h4//+KgPD/Ghqu/wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAGBiw/yoqtv8qKrX/Kiq1/yoqtf8qKrX/Kiq1/xkZr/8AAAAAAAAAAAAA
AAAAAAAA/D+sQfgfrEHwD6xB4AesQcADrEGAAaxBAACsQQAArEEAAKxB8A+sQfAPrEHwD6xB8A+sQfAPrEHwD6xB8A+sQQ==
"@
#endregion

#region ******** $Helpico ********
$Helpico = @"
AAABAAEAEBAAAAEAIABoBAAAFgAAACgAAAAQAAAAIAAAAAEAIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAC6XSwQvF8sgMFiLd/IZzH/0nI7/9Z7Q//UeD7/0W8yz9VyM2AAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAC2Wiswulwr38lgKP/WaCv/2nE1/998P//jiUr/6Jlb/+ypbv/kl1r/23s7z9x3NRAAAAAAAAAAAAAAAACyVykwuVkr78xbKf/SYSX/1mkq/+CPXv/w4t7/8NrM/+uWUv/vnFL/9bRu//W9
f//ffj3P23Y1EAAAAAAAAAAAs1cqz8heMf/OWiL/0mEk/9ZpKv/lrIz/8Ojo//Do6P/spnD/75pO//SlVv/5uG//8bZ3/9h0NK8AAAAArlMoYLxeM//LWyj/zlke/9FgJP/VZyn/23c7/+rFsf/qvJ3/6IxE/+yV
S//xnVH/9KNV//S2df/fjVD/03AzMKxSKK/Ia0L/ylMb/81XHf/QXiL/1GUn/+Sri//x6ur/8enp/+WGQP/pjkb/7JRK/+6YTf/unFP/56Bm/9BuMo+yWzP/0XhP/8tUHf/MVRz/z1sg/9NiJf/gmXL/8uvr//Lq
6v/mm2f/5YY//+eLQ//pjkX/6Y5F/+eZXv/MazG/tWA5/9J4Tv/QZTL/zVgh/85YHv/RXiP/1GUn/+7UyP/z7Oz/79bK/+GERP/igTz/44M+/+ODPv/iilD/yWkwv7VhO//Vflb/0GY0/9FnNP/RYy3/z10j/9Jg
JP/YdkD/8uXi//Pt7f/sx7P/3Xc1/955Nv/eeTb/3ntD/8VmL7+qUyzf2o5s/9BlNP/RZjT/0mg0/9NrNf/UajL/1Ggu/9+Saf/17+//9O7u/91/R//acDD/2nAw/9hwOP/CYy6vpUwmj9GKav/TckX/0GY0/9Fn
NP/puaL/7su7/96PZv/rwq3/9vLy//Xw8P/ei1z/2nU7/9p1O//PbTX/v2AtYKRMJSC0Yj7/3ZNy/9BlNP/WeU3//v39//z7+//7+Pj/+fb2//j19f/z4tv/1m83/9dwOP/Vbzf/v2Au77xeLBAAAAAApEslgMd9
XP/bjGn/0Gg4/9mCWv/wzr///fz8//z6+v/uy7r/2oVZ/9RrNv/UbDn/wmEv/7hbK1AAAAAAAAAAAAAAAACjSyWfw3dV/96Xd//UeE7/0Gg4/9BmNP/RZjT/0Wk4/9JuQP/QbUP/vV4x/7RZKmAAAAAAAAAAAAAA
AAAAAAAAAAAAAKNLJXCtWDLvxntZ/86DYv/XjGv/1Ihl/8h1T/+9ZTz/slcr37FWKVAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAApEwlEKVMJmCmTiaPqE8mv6lQJ7+rUSeArFIoUAAAAAAAAAAAAAAAAAAA
AAAAAAAA4A+sQcADrEGAAaxBgAGsQQAArEEAAKxBAACsQQAArEEAAKxBAACsQQAArEEAAKxBgAGsQcADrEHgB6xB8B+sQQ==
"@
#endregion

#region ******** $Exitico ********
$Exitico = @"
AAABAAEAEBAAAAEAIABoBAAAFgAAACgAAAAQAAAAIAAAAAEAIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAPwABEqAABTzeAAVO+wAETPsAATbdAAAPngAAADwAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAUAAMasQAPfv4AE6//AA6u/wAJrf8AB6n/AAaf/wAElP8AAWP+AAATrgAAABMAAAAAAAAAAAAAAAAAAAAXAAg22AAat/8AErz/AAS8/wAAvf8AAL7/AAC+/wAAvf8AAbb/AAKf/wAB
iP8AACbXAAAAFgAAAAAAAAABAAYkvQAhxf8AE8X/AADA/wAAwP8AAMD/AADA/wAAwP8AAMD/AADA/wAAwP8AAqb/AAGK/wAAGLsAAAAAAAAATwAfo/8AHtH/AADJ/wAAyf8AAMn/AADJ/wAAyf8AAMn/AADJ/wAA
yf8AAMn/AADI/wADn/8AAW3/AAAATwAHJrEALN7/AA7U/wAA0f8AAM3/AADN/wAAzf8AAM3/AADN/wAAzf8AAM3/AADN/wAA0f8AAr3/AASV/wAAGbEAFF7pAC/j/wAE2f9YW9b/ubrh/7q74v+6u+L/urvi/7q7
4v+6u+L/urvi/7m64f9YW9b/AADT/wAHm/8AAj7qABp1/gAy6f8AAeD/0tL5////////////////////////////////////////////0tL5/wAA3f8ACqD/AARO/gAXcv4ANe7/AAnn/0tL7v+oqPf/qan3/6mp
9/+pqff/qan3/6mp9/+pqff/qKj3/0tL7v8AAtz/AA2m/wAGT/0ADFDqADj0/wAc7v8AAO3/AADt/wAA7f8AAO3/AADt/wAA7f8AAO3/AADt/wAA7f8AAO3/AAnO/wAQq/8AAz/pAAAZsQAw5f8ANvT/AAjz/wAA
8/8AAPP/AADz/wAA8/8AAPP/AADz/wAA8/8AAPP/AAPr/wAVuf8AEKz/AAAYsAAAAE8ADon/ADv4/wAy9f8ACff/AAD5/wAA+f8AAPn/AAD5/wAA+f8AAPn/AAXw/wAYyP8AGbv/AAV5/wAAAE8AAAAAAAAavAAX
u/8AO/j/ADf0/wAg9f8ADfj/AAT7/wAE+v8ACvT/ABbk/wAizv8AH8f/AAum/wAAGrwAAAAAAAAAAAAAABYAACzXAA62/wAw7f8AOPT/ADXu/wAy6f8AL+P/ACze/wAp2P8AH87/AAis/wAALNgAAAAWAAAAAAAA
AAAAAAAAAAAAEwAAGK8AAIL+AA3W/wAc6v8AIfD/AB/s/wAX4f8ACtD/AACC/gAAGLAAAAATAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAPQAAFp8AAFHdAAB3+wAAdvsAAFHdAAAWnwAAAD0AAAAAAAAAAAAA
AAAAAAAA8A+sQcADrEGAAaxBAAGsQQAArEEAAKxBAACsQQAArEEAAKxBAACsQQAArEEAAKxBgAGsQYABrEHAA6xB8A+sQQ==
"@
#endregion

#region ********* [Extract.MyIcon] ********

#[Extract.MyIcon]::IconReturn("C:\Windows\System32\shell32.dll", 1, $False)

$MyCode = @"
using System;
using System.Drawing;
using System.Runtime.InteropServices;

namespace Extract
{
  public class MyIcon
  {
    [DllImport("user32.dll", SetLastError = true)]
    [return: MarshalAs(UnmanagedType.Bool)]
    private static extern bool DestroyIcon(IntPtr hIcon);

    [DllImport("shell32.dll", CharSet = CharSet.Auto)]
    private static extern uint ExtractIconEx(string szFileName, int nIconIndex, IntPtr[] phiconLarge, IntPtr[] phiconSmall, uint nIcons);

    public static int IconCount(string FileName)
    {
      try
      {
        IntPtr[] LIcons = new IntPtr[1] { IntPtr.Zero };
        IntPtr[] SIcons = new IntPtr[1] { IntPtr.Zero };
        return (int)ExtractIconEx(FileName, -1, LIcons, SIcons, 1);
      }
      catch { }
      return 0;
    }

    public static Icon IconReturn(string FileName, int IconNum, bool GetLarge)
    {
      IntPtr[] SIcons = new IntPtr[1] { IntPtr.Zero };
      IntPtr[] LIcons = new IntPtr[1] { IntPtr.Zero };
      Icon RetData = null;
      try
      {
        int IconCount = (int)ExtractIconEx(FileName, IconNum, LIcons, SIcons, 1);
        if (GetLarge)
        {
          if (IconCount > 0 && LIcons[0] != IntPtr.Zero)
          {
            RetData = (Icon)Icon.FromHandle(LIcons[0]).Clone();
          }
        }
        else
        {
          if (IconCount > 0 && SIcons[0] != IntPtr.Zero)
          {
            RetData = (Icon)Icon.FromHandle(SIcons[0]).Clone();
          }
        }
      }
      catch { }
      finally
      {
        foreach (IntPtr ptr in LIcons)
        {
          if (ptr != IntPtr.Zero)
          {
            DestroyIcon(ptr);
          }
        }
        foreach (IntPtr ptr in SIcons)
        {
          if (ptr != IntPtr.Zero)
          {
            DestroyIcon(ptr);
          }
        }
      }
      return RetData;
    }

    public static Icon IconReturn(string FileName, int IconNum)
    {
      return IconReturn(FileName, IconNum, false);
    }
  }
}
"@
Add-Type -TypeDefinition $MyCode -ReferencedAssemblies System.Drawing -Debug:$False
#endregion ********* [Extract.MyIcon] ********

#region function Extract-MyIcon
function Extract-MyIcon()
{
  <#
    .SYNOPSIS
      Extracts Icon from File
    .DESCRIPTION
      Extracts Icon from File
    .PARAMETER Path
      Path to File with Icon
    .PARAMETER Index
      Index of Icon
    .EXAMPLE
      $Icon = Extract-MyIcon -Path $Path
    .NOTES
      Original Function By Ken Sweet
    .LINK
  #>
  [CmdletBinding()]
  param (
    [parameter(Mandatory = $True)]
    [String]$Path,
    [Int]$Index = 0
  )
  Write-Verbose -Message "Enter Function Extract-MyIcon"
  Try
  {
    if ([System.IO.File]::Exists($Path))
    {
      [Extract.MyIcon]::IconReturn($Path, $Index, 1)
    }
  }
  Catch
  {
    Write-Debug -Message "ErrMsg: $($Error[0].Exception.Message)"
    Write-Debug -Message "Line: $($Error[0].InvocationInfo.ScriptLineNumber)"
    Write-Debug -Message "Code: $(($Error[0].InvocationInfo.Line).Trim())"
  }
  Write-Verbose -Message "Exit Function Extract-MyIcon"
}
#endregion function Extract-MyIcon

#region function Show-MyDMEditDialog
function Show-MyDMEditDialog()
{
  <#
    .SYNOPSIS
      Function to do something specific
    .DESCRIPTION
      Function to do something specific
    .PARAMETER Value
      Value Command Line Parameter
    .INPUTS
    .OUTPUTS
    .EXAMPLE
      Show-MyDMEditDialog -Value "String"
    .NOTES
      Original Function By Ken Sweet
    .LINK
  #>
  [CmdletBinding(DefaultParameterSetName = "MenuCommand")]
  param (
    [parameter(Mandatory = $True, ParameterSetName = "DesktopMenu")]
    [Switch]$DesktopMenu,
    [parameter(Mandatory = $True, ParameterSetName = "SubMenu")]
    [Switch]$SubMenu,
    [parameter(Mandatory = $True, ParameterSetName = "DesktopMenu")]
    [parameter(Mandatory = $False, ParameterSetName = "SubMenu")]
    [parameter(Mandatory = $False, ParameterSetName = "MenuCommand")]
    [String]$ReturnVal01Text,
    [parameter(Mandatory = $False, ParameterSetName = "DesktopMenu")]
    [parameter(Mandatory = $False, ParameterSetName = "SubMenu")]
    [parameter(Mandatory = $False, ParameterSetName = "MenuCommand")]
    [String]$ReturnVal02Text = "",
    [parameter(Mandatory = $False, ParameterSetName = "SubMenu")]
    [parameter(Mandatory = $False, ParameterSetName = "MenuCommand")]
    [Bool]$SeparatorBefore,
    [parameter(Mandatory = $False, ParameterSetName = "SubMenu")]
    [parameter(Mandatory = $False, ParameterSetName = "MenuCommand")]
    [Bool]$SeparatorAfter,
    [String[]]$BadNames = @(),
    [String]$IconPath = $MyDMConfig.DefaultIconPath,
    [Int]$Index = $MyDMConfig.DefaultIconIndex,
    [System.Drawing.Icon]$IconSmall = $MyDMConfig.DefaultIconSmall,
    [System.Windows.Forms.Form]$Owner = $MyDMForm,
    [Int]$FormSpacer = $MyDMConfig.FormSpacer,
    [Object]$FontData = $MyDMConfig.FontData,
    [System.Drawing.Color]$BackColor = $MyDMColor.BackColor,
    [System.Drawing.Color]$ForeColor = $MyDMColor.ForeColor,
    [System.Drawing.Color]$LabelForeColor = $MyDMColor.LabelForeColor,
    [System.Drawing.Color]$ErrorForeColor = $MyDMColor.ErrorForeColor,
    [System.Drawing.Color]$TitleBackColor = $MyDMColor.TitleBackColor,
    [System.Drawing.Color]$TitleForeColor = $MyDMColor.TitleForeColor,
    [System.Drawing.Color]$GroupForeColor = $MyDMColor.GroupForeColor,
    [System.Drawing.Color]$TextBackColor = $MyDMColor.TextBackColor,
    [System.Drawing.Color]$TextForeColor = $MyDMColor.TextForeColor,
    [System.Drawing.Color]$ButtonBackColor = $MyDMColor.ButtonBackColor,
    [System.Drawing.Color]$ButtonForeColor = $MyDMColor.ButtonForeColor
  )
  Write-Verbose -Message "Enter Function Show-MyDMEditDialog"
  
  #region Dialog Starting Values
  Switch ($PSCmdlet.ParametersetName)
  {
    "DesktopMenu"
    {
      $TitleName = "Desktop Menu"
      $ReturnName = "Desktop Menu"
      $ReturnVals = 2
      $ReturnVal01Label = "Menu GUID"
      $ReturnVal01ReadOnly = $True
      $ReturnVal02Label = "Menu Name"
      $ReturnVal02ReadOnly = $False
      $ShowSperarator = $False
      Break
    }
    "SubMenu"
    {
      $TitleName = "Sub Menu"
      $ReturnName = "Desktop Menu Sub Menu"
      $ReturnVals = 1
      $ReturnVal01Label = "Sub Menu Name"
      $ReturnVal01ReadOnly = $False
      $ShowSperarator = $True
      Break
    }
    "MenuCommand"
    {
      $TitleName = "Menu Command"
      $ReturnName = "Desktop Menu Command"
      $ReturnVals = 2
      $ReturnVal01Label = "Command Name"
      $ReturnVal01ReadOnly = $False
      $ReturnVal02Label = "Command Line"
      $ReturnVal02ReadOnly = $False
      $ShowSperarator = $True
      Break
    }
  }
  
  $NumPicBox = 8
  
  $MyDMEReturn = [Ordered]@{
    "DialogResult" = [System.Windows.Forms.DialogResult]::OK;
    "ReturnVal01Text" = $ReturnVal01Text;
    "ReturnVal02Text" = $ReturnVal02Text;
    "SeparatorBefore" = $SeparatorBefore;
    "SeparatorAfter" = $SeparatorAfter;
    "IconPath" = $IconPath;
    "Index" = $Index;
    "IconSmall" = $Null;
  }
  #endregion Dialog Starting Values
  
  $MyDMEFormComponents = New-Object -TypeName System.ComponentModel.Container

  #region $MyDMEToolTip = System.Windows.Forms.ToolTip
  Write-Verbose -Message "Creating Form Control `$MyDMEToolTip"
  $MyDMEToolTip = New-Object -TypeName System.Windows.Forms.ToolTip($MyDMEFormComponents)
  $MyDMEToolTip.Active = $False
  #$MyDMEToolTip.AutomaticDelay = 500
  #$MyDMEToolTip.AutoPopDelay = 5000
  #$MyDMEToolTip.BackColor = [System.Drawing.SystemColors]::Info
  #$MyDMEToolTip.ForeColor = [System.Drawing.SystemColors]::InfoText
  #$MyDMEToolTip.InitialDelay = 500
  #$MyDMEToolTip.IsBalloon = $False
  #$MyDMEToolTip.OwnerDraw = $False
  #$MyDMEToolTip.ReshowDelay = 100
  #$MyDMEToolTip.ShowAlways = $False
  #$MyDMEToolTip.Site = System.ComponentModel.ISite
  #$MyDMEToolTip.StripAmpersands = $False
  #$MyDMEToolTip.Tag = $Null
  #$MyDMEToolTip.ToolTipIcon = [System.Windows.Forms.ToolTipIcon]::None
  $MyDMEToolTip.ToolTipTitle = "$($MyDMConfig.ScriptName) - $($MyDMConfig.ScriptVersion)"
  #$MyDMEToolTip.UseAnimation = $True
  #$MyDMEToolTip.UseFading = $True
  #endregion
  #$MyDMEToolTip.SetToolTip($FormControl, "Form Control Help")

  #region $MyDMEForm = System.Windows.Forms.Form
  Write-Verbose -Message "Creating Form Control `$MyDMEForm"
  $MyDMEForm = New-Object -TypeName System.Windows.Forms.Form
  $MyDMEForm.BackColor = $BackColor
  $MyDMEForm.DialogResult = [System.Windows.Forms.DialogResult]::None
  $MyDMEForm.Font = $FontData.Regular
  $MyDMEForm.ForeColor = $ForeColor
  $MyDMEForm.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::Fixed3D
  $MyDMEForm.KeyPreview = $True
  $MyDMEForm.MaximizeBox = $False
  $MyDMEForm.MinimizeBox = $False
  $MyDMEForm.Name = "MyDMEForm"
  $MyDMEForm.Owner = $Owner
  $MyDMEForm.ShowIcon = $False
  $MyDMEForm.ShowInTaskbar = $False
  $MyDMEForm.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterParent
  $MyDMEForm.Tag = (-not $MyDMConfig.Production)
  $MyDMEForm.Text = $TitleName
  #endregion
  $MyDMEToolTip.SetToolTip($MyDMEForm, "Help for Control $($MyDMEForm.Name)")

  #region function Start-MyDMEFormKeyDown
  function Start-MyDMEFormKeyDown()
  {
    <#
      .SYNOPSIS
        KeyDown event for the MyDMEForm Control
      .DESCRIPTION
        KeyDown event for the MyDMEForm Control
      .PARAMETER Sender
         The Form Control that fired the Event
      .PARAMETER EventArg
         The Event Arguments for the Event
      .EXAMPLE
         Start-MyDMEFormKeyDown -Sender $Sender -EventArg $EventArg
      .NOTES
        Original Function By Ken Sweet
      .LINK
    #>
    [CmdletBinding()]
    param (
      [parameter(Mandatory = $True)]
      [Object]$Sender,
      [parameter(Mandatory = $True)]
      [Object]$EventArg
    )
    Write-Verbose -Message "Enter KeyDown Event for `$MyDMEForm"
    Try
    {
      #$MyDMEForm.Cursor = [System.Windows.Forms.Cursors]::WaitCursor
      if ($EventArg.KeyCode -eq [System.Windows.Forms.Keys]::Escape)
      {
        $MyDMEForm.Close()
      }
      #$MyDMEForm.Cursor = [System.Windows.Forms.Cursors]::Arrow

      [System.GC]::Collect()
      [System.GC]::WaitForPendingFinalizers()
    }
    Catch
    {
      Write-Debug -Message "ErrMsg: $($Error[0].Exception.Message)"
      Write-Debug -Message "Line: $($Error[0].InvocationInfo.ScriptLineNumber)"
      Write-Debug -Message "Code: $(($Error[0].InvocationInfo.Line).Trim())"
    }
    Write-Verbose -Message "Exit KeyDown Event for `$MyDMEForm"
  }
  #endregion function Start-MyDMEFormKeyDown
  $MyDMEForm.add_KeyDown({Start-MyDMEFormKeyDown -Sender $This -EventArg $PSItem})

  #region function Start-MyDMEFormShown
  function Start-MyDMEFormShown()
  {
    <#
      .SYNOPSIS
        Shown event for the MyDMEForm Control
      .DESCRIPTION
        Shown event for the MyDMEForm Control
      .PARAMETER Sender
         The Form Control that fired the Event
      .PARAMETER EventArg
         The Event Arguments for the Event
      .EXAMPLE
         Start-MyDMEFormShown -Sender $Sender -EventArg $EventArg
      .NOTES
        Original Function By Ken Sweet
      .LINK
    #>
    [CmdletBinding()]
    param (
      [parameter(Mandatory = $True)]
      [Object]$Sender,
      [parameter(Mandatory = $True)]
      [Object]$EventArg
    )
    Write-Verbose -Message "Enter Shown Event for `$MyDMEForm"
    Try
    {
      #$MyDMEForm.Cursor = [System.Windows.Forms.Cursors]::WaitCursor
      $Sender.Refresh()
      if ($MyDMEReturnVal01TextBox.ReadOnly)
      {
        $MyDMEReturnVal02TextBox.Select()
      }
      else
      {
        $MyDMEReturnVal01TextBox.Select()
      }
      #$MyDMEForm.Cursor = [System.Windows.Forms.Cursors]::Arrow

      [System.GC]::Collect()
      [System.GC]::WaitForPendingFinalizers()
    }
    Catch
    {
      Write-Debug -Message "ErrMsg: $($Error[0].Exception.Message)"
      Write-Debug -Message "Line: $($Error[0].InvocationInfo.ScriptLineNumber)"
      Write-Debug -Message "Code: $(($Error[0].InvocationInfo.Line).Trim())"
    }
    Write-Verbose -Message "Exit Shown Event for `$MyDMEForm"
  }
  #endregion function Start-MyDMEFormShown
  $MyDMEForm.add_Shown({Start-MyDMEFormShown -Sender $This -EventArg $PSItem})

  #region ******** $MyDMEForm Controls ********

  #region $MyDMEReturnGroupBox = System.Windows.Forms.GroupBox
  Write-Verbose -Message "Creating Form Control `$MyDMEReturnGroupBox"
  $MyDMEReturnGroupBox = New-Object -TypeName System.Windows.Forms.GroupBox
  $MyDMEForm.Controls.Add($MyDMEReturnGroupBox)
  $MyDMEReturnGroupBox.Font = $FontData.Regular
  $MyDMEReturnGroupBox.ForeColor = $GroupForeColor
  $MyDMEReturnGroupBox.Location = New-Object -TypeName System.Drawing.Point($FormSpacer, $FormSpacer)
  $MyDMEReturnGroupBox.Name = "MyDMEReturnGroupBox"
  $MyDMEReturnGroupBox.Text = $ReturnName
  #endregion

  #region ******** $MyDMEReturnGroupBox Controls ********
  
  #region $MyDMEReturnOpenFileDialog = System.Windows.Forms.OpenFileDialog
  Write-Verbose -Message "Creating Form Control `$MyDMEReturnOpenFileDialog"
  $MyDMEReturnOpenFileDialog = New-Object -TypeName System.Windows.Forms.OpenFileDialog
  $MyDMEReturnOpenFileDialog.FileName = ""
  $MyDMEReturnOpenFileDialog.Filter = "All Applications|*.exe;*.cmd;*.bat;*.ps1;*.vbs|EXE Files|*.exe|Batch Files|;*.cmd;*.bat|PowerShell Scripts|*.ps1|VBScripts|*.vbs|All Files|*.*"
  $MyDMEReturnOpenFileDialog.InitialDirectory = [Environment]::CurrentDirectory
  $MyDMEReturnOpenFileDialog.Multiselect = $False
  $MyDMEReturnOpenFileDialog.RestoreDirectory = $True
  $MyDMEReturnOpenFileDialog.ShowHelp = $False
  $MyDMEReturnOpenFileDialog.Title = "Select Command"
  #endregion
  
  #region $MyDMEReturnIconPictureBox = System.Windows.Forms.PictureBox
  Write-Verbose -Message "Creating Form Control `$MyDMEReturnIconPictureBox"
  $MyDMEReturnIconPictureBox = New-Object -TypeName System.Windows.Forms.PictureBox
  $MyDMEReturnGroupBox.Controls.Add($MyDMEReturnIconPictureBox)
  $MyDMEReturnIconPictureBox.BackColor = $MyDMColor.TextBackColor
  if ($Index -ne -1)
  {
    if ([System.IO.File]::Exists($IconPath))
    {
      $MyDMEReturn.IconSmall = [Extract.MyIcon]::IconReturn($MyDMEReturn.IconPath, $MyDMEReturn.Index, $False)
      $MyDMEReturnIconPictureBox.Image = [Extract.MyIcon]::IconReturn($MyDMEReturn.IconPath, $MyDMEReturn.Index, $True)
    }
  }
  $MyDMEReturnIconPictureBox.Location = New-Object -TypeName System.Drawing.Point(($FormSpacer * 2), $FontData.Height)
  $MyDMEReturnIconPictureBox.Name = "MyDMEReturnIconPictureBox"
  $MyDMEReturnIconPictureBox.Size = New-Object -TypeName System.Drawing.Size(48, 48)
  $MyDMEReturnIconPictureBox.SizeMode = [System.Windows.Forms.PictureBoxSizeMode]::CenterImage
  $MyDMEReturnIconPictureBox.TabStop = $False
  $MyDMEReturnIconPictureBox.Text = "MyDMEReturnIconPictureBox"
  #endregion
  $MyDMEToolTip.SetToolTip($MyDMEReturnIconPictureBox, "Help for Control $($MyDMEReturnIconPictureBox.Name)")
  
  #region function Start-MyDMEReturnIconPictureBoxClick
  function Start-MyDMEReturnIconPictureBoxClick()
  {
    <#
      .SYNOPSIS
        Click event for the MyDMEReturnIconPictureBox Control
      .DESCRIPTION
        Click event for the MyDMEReturnIconPictureBox Control
      .PARAMETER Sender
         The Form Control that fired the Event
      .PARAMETER EventArg
         The Event Arguments for the Event
      .EXAMPLE
         Start-MyDMEReturnIconPictureBoxClick -Sender $Sender -EventArg $EventArg
      .NOTES
        Original Function By Ken Sweet
      .LINK
    #>
    [CmdletBinding()]
    param (
      [parameter(Mandatory = $True)]
      [Object]$Sender,
      [parameter(Mandatory = $True)]
      [Object]$EventArg
    )
    Write-Verbose -Message "Enter Click Event for `$MyDMEReturnIconPictureBox"
    Try
    {
      #$MyDMEForm.Cursor = [System.Windows.Forms.Cursors]::WaitCursor
      if ($EventArg.Button -eq [System.Windows.Forms.MouseButtons]::Right)
      {
        if ([System.Windows.Forms.MessageBox]::Show($MyDMEForm, "Clear Selected Icon?", "Clear Icon?", [System.Windows.Forms.MessageBoxButtons]::YesNo, [System.Windows.Forms.MessageBoxIcon]::Question) -eq [System.Windows.Forms.DialogResult]::Yes)
        {
          $MyDMEReturn.IconPath = ""
          $MyDMEReturn.Index = -1
          $MyDMEReturnIconPictureBox.Image = $Null
        }
      }
      #$MyDMEForm.Cursor = [System.Windows.Forms.Cursors]::Arrow

      [System.GC]::Collect()
      [System.GC]::WaitForPendingFinalizers()
    }
    Catch
    {
      Write-Debug -Message "ErrMsg: $($Error[0].Exception.Message)"
      Write-Debug -Message "Line: $($Error[0].InvocationInfo.ScriptLineNumber)"
      Write-Debug -Message "Code: $(($Error[0].InvocationInfo.Line).Trim())"
    }
    Write-Verbose -Message "Exit Click Event for `$MyDMEReturnIconPictureBox"
  }
  #endregion function Start-MyDMEReturnIconPictureBoxClick
  if ($ShowSperarator)
  {
    $MyDMEReturnIconPictureBox.add_Click({Start-MyDMEReturnIconPictureBoxClick -Sender $This -EventArg $PSItem})
  }

  #region function Start-MyDMEReturnIconPictureBoxDoubleClick
  function Start-MyDMEReturnIconPictureBoxDoubleClick()
  {
    <#
      .SYNOPSIS
        DoubleClick event for the MyDMEReturnIconPictureBox Control
      .DESCRIPTION
        DoubleClick event for the MyDMEReturnIconPictureBox Control
      .PARAMETER Sender
         The Form Control that fired the Event
      .PARAMETER EventArg
         The Event Arguments for the Event
      .EXAMPLE
         Start-MyDMEReturnIconPictureBoxDoubleClick -Sender $Sender -EventArg $EventArg
      .NOTES
        Original Function By Ken Sweet
      .LINK
    #>
    [CmdletBinding()]
    param (
      [parameter(Mandatory = $True)]
      [Object]$Sender,
      [parameter(Mandatory = $True)]
      [Object]$EventArg
    )
    Write-Verbose -Message "Enter DoubleClick Event for `$MyDMEReturnIconPictureBox"
    Try
    {
      #$MyDMEForm.Cursor = [System.Windows.Forms.Cursors]::WaitCursor
      if (($Data = Show-MyDMIconDialog -Owner $MyDMEForm -IconPath $MyDMEReturn.IconPath -Index $MyDMEReturn.Index).DialogResult -eq [System.Windows.Forms.DialogResult]::OK)
      {
        $MyDMEReturn.IconPath = $Data.IconPath
        $MyDMEReturn.Index = $Data.Index
        $MyDMEReturn.IconSmall = [Extract.MyIcon]::IconReturn($Data.IconPath, $Data.Index, $False)
        $MyDMEReturnIconPictureBox.Image = [Extract.MyIcon]::IconReturn($Data.IconPath, $Data.Index, $True)
      }
      #$MyDMEForm.Cursor = [System.Windows.Forms.Cursors]::Arrow

      [System.GC]::Collect()
      [System.GC]::WaitForPendingFinalizers()
    }
    Catch
    {
      Write-Debug -Message "ErrMsg: $($Error[0].Exception.Message)"
      Write-Debug -Message "Line: $($Error[0].InvocationInfo.ScriptLineNumber)"
      Write-Debug -Message "Code: $(($Error[0].InvocationInfo.Line).Trim())"
    }
    Write-Verbose -Message "Exit DoubleClick Event for `$MyDMEReturnIconPictureBox"
  }
  #endregion function Start-MyDMEReturnIconPictureBoxDoubleClick
  $MyDMEReturnIconPictureBox.add_DoubleClick({Start-MyDMEReturnIconPictureBoxDoubleClick -Sender $This -EventArg $PSItem})

  #region $MyDMEReturnVal01Label = System.Windows.Forms.Label
  Write-Verbose -Message "Creating Form Control `$MyDMEReturnVal01Label"
  $MyDMEReturnVal01Label = New-Object -TypeName System.Windows.Forms.Label
  $MyDMEReturnGroupBox.Controls.Add($MyDMEReturnVal01Label)
  $MyDMEReturnVal01Label.BackColor = $BackColor
  $MyDMEReturnVal01Label.Font = $FontData.Regular
  $MyDMEReturnVal01Label.ForeColor = $LabelForeColor
  $MyDMEReturnVal01Label.Location = New-Object -TypeName System.Drawing.Point(($MyDMEReturnIconPictureBox.Right + $FormSpacer), $MyDMEReturnIconPictureBox.Top)
  $MyDMEReturnVal01Label.Name = "MyDMEReturnVal01Label"
  $MyDMEReturnVal01Label.Text = "$($ReturnVal01Label):"
  $MyDMEReturnVal01Label.TextAlign = [System.Drawing.ContentAlignment]::MiddleRight
  #endregion
  $MyDMEReturnVal01Label.Size = $MyDMEReturnVal01Label.PreferredSize

  if ($ReturnVals -eq 2)
  {
    #region $MyDMEReturnVal02Label = System.Windows.Forms.Label
    Write-Verbose -Message "Creating Form Control `$MyDMEReturnVal02Label"
    $MyDMEReturnVal02Label = New-Object -TypeName System.Windows.Forms.Label
    $MyDMEReturnGroupBox.Controls.Add($MyDMEReturnVal02Label)
    $MyDMEReturnVal02Label.BackColor = $BackColor
    $MyDMEReturnVal02Label.Font = $FontData.Regular
    $MyDMEReturnVal02Label.ForeColor = $LabelForeColor
    $MyDMEReturnVal02Label.Location = New-Object -TypeName System.Drawing.Point($MyDMEReturnVal01Label.Left, ($MyDMEReturnVal01Label.Bottom + ($FormSpacer * 2)))
    $MyDMEReturnVal02Label.Name = "MyDMEReturnVal02Label"
    $MyDMEReturnVal02Label.Text = "$($ReturnVal02Label):"
    $MyDMEReturnVal02Label.TextAlign = [System.Drawing.ContentAlignment]::MiddleRight
    #endregion
    $MyDMEReturnVal02Label.Size = $MyDMEReturnVal02Label.PreferredSize
    $TempWidth = [Math]::Max($MyDMEReturnVal01Label.Size.Width, $MyDMEReturnVal02Label.Size.Width)
    $MyDMEReturnVal01Label.Width = $TempWidth
    $MyDMEReturnVal02Label.Width = $TempWidth
    
    $MyDMEReturnIconPictureBox.Top = $MyDMEReturnIconPictureBox.Top + [Math]::Floor(($MyDMEReturnVal02Label.Bottom - $MyDMEReturnIconPictureBox.Bottom) / 2)
    
    $TempBottom = [Math]::Max(($MyDMEReturnVal02Label.Bottom + ($FormSpacer * 2)), $MyDMEReturnIconPictureBox.Bottom)
    
    #region $MyDMEReturnVal02TextBox = System.Windows.Forms.TextBox
    Write-Verbose -Message "Creating Form Control `$MyDMEReturnVal02TextBox"
    $MyDMEReturnVal02TextBox = New-Object -TypeName System.Windows.Forms.TextBox
    $MyDMEReturnGroupBox.Controls.Add($MyDMEReturnVal02TextBox)
    $MyDMEReturnVal02TextBox.BackColor = $TextBackColor
    $MyDMEReturnVal02TextBox.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
    $MyDMEReturnVal02TextBox.Font = $FontData.Regular
    $MyDMEReturnVal02TextBox.ForeColor = $TextForeColor
    $MyDMEReturnVal02TextBox.Height = $MyDMEReturnVal02Label.Height
    $MyDMEReturnVal02TextBox.Location = New-Object -TypeName System.Drawing.Point(($MyDMEReturnVal02Label.Right + $FormSpacer), $MyDMEReturnVal02Label.Top)
    $MyDMEReturnVal02TextBox.MaxLength = 50
    $MyDMEReturnVal02TextBox.Name = "MyDMEReturnVal02TextBox"
    $MyDMEReturnVal02TextBox.ReadOnly = $ReturnVal02ReadOnly
    $MyDMEReturnVal02TextBox.TabIndex = 1
    $MyDMEReturnVal02TextBox.TabStop = $True
    $MyDMEReturnVal02TextBox.Text = $ReturnVal02Text
    $MyDMEReturnVal02TextBox.TextAlign = [System.Windows.Forms.HorizontalAlignment]::Left
    $MyDMEReturnVal02TextBox.Width = $MyDMEReturnIconPictureBox.Width * $NumPicBox
    #endregion
    $MyDMEToolTip.SetToolTip($MyDMEReturnVal02TextBox, "Help for Control $($MyDMEReturnVal02TextBox.Name)")
    
    #region function Start-MyDMEReturnVal02TextBoxDoubleClick
    function Start-MyDMEReturnVal02TextBoxDoubleClick()
    {
      <#
        .SYNOPSIS
          DoubleClick event for the MyDMEReturnVal02TextBox Control
        .DESCRIPTION
          DoubleClick event for the MyDMEReturnVal02TextBox Control
        .PARAMETER Sender
           The Form Control that fired the Event
        .PARAMETER EventArg
           The Event Arguments for the Event
        .EXAMPLE
           Start-MyDMEReturnVal02TextBoxDoubleClick -Sender $Sender -EventArg $EventArg
        .NOTES
          Original Function By Ken Sweet
        .LINK
      #>
      [CmdletBinding()]
      param (
        [parameter(Mandatory = $True)]
        [Object]$Sender,
        [parameter(Mandatory = $True)]
        [Object]$EventArg
      )
      Write-Verbose -Message "Enter DoubleClick Event for `$MyDMEReturnVal02TextBox"
      Try
      {
        #$MyDMIForm.Cursor = [System.Windows.Forms.Cursors]::WaitCursor
        if ($MyDMEReturnOpenFileDialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK)
        {
          if ([String]::IsNullOrEmpty($MyDMEReturnVal01TextBox.Text))
          {
            $MyDMEReturnVal01TextBox.Text = [System.IO.Path]::GetFileName($MyDMEReturnOpenFileDialog.FileName)
          }
          $MyDMEReturnVal02TextBox.Text = "`"$($MyDMEReturnOpenFileDialog.FileName)`""
          if (([System.IO.Path]::GetExtension($MyDMEReturnOpenFileDialog.FileName) -eq ".exe") -and ($MyDMEReturn.Index -eq -1))
          {
            $MyDMEReturn.IconPath = $MyDMEReturnOpenFileDialog.FileName
            $MyDMEReturn.Index = 0
            $MyDMEReturn.IconSmall = [Extract.MyIcon]::IconReturn($MyDMEReturn.IconPath, 0, $False)
            $MyDMEReturnIconPictureBox.Image = [Extract.MyIcon]::IconReturn($MyDMEReturn.IconPath, 0, $True)
          }
        }
        #$MyDMIForm.Cursor = [System.Windows.Forms.Cursors]::Arrow

        [System.GC]::Collect()
        [System.GC]::WaitForPendingFinalizers()
      }
      Catch
      {
        Write-Debug -Message "ErrMsg: $($Error[0].Exception.Message)"
        Write-Debug -Message "Line: $($Error[0].InvocationInfo.ScriptLineNumber)"
        Write-Debug -Message "Code: $(($Error[0].InvocationInfo.Line).Trim())"
      }
      Write-Verbose -Message "Exit DoubleClick Event for `$MyDMEReturnVal02TextBox"
    }
    #endregion function Start-MyDMEReturnVal02TextBoxDoubleClick
    if ($ShowSperarator)
    {
      $MyDMEReturnVal02TextBox.add_DoubleClick({Start-MyDMEReturnVal02TextBoxDoubleClick -Sender $This -EventArg $PSItem})
    }
  }
  else
  {
    $MyDMEReturnVal01Label.Top = $MyDMEReturnVal01Label.Top + [Math]::Floor(($MyDMEReturnIconPictureBox.Bottom - $MyDMEReturnVal01Label.Bottom) / 2)
    $TempBottom = [Math]::Max($MyDMEReturnVal01Label.Bottom, $MyDMEReturnIconPictureBox.Bottom)
  }
  
  #region $MyDMEReturnVal01TextBox = System.Windows.Forms.TextBox
  Write-Verbose -Message "Creating Form Control `$MyDMEReturnVal01TextBox"
  $MyDMEReturnVal01TextBox = New-Object -TypeName System.Windows.Forms.TextBox
  $MyDMEReturnGroupBox.Controls.Add($MyDMEReturnVal01TextBox)
  $MyDMEReturnVal01TextBox.BackColor = $TextBackColor
  $MyDMEReturnVal01TextBox.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
  $MyDMEReturnVal01TextBox.Font = $FontData.Regular
  $MyDMEReturnVal01TextBox.ForeColor = $TextForeColor
  $MyDMEReturnVal01TextBox.Height = $MyDMEReturnVal01Label.Height
  $MyDMEReturnVal01TextBox.Location = New-Object -TypeName System.Drawing.Point(($MyDMEReturnVal01Label.Right + $FormSpacer), $MyDMEReturnVal01Label.Top)
  $MyDMEReturnVal01TextBox.MaxLength = 50
  $MyDMEReturnVal01TextBox.Name = "MyDMEReturnVal01TextBox"
  $MyDMEReturnVal01TextBox.ReadOnly = $ReturnVal01ReadOnly
  $MyDMEReturnVal01TextBox.TabIndex = 0
  $MyDMEReturnVal01TextBox.TabStop = $True
  $MyDMEReturnVal01TextBox.Text = $ReturnVal01Text
  $MyDMEReturnVal01TextBox.TextAlign = [System.Windows.Forms.HorizontalAlignment]::Left
  $MyDMEReturnVal01TextBox.Width = $MyDMEReturnIconPictureBox.Width * $NumPicBox
  #endregion
  $MyDMEToolTip.SetToolTip($MyDMEReturnVal01TextBox, "Help for Control $($MyDMEReturnVal01TextBox.Name)")
  
  if ($ShowSperarator)
  {
    #region $MyDMEReturnBeforeCheckBox = System.Windows.Forms.CheckBox
    Write-Verbose -Message "Creating Form Control `$MyDMEReturnBeforeCheckBox"
    $MyDMEReturnBeforeCheckBox = New-Object -TypeName System.Windows.Forms.CheckBox
    $MyDMEReturnGroupBox.Controls.Add($MyDMEReturnBeforeCheckBox)
    $MyDMEReturnBeforeCheckBox.AutoSize = $True
    $MyDMEReturnBeforeCheckBox.Checked = $SeparatorBefore
    $MyDMEReturnBeforeCheckBox.Font = $FontData.Regular
    $MyDMEReturnBeforeCheckBox.ForeColor = $LabelForeColor
    $MyDMEReturnBeforeCheckBox.Name = "MyDMEReturnBeforeCheckBox"
    $MyDMEReturnBeforeCheckBox.TabIndex = 2
    $MyDMEReturnBeforeCheckBox.TabStop = $True
    $MyDMEReturnBeforeCheckBox.Text = "Separator Before"
    #endregion
    $MyDMEToolTip.SetToolTip($MyDMEReturnBeforeCheckBox, "Help for Control $($MyDMEReturnBeforeCheckBox.Name)")
    
    #region $MyDMEReturnAfterCheckBox = System.Windows.Forms.CheckBox
    Write-Verbose -Message "Creating Form Control `$MyDMEReturnAfterCheckBox"
    $MyDMEReturnAfterCheckBox = New-Object -TypeName System.Windows.Forms.CheckBox
    $MyDMEReturnGroupBox.Controls.Add($MyDMEReturnAfterCheckBox)
    $MyDMEReturnAfterCheckBox.AutoSize = $True
    $MyDMEReturnAfterCheckBox.Checked = $SeparatorAfter
    $MyDMEReturnAfterCheckBox.Font = $FontData.Regular
    $MyDMEReturnAfterCheckBox.ForeColor = $LabelForeColor
    $MyDMEReturnAfterCheckBox.Name = "MyDMEReturnAfterCheckBox"
    $MyDMEReturnAfterCheckBox.TabIndex = 3
    $MyDMEReturnAfterCheckBox.TabStop = $True
    $MyDMEReturnAfterCheckBox.Text = "Separator After"
    #endregion
    $MyDMEToolTip.SetToolTip($MyDMEReturnAfterCheckBox, "Help for Control $($MyDMEReturnAfterCheckBox.Name)")
    
    $TempSpace = [Math]::Floor(($MyDMEReturnVal01TextBox.Right - ($MyDMEReturnVal01Label.Left + $MyDMEReturnBeforeCheckBox.Width + $MyDMEReturnAfterCheckBox.Width + $FormSpacer)))
    $TempLeft = [Math]::Floor($TempSpace / 4)
    $TempMod = $TempSpace % 4
    
    $MyDMEReturnBeforeCheckBox.Location = New-Object -TypeName System.Drawing.Point(($MyDMEReturnVal01Label.Left + $TempLeft + $FormSpacer), ($TempBottom + $FormSpacer))
    $MyDMEReturnAfterCheckBox.Location = New-Object -TypeName System.Drawing.Point(($MyDMEReturnBeforeCheckBox.Right + $FormSpacer + ($TempLeft * 2) + $TempMod), ($TempBottom + $FormSpacer))
    
    $TempBottom = $MyDMEReturnAfterCheckBox.Bottom
  }
  
  $MyDMEReturnGroupBox.ClientSize = New-Object -TypeName System.Drawing.Size(($MyDMEReturnVal01TextBox.Right + ($FormSpacer * 2)), ($TempBottom + ($FormSpacer * 2)))
  
  
  #endregion ******** $MyDMEReturnGroupBox Controls ********

  #region $MyDMEOKButton = System.Windows.Forms.Button
  Write-Verbose -Message "Creating Form Control `$MyDMEOKButton"
  $MyDMEOKButton = New-Object -TypeName System.Windows.Forms.Button
  $MyDMEForm.Controls.Add($MyDMEOKButton)
  # Evenly Space Buttons - Move Size to after Text
  $NumButtons = 2
  $TempSpace = [Math]::Floor($MyDMEReturnGroupBox.Width - ($FormSpacer * ($NumButtons + 2)))
  $TempWidth = [Math]::Floor($TempSpace / $NumButtons)
  $TempMod = $TempSpace % $NumButtons
  $MyDMEOKButton.AutoSize = $True
  $MyDMEOKButton.BackColor = $ButtonBackColor
  $MyDMEOKButton.Font = $FontData.Bold
  $MyDMEOKButton.ForeColor = $ButtonForeColor
  $MyDMEOKButton.Location = New-Object -TypeName System.Drawing.Point(($FormSpacer * 2), ($MyDMEReturnGroupBox.Bottom + ($FormSpacer * 2)))
  $MyDMEOKButton.Name = "MyDMEOKButton"
  $MyDMEOKButton.TabIndex = 4
  $MyDMEOKButton.TabStop = $True
  $MyDMEOKButton.Text = "OK"
  $MyDMEOKButton.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
  $MyDMEOKButton.Width = $TempWidth
  #endregion
  $MyDMEToolTip.SetToolTip($MyDMEOKButton, "Help for Control $($MyDMEOKButton.Name)")

  #region function Start-MyDMEOKButtonClick
  function Start-MyDMEOKButtonClick()
  {
    <#
      .SYNOPSIS
        Click event for the MyDMEOKButton Control
      .DESCRIPTION
        Click event for the MyDMEOKButton Control
      .PARAMETER Sender
         The Form Control that fired the Event
      .PARAMETER EventArg
         The Event Arguments for the Event
      .EXAMPLE
         Start-MyDMEOKButtonClick -Sender $Sender -EventArg $EventArg
      .NOTES
        Original Function By Ken Sweet
      .LINK
    #>
    [CmdletBinding()]
    param (
      [parameter(Mandatory = $True)]
      [Object]$Sender,
      [parameter(Mandatory = $True)]
      [Object]$EventArg
    )
    Write-Verbose -Message "Enter Click Event for `$MyDMEOKButton"
    Try
    {
      #$MyDMEForm.Cursor = [System.Windows.Forms.Cursors]::WaitCursor
      
      $NoError = $True
      
      if (([String]::IsNullOrEmpty($MyDMEReturnVal01TextBox.Text)) -or ($BadNames -contains $MyDMEReturnVal01TextBox.Text))
      {
        $MyDMEReturnVal01Label.ForeColor = $ErrorForeColor
        $NoError = $False
      }
      else
      {
        $MyDMEReturnVal01Label.ForeColor = $ForeColor
        $MyDMEReturn.ReturnVal01Text = $MyDMEReturnVal01TextBox.Text
      }
      
      if ($ReturnVals -eq 2)
      {
        if (([String]::IsNullOrEmpty($MyDMEReturnVal02TextBox.Text)) -or (($BadNames -contains $MyDMEReturnVal02TextBox.Text) -and (-not $ShowSperarator)))
        {
          $MyDMEReturnVal02Label.ForeColor = $ErrorForeColor
          $NoError = $False
        }
        else
        {
          $MyDMEReturnVal02Label.ForeColor = $ForeColor
          $MyDMEReturn.ReturnVal02Text = $MyDMEReturnVal02TextBox.Text
        }
      }
      
      if ($ShowSperarator)
      {
        $MyDMEReturn.SeparatorBefore = $MyDMEReturnBeforeCheckBox.Checked
        $MyDMEReturn.SeparatorAfter = $MyDMEReturnAfterCheckBox.Checked
      }
      
      if ((-not $ShowSperarator) -and ($MyDMEReturn.Index -eq -1))
      {
        $NoError = $False
      }
      
      if ($NoError)
      {
        $MyDMEForm.DialogResult = [System.Windows.Forms.DialogResult]::OK
        $MyDMEForm.Close()
      }
      else
      {
        [Void]([System.Windows.Forms.MessageBox]::Show($MyDMEForm, "Error with entered $TitleName values.", "Error: $TitleName", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error))
      }
      #$MyDMEForm.Cursor = [System.Windows.Forms.Cursors]::Arrow
      
      [System.GC]::Collect()
      [System.GC]::WaitForPendingFinalizers()
    }
    Catch
    {
      Write-Debug -Message "ErrMsg: $($Error[0].Exception.Message)"
      Write-Debug -Message "Line: $($Error[0].InvocationInfo.ScriptLineNumber)"
      Write-Debug -Message "Code: $(($Error[0].InvocationInfo.Line).Trim())"
    }
    Write-Verbose -Message "Exit Click Event for `$MyDMEOKButton"
  }
  #endregion function Start-MyDMEOKButtonClick
  $MyDMEOKButton.add_Click({ Start-MyDMEOKButtonClick -Sender $This -EventArg $PSItem })

  #region $MyDMECancelButton = System.Windows.Forms.Button
  Write-Verbose -Message "Creating Form Control `$MyDMECancelButton"
  $MyDMECancelButton = New-Object -TypeName System.Windows.Forms.Button
  $MyDMEForm.Controls.Add($MyDMECancelButton)
  $MyDMECancelButton.AutoSize = $True
  $MyDMECancelButton.BackColor = $ButtonBackColor
  $MyDMECancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
  $MyDMECancelButton.Font = $FontData.Bold
  $MyDMECancelButton.ForeColor = $ButtonForeColor
  $MyDMECancelButton.Location = New-Object -TypeName System.Drawing.Point(($MyDMEOKButton.Right + $TempMod + ($FormSpacer * 2)), $MyDMEOKButton.Top)
  $MyDMECancelButton.Name = "MyDMECancelButton"
  $MyDMECancelButton.TabIndex = 5
  $MyDMECancelButton.TabStop = $True
  $MyDMECancelButton.Text = "Cancel"
  $MyDMECancelButton.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
  $MyDMECancelButton.Width = $TempWidth
  #endregion
  $MyDMEToolTip.SetToolTip($MyDMECancelButton, "Help for Control $($MyDMECancelButton.Name)")

  $MyDMEForm.ClientSize = New-Object -TypeName System.Drawing.Size(($MyDMEReturnGroupBox.Right + $FormSpacer), ($($MyDMEForm.Controls[$MyDMEForm.Controls.Count - 1]).Bottom + $FormSpacer))
  
  #endregion ******** $MyDMEForm Controls ********
  
  $MyDMEReturn.DialogResult = $MyDMEForm.ShowDialog()
  [PSCustomObject]($MyDMEReturn)
  
  $MyDMEFormComponents.Dispose()
  $MyDMEForm.Dispose()
  
  Write-Verbose -Message "Exit Function Show-MyDMEditDialog"
}
#endregion function Show-MyDMEditDialog

#region function Show-MyDMIconDialog
function Show-MyDMIconDialog()
{
  <#
    .SYNOPSIS
      Function to do something specific
    .DESCRIPTION
      Function to do something specific
    .PARAMETER Value
      Value Command Line Parameter
    .INPUTS
    .OUTPUTS
    .EXAMPLE
      Show-MyDMIconDialog -Value "String"
    .NOTES
      Original Function By Ken Sweet
    .LINK
  #>
  [CmdletBinding()]
  param (
    [String]$Title = "Select Desktop Menu Icon",
    [String]$IconPath = $MyDMConfig.DefaultIconPath,
    [Int]$Index = $MyDMConfig.DefaultIconIndex,
    [System.Windows.Forms.Form]$Owner = $MyDMForm,
    [Int]$FormSpacer = $MyDMConfig.FormSpacer,
    [Object]$FontData = $MyDMConfig.FontData,
    [System.Drawing.Color]$BackColor = $MyDMColor.BackColor,
    [System.Drawing.Color]$ForeColor = $MyDMColor.ForeColor,
    [System.Drawing.Color]$LabelForeColor = $MyDMColor.LabelForeColor,
    [System.Drawing.Color]$ErrorForeColor = $MyDMColor.ErrorForeColor,
    [System.Drawing.Color]$TitleBackColor = $MyDMColor.TitleBackColor,
    [System.Drawing.Color]$TitleForeColor = $MyDMColor.TitleForeColor,
    [System.Drawing.Color]$GroupForeColor = $MyDMColor.GroupForeColor,
    [System.Drawing.Color]$TextBackColor = $MyDMColor.TextBackColor,
    [System.Drawing.Color]$TextForeColor = $MyDMColor.TextForeColor,
    [System.Drawing.Color]$ButtonBackColor = $MyDMColor.ButtonBackColor,
    [System.Drawing.Color]$ButtonForeColor = $MyDMColor.ButtonForeColor
  )
  Write-Verbose -Message "Enter Function Show-MyDMIconDialog"
  
  $MyDMIReturn = [Ordered]@{
    "DialogResult" = [System.Windows.Forms.DialogResult]::OK;
    "IconPath" = ($IconPath.Trim("`""));
    "Index" = $Index;
  }
  $MyDMIFormComponents = New-Object -TypeName System.ComponentModel.Container
  
  #region $MyDMIToolTip = System.Windows.Forms.ToolTip
  Write-Verbose -Message "Creating Form Control `$MyDMIToolTip"
  $MyDMIToolTip = New-Object -TypeName System.Windows.Forms.ToolTip($MyDMIFormComponents)
  $MyDMIToolTip.Active = $False
  #$MyDMIToolTip.AutomaticDelay = 500
  #$MyDMIToolTip.AutoPopDelay = 5000
  #$MyDMIToolTip.BackColor = [System.Drawing.SystemColors]::Info
  #$MyDMIToolTip.ForeColor = [System.Drawing.SystemColors]::InfoText
  #$MyDMIToolTip.InitialDelay = 500
  #$MyDMIToolTip.IsBalloon = $False
  #$MyDMIToolTip.OwnerDraw = $False
  #$MyDMIToolTip.ReshowDelay = 100
  #$MyDMIToolTip.ShowAlways = $False
  #$MyDMIToolTip.Site = System.ComponentModel.ISite
  #$MyDMIToolTip.StripAmpersands = $False
  #$MyDMIToolTip.Tag = $Null
  #$MyDMIToolTip.ToolTipIcon = [System.Windows.Forms.ToolTipIcon]::None
  $MyDMIToolTip.ToolTipTitle = "$($MyDMConfig.ScriptName) - $($MyDMConfig.ScriptVersion)"
  #$MyDMIToolTip.UseAnimation = $True
  #$MyDMIToolTip.UseFading = $True
  #endregion
  #$MyDMIToolTip.SetToolTip($FormControl, "Form Control Help")
  
  #region $MyDMIForm = System.Windows.Forms.Form
  Write-Verbose -Message "Creating Form Control `$MyDMIForm"
  $MyDMIForm = New-Object -TypeName System.Windows.Forms.Form
  $MyDMIForm.BackColor = $BackColor
  $MyDMIForm.DialogResult = [System.Windows.Forms.DialogResult]::None
  $MyDMIForm.Font = $FontData.Regular
  $MyDMIForm.ForeColor = $ForeColor
  $MyDMIForm.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::Fixed3D
  $MyDMIForm.KeyPreview = $True
  $MyDMIForm.MaximizeBox = $False
  $MyDMIForm.MinimizeBox = $False
  $MyDMIForm.Name = "MyDMIForm"
  $MyDMIForm.Owner = $Owner
  $MyDMIForm.ShowIcon = $False
  $MyDMIForm.ShowInTaskbar = $False
  $MyDMIForm.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterParent
  $MyDMIForm.Tag = (-not $MyDMConfig.Production)
  $MyDMIForm.Text = $Title
  #endregion
  $MyDMIToolTip.SetToolTip($MyDMIForm, "Help for Control $($MyDMIForm.Name)")
  
  #region function Start-MyDMIFormKeyDown
  function Start-MyDMIFormKeyDown()
  {
    <#
      .SYNOPSIS
        KeyDown event for the MyDMIForm Control
      .DESCRIPTION
        KeyDown event for the MyDMIForm Control
      .PARAMETER Sender
         The Form Control that fired the Event
      .PARAMETER EventArg
         The Event Arguments for the Event
      .EXAMPLE
         Start-MyDMIFormKeyDown -Sender $Sender -EventArg $EventArg
      .NOTES
        Original Function By Ken Sweet
      .LINK
    #>
    [CmdletBinding()]
    param (
      [parameter(Mandatory = $True)]
      [Object]$Sender,
      [parameter(Mandatory = $True)]
      [Object]$EventArg
    )
    Write-Verbose -Message "Enter KeyDown Event for `$MyDMIForm"
    Try
    {
      #$MyDMIForm.Cursor = [System.Windows.Forms.Cursors]::WaitCursor
      if ($EventArg.KeyCode -eq [System.Windows.Forms.Keys]::Escape)
      {
        $MyDMIForm.Close()
      }
      #$MyDMIForm.Cursor = [System.Windows.Forms.Cursors]::Arrow
      
      [System.GC]::Collect()
      [System.GC]::WaitForPendingFinalizers()
    }
    Catch
    {
      Write-Debug -Message "ErrMsg: $($Error[0].Exception.Message)"
      Write-Debug -Message "Line: $($Error[0].InvocationInfo.ScriptLineNumber)"
      Write-Debug -Message "Code: $(($Error[0].InvocationInfo.Line).Trim())"
    }
    Write-Verbose -Message "Exit KeyDown Event for `$MyDMIForm"
  }
  #endregion function Start-MyDMIFormKeyDown
  $MyDMIForm.add_KeyDown({ Start-MyDMIFormKeyDown -Sender $This -EventArg $PSItem })
  
  #region function Start-MyDMIFormShown
  function Start-MyDMIFormShown()
  {
    <#
      .SYNOPSIS
        Shown event for the MyDMIForm Control
      .DESCRIPTION
        Shown event for the MyDMIForm Control
      .PARAMETER Sender
         The Form Control that fired the Event
      .PARAMETER EventArg
         The Event Arguments for the Event
      .EXAMPLE
         Start-MyDMIFormShown -Sender $Sender -EventArg $EventArg
      .NOTES
        Original Function By Ken Sweet
      .LINK
    #>
    [CmdletBinding()]
    param (
      [parameter(Mandatory = $True)]
      [Object]$Sender,
      [parameter(Mandatory = $True)]
      [Object]$EventArg
    )
    Write-Verbose -Message "Enter Shown Event for `$MyDMIForm"
    Try
    {
      #$MyDMIForm.Cursor = [System.Windows.Forms.Cursors]::WaitCursor
      $Sender.Refresh()
      
      $MyDMIReturnIconsListView.Items.Clear()
      $MyDMIReturnImageList.Images.Clear()
      
      if ($MyDMIReturn.Index -eq -1)
      {
        $MyDMIReturn.IconPath = $MyDMConfig.DefaultIconPath
      }
      $MyDMIReturnPathTextBox.Text = $MyDMIReturn.IconPath
      $Sender.Refresh()
      
      if ([System.IO.File]::Exists($MyDMIReturn.IconPath))
      {
        $IconCount = [Extract.MyIcon]::IconCount($MyDMIReturn.IconPath)
        For ($Count = 0; $Count -lt $IconCount; $Count++)
        {
          $MyDMIReturnImageList.Images.Add(([Extract.MyIcon]::IconReturn($MyDMIReturn.IconPath, $Count, $True)))
          [Void]($MyDMIReturnIconsListView.Items.Add("$("{0:###00}" -f $Count)", $Count))
        }
        
        if ($MyDMIReturn.Index -gt -1)
        {
          $MyDMIReturnIconsListView.Items[$MyDMIReturn.Index].Selected = $True
          $MyDMIReturnIconsListView.Select()
          $MyDMIReturnIconsListView.Items[$MyDMIReturn.Index].EnsureVisible()
        }
      }
      
      #$MyDMIForm.Cursor = [System.Windows.Forms.Cursors]::Arrow
      
      [System.GC]::Collect()
      [System.GC]::WaitForPendingFinalizers()
    }
    Catch
    {
      Write-Debug -Message "ErrMsg: $($Error[0].Exception.Message)"
      Write-Debug -Message "Line: $($Error[0].InvocationInfo.ScriptLineNumber)"
      Write-Debug -Message "Code: $(($Error[0].InvocationInfo.Line).Trim())"
    }
    Write-Verbose -Message "Exit Shown Event for `$MyDMIForm"
  }
  #endregion function Start-MyDMIFormShown
  $MyDMIForm.add_Shown({ Start-MyDMIFormShown -Sender $This -EventArg $PSItem })
  
  #region ******** $MyDMIForm Controls ********
  
  #region $MyDMIReturnGroupBox = System.Windows.Forms.GroupBox
  Write-Verbose -Message "Creating Form Control `$MyDMIReturnGroupBox"
  $MyDMIReturnGroupBox = New-Object -TypeName System.Windows.Forms.GroupBox
  # Location of First Control New-Object -TypeName System.Drawing.Point($FormSpacer, $FontHeight)
  $MyDMIForm.Controls.Add($MyDMIReturnGroupBox)
  $MyDMIReturnGroupBox.Font = $FontData.Regular
  $MyDMIReturnGroupBox.ForeColor = $GroupForeColor
  $MyDMIReturnGroupBox.Location = New-Object -TypeName System.Drawing.Point($FormSpacer, $FormSpacer)
  $MyDMIReturnGroupBox.Name = "MyDMIReturnGroupBox"
  $MyDMIReturnGroupBox.Text = $Title
  #endregion
  
  #region ******** $MyDMIReturnGroupBox Controls ********
  
  #region $MyDMIReturnImageList = System.Windows.Forms.ImageList
  Write-Verbose -Message "Creating Form Control `$MyDMIReturnImageList"
  $MyDMIReturnImageList = New-Object -TypeName System.Windows.Forms.ImageList($MyDMIFormComponents)
  $MyDMIReturnImageList.ColorDepth = [System.Windows.Forms.ColorDepth]::Depth32Bit
  $MyDMIReturnImageList.ImageSize = New-Object -TypeName System.Drawing.Size(32, 32)
  #endregion
  
  #region $MyDMIReturnOpenFileDialog = System.Windows.Forms.OpenFileDialog
  Write-Verbose -Message "Creating Form Control `$MyDMIReturnOpenFileDialog"
  $MyDMIReturnOpenFileDialog = New-Object -TypeName System.Windows.Forms.OpenFileDialog
  $MyDMIReturnOpenFileDialog.FileName = $MyDMIReturn.IconPath
  $MyDMIReturnOpenFileDialog.Filter = "All Icon Files|*.ico;*.exe;*.dll|Icon Files|*.ico|EXE Files|*.exe|DLL Files|*.dll|All Files|*.*"
  if ($MyDMIReturn.Index -ne -1)
  {
    if ([System.IO.File]::Exists($MyDMIReturn.IconPath))
    {
      $MyDMIReturnOpenFileDialog.InitialDirectory = [System.IO.Path]::GetDirectoryName($MyDMIReturn.IconPath)
    }
    else
    {
      $MyDMIReturnOpenFileDialog.InitialDirectory = [Environment]::SystemDirectory
    }
  }
  $MyDMIReturnOpenFileDialog.Multiselect = $False
  $MyDMIReturnOpenFileDialog.ShowHelp = $False
  $MyDMIReturnOpenFileDialog.Title = "Open Icon File"
  #endregion
  
  #region $MyDMIReturnPathTextBox = System.Windows.Forms.TextBox
  Write-Verbose -Message "Creating Form Control `$MyDMIReturnPathTextBox"
  $MyDMIReturnPathTextBox = New-Object -TypeName System.Windows.Forms.TextBox
  $MyDMIReturnGroupBox.Controls.Add($MyDMIReturnPathTextBox)
  $MyDMIReturnPathTextBox.BackColor = $TextBackColor
  $MyDMIReturnPathTextBox.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
  $MyDMIReturnPathTextBox.Font = $FontData.Regular
  $MyDMIReturnPathTextBox.ForeColor = $TextForeColor
  $MyDMIReturnPathTextBox.Height = $MyDMIReturnLabel.Height
  $MyDMIReturnPathTextBox.Location = New-Object -TypeName System.Drawing.Point($FormSpacer, $FontData.Height)
  $MyDMIReturnPathTextBox.Name = "MyDMIReturnPathTextBox"
  $MyDMIReturnPathTextBox.ReadOnly = $True
  $MyDMIReturnPathTextBox.TabIndex = 0
  $MyDMIReturnPathTextBox.TabStop = $True
  $MyDMIReturnPathTextBox.Text = ""
  $MyDMIReturnPathTextBox.TextAlign = [System.Windows.Forms.HorizontalAlignment]::Left
  $MyDMIReturnPathTextBox.Width = $FontData.Width * 50
  #endregion
  $MyDMIToolTip.SetToolTip($MyDMIReturnPathTextBox, "Help for Control $($MyDMIReturnPathTextBox.Name)")
  
  #region $MyDMIReturnBrowseButton = System.Windows.Forms.Button
  Write-Verbose -Message "Creating Form Control `$MyDMIReturnBrowseButton"
  $MyDMIReturnBrowseButton = New-Object -TypeName System.Windows.Forms.Button
  $MyDMIReturnGroupBox.Controls.Add($MyDMIReturnBrowseButton)
  $MyDMIReturnBrowseButton.BackColor = $ButtonBackColor
  $MyDMIReturnBrowseButton.Font = $FontData.Bold
  $MyDMIReturnBrowseButton.ForeColor = $ButtonForeColor
  $MyDMIReturnBrowseButton.Height = $MyDMIReturnPathTextBox.Height
  $MyDMIReturnBrowseButton.Location = New-Object -TypeName System.Drawing.Point(($MyDMIReturnPathTextBox.Right + $FormSpacer), $MyDMIReturnPathTextBox.Top)
  $MyDMIReturnBrowseButton.Name = "MyDMIReturnBrowseButton"
  $MyDMIReturnBrowseButton.TabIndex = 4
  $MyDMIReturnBrowseButton.TabStop = $True
  $MyDMIReturnBrowseButton.Text = "Browse..."
  $MyDMIReturnBrowseButton.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
  $MyDMIReturnBrowseButton.Width = $MyDMIReturnBrowseButton.PreferredSize.Width
  #endregion
  $MyDMIToolTip.SetToolTip($MyDMIReturnBrowseButton, "Help for Control $($MyDMIReturnBrowseButton.Name)")
  
  #region function Start-MyDMIReturnBrowseButtonClick
  function Start-MyDMIReturnBrowseButtonClick()
  {
    <#
      .SYNOPSIS
        Click event for the MyDMIReturnBrowseButton Control
      .DESCRIPTION
        Click event for the MyDMIReturnBrowseButton Control
      .PARAMETER Sender
         The Form Control that fired the Event
      .PARAMETER EventArg
         The Event Arguments for the Event
      .EXAMPLE
         Start-MyDMIReturnBrowseButtonClick -Sender $Sender -EventArg $EventArg
      .NOTES
        Original Function By Ken Sweet
      .LINK
    #>
    [CmdletBinding()]
    param (
      [parameter(Mandatory = $True)]
      [Object]$Sender,
      [parameter(Mandatory = $True)]
      [Object]$EventArg
    )
    Write-Verbose -Message "Enter Click Event for `$MyDMIReturnBrowseButton"
    Try
    {
      #$MyDMIForm.Cursor = [System.Windows.Forms.Cursors]::WaitCursor
      
      $MyDMIReturnOpenFileDialog.FileName = $MyDMIReturnPathTextBox.Text
      if ($MyDMIReturnOpenFileDialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK)
      {
        $MyDMIReturnIconsListView.Items.Clear()
        $MyDMIReturnImageList.Images.Clear()
        
        if ([System.IO.File]::Exists($MyDMIReturnOpenFileDialog.FileName))
        {
          $IconCount = [Extract.MyIcon]::IconCount($MyDMIReturnOpenFileDialog.FileName)
          $MyDMIReturnIconsListView.BeginUpdate()
          For ($Count = 0; $Count -lt $IconCount; $Count++)
          {
            $MyDMIReturnImageList.Images.Add(([Extract.MyIcon]::IconReturn($MyDMIReturnOpenFileDialog.FileName, $Count, $True)))
            $MyDMIReturnIconsListView.Items.Add("$("{0:###00}" -f $Count)", $Count)
          }
          $MyDMIReturnIconsListView.EndUpdate()
          $MyDMIReturnPathTextBox.Text = $MyDMIReturnOpenFileDialog.FileName
        }
        
      }
      
      #$MyDMIForm.Cursor = [System.Windows.Forms.Cursors]::Arrow
      
      [System.GC]::Collect()
      [System.GC]::WaitForPendingFinalizers()
    }
    Catch
    {
      Write-Debug -Message "ErrMsg: $($Error[0].Exception.Message)"
      Write-Debug -Message "Line: $($Error[0].InvocationInfo.ScriptLineNumber)"
      Write-Debug -Message "Code: $(($Error[0].InvocationInfo.Line).Trim())"
    }
    Write-Verbose -Message "Exit Click Event for `$MyDMIReturnBrowseButton"
  }
  #endregion function Start-MyDMIReturnBrowseButtonClick
  $MyDMIReturnBrowseButton.add_Click({ Start-MyDMIReturnBrowseButtonClick -Sender $This -EventArg $PSItem })
  
  #region $MyDMIReturnIconsListView = System.Windows.Forms.ListView
  Write-Verbose -Message "Creating Form Control `$MyDMIReturnIconsListView"
  $MyDMIReturnIconsListView = New-Object -TypeName System.Windows.Forms.ListView
  $MyDMIReturnGroupBox.Controls.Add($MyDMIReturnIconsListView)
  $MyDMIReturnIconsListView.BackColor = $TextBackColor
  $MyDMIReturnIconsListView.Font = $FontData.Bold
  $MyDMIReturnIconsListView.ForeColor = $TextForeColor
  $MyDMIReturnIconsListView.HideSelection = $False
  $MyDMIReturnIconsListView.LargeImageList = $MyDMIReturnImageList
  $MyDMIReturnIconsListView.Location = New-Object -TypeName System.Drawing.Point($FormSpacer, ($MyDMIReturnPathTextBox.Bottom + $FormSpacer))
  $MyDMIReturnIconsListView.MultiSelect = $False
  $MyDMIReturnIconsListView.Name = "MyDMIReturnIconsListView"
  $MyDMIReturnIconsListView.ShowGroups = $False
  $MyDMIReturnIconsListView.Size = New-Object -TypeName System.Drawing.Size(($MyDMIReturnBrowseButton.Right - $MyDMIReturnIconsListView.Left), ($FontData.Height * 16))
  $MyDMIReturnIconsListView.Text = "MyDMIReturnIconsListView"
  $MyDMIReturnIconsListView.TileSize = New-Object -TypeName System.Drawing.Size(32, 32)
  $MyDMIReturnIconsListView.View = [System.Windows.Forms.View]::LargeIcon
  #endregion
 
  $MyDMIReturnGroupBox.ClientSize = New-Object -TypeName System.Drawing.Size(($MyDMIReturnIconsListView.Right + $FormSpacer), ($MyDMIReturnIconsListView.Bottom + $FormSpacer))
  
  #endregion ******** $MyDMIReturnGroupBox Controls ********
  
  #region $MyDMIOKButton = System.Windows.Forms.Button
  Write-Verbose -Message "Creating Form Control `$MyDMIOKButton"
  $MyDMIOKButton = New-Object -TypeName System.Windows.Forms.Button
  $MyDMIForm.Controls.Add($MyDMIOKButton)
  # Evenly Space Buttons - Move Size to after Text
  $NumButtons = 2
  $TempSpace = [Math]::Floor($MyDMIReturnGroupBox.Width - ($FormSpacer * ($NumButtons + 2)))
  $TempWidth = [Math]::Floor($TempSpace / $NumButtons)
  $TempMod = $TempSpace % $NumButtons
  $MyDMIOKButton.AutoSize = $True
  $MyDMIOKButton.BackColor = $ButtonBackColor
  $MyDMIOKButton.Font = $FontData.Bold
  $MyDMIOKButton.ForeColor = $ButtonForeColor
  $MyDMIOKButton.Location = New-Object -TypeName System.Drawing.Point(($FormSpacer * 2), ($MyDMIReturnGroupBox.Bottom + ($FormSpacer * 2)))
  $MyDMIOKButton.Name = "MyDMIOKButton"
  $MyDMIOKButton.TabIndex = 4
  $MyDMIOKButton.TabStop = $True
  $MyDMIOKButton.Text = "OK"
  $MyDMIOKButton.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
  $MyDMIOKButton.Width = $TempWidth
  #endregion
  $MyDMIToolTip.SetToolTip($MyDMIOKButton, "Help for Control $($MyDMIOKButton.Name)")
  
  #region function Start-MyDMIOKButtonClick
  function Start-MyDMIOKButtonClick()
  {
    <#
      .SYNOPSIS
        Click event for the MyDMIOKButton Control
      .DESCRIPTION
        Click event for the MyDMIOKButton Control
      .PARAMETER Sender
         The Form Control that fired the Event
      .PARAMETER EventArg
         The Event Arguments for the Event
      .EXAMPLE
         Start-MyDMIOKButtonClick -Sender $Sender -EventArg $EventArg
      .NOTES
        Original Function By Ken Sweet
      .LINK
    #>
    [CmdletBinding()]
    param (
      [parameter(Mandatory = $True)]
      [Object]$Sender,
      [parameter(Mandatory = $True)]
      [Object]$EventArg
    )
    Write-Verbose -Message "Enter Click Event for `$MyDMIOKButton"
    Try
    {
      #$MyDMIForm.Cursor = [System.Windows.Forms.Cursors]::WaitCursor
      
      $NoError = $True
      
      if ($MyDMIReturnIconsListView.SelectedIndices.Count -ne 1)
      {
        $NoError = $False
      }
      
      if ($NoError)
      {
        $MyDMIReturn.IconPath = $MyDMIReturnPathTextBox.Text
        $MyDMIReturn.Index = $MyDMIReturnIconsListView.SelectedIndices[0]
        
        $MyDMIForm.DialogResult = [System.Windows.Forms.DialogResult]::OK
        $MyDMIForm.Close()
      }
      else
      {
        [Void]([System.Windows.Forms.MessageBox]::Show($MyDMIForm, "Error with Selected $TitleName Values.", "Error: $TitleName", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error))
      }
      #$MyDMIForm.Cursor = [System.Windows.Forms.Cursors]::Arrow
      
      [System.GC]::Collect()
      [System.GC]::WaitForPendingFinalizers()
    }
    Catch
    {
      Write-Debug -Message "ErrMsg: $($Error[0].Exception.Message)"
      Write-Debug -Message "Line: $($Error[0].InvocationInfo.ScriptLineNumber)"
      Write-Debug -Message "Code: $(($Error[0].InvocationInfo.Line).Trim())"
    }
    Write-Verbose -Message "Exit Click Event for `$MyDMIOKButton"
  }
  #endregion function Start-MyDMIOKButtonClick
  $MyDMIOKButton.add_Click({ Start-MyDMIOKButtonClick -Sender $This -EventArg $PSItem })
  
  #region $MyDMICancelButton = System.Windows.Forms.Button
  Write-Verbose -Message "Creating Form Control `$MyDMICancelButton"
  $MyDMICancelButton = New-Object -TypeName System.Windows.Forms.Button
  $MyDMIForm.Controls.Add($MyDMICancelButton)
  $MyDMICancelButton.AutoSize = $True
  $MyDMICancelButton.BackColor = $ButtonBackColor
  $MyDMICancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
  $MyDMICancelButton.Font = $FontData.Bold
  $MyDMICancelButton.ForeColor = $ButtonForeColor
  $MyDMICancelButton.Location = New-Object -TypeName System.Drawing.Point(($MyDMIOKButton.Right + $TempMod + ($FormSpacer * 2)), $MyDMIOKButton.Top)
  $MyDMICancelButton.Name = "MyDMICancelButton"
  $MyDMICancelButton.TabIndex = 5
  $MyDMICancelButton.TabStop = $True
  $MyDMICancelButton.Text = "Cancel"
  $MyDMICancelButton.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
  $MyDMICancelButton.Width = $TempWidth
  #endregion
  $MyDMIToolTip.SetToolTip($MyDMICancelButton, "Help for Control $($MyDMICancelButton.Name)")
  
  $MyDMIForm.ClientSize = New-Object -TypeName System.Drawing.Size(($MyDMIReturnGroupBox.Right + $FormSpacer), ($($MyDMIForm.Controls[$MyDMIForm.Controls.Count - 1]).Bottom + $FormSpacer))
  
  #endregion ******** $MyDMIForm Controls ********
  
  $MyDMIReturn.DialogResult = $MyDMIForm.ShowDialog()
  [PSCustomObject]($MyDMIReturn)
  
  $MyDMIFormComponents.Dispose()
  $MyDMIForm.Dispose()
  
  Write-Verbose -Message "Exit Function Show-MyDMIconDialog"
}
#endregion function Show-MyDMIconDialog

#region function Show-MyDMHelpDialog
function Show-MyDMHelpDialog()
{
  <#
    .SYNOPSIS
      Function to do something specific
    .DESCRIPTION
      Function to do something specific
    .PARAMETER Value
      Value Command Line Parameter
    .INPUTS
    .OUTPUTS
    .EXAMPLE
      Show-MyDMHelpDialog -Value "String"
    .NOTES
      Original Function By Ken Sweet
    .LINK
  #>
  [CmdletBinding()]
  param (
    [String]$Title = "Edit-MyDesktopMenus Help",
    [System.Windows.Forms.Form]$Owner = $MyDMForm,
    [Int]$FormSpacer = $MyDMConfig.FormSpacer,
    [Object]$FontData = $MyDMConfig.FontData,
    [System.Drawing.Color]$BackColor = $MyDMColor.BackColor,
    [System.Drawing.Color]$ForeColor = $MyDMColor.ForeColor,
    [System.Drawing.Color]$LabelForeColor = $MyDMColor.LabelForeColor,
    [System.Drawing.Color]$ErrorForeColor = $MyDMColor.ErrorForeColor,
    [System.Drawing.Color]$TitleBackColor = $MyDMColor.TitleBackColor,
    [System.Drawing.Color]$TitleForeColor = $MyDMColor.TitleForeColor,
    [System.Drawing.Color]$GroupForeColor = $MyDMColor.GroupForeColor,
    [System.Drawing.Color]$TextBackColor = $MyDMColor.TextBackColor,
    [System.Drawing.Color]$TextForeColor = $MyDMColor.TextForeColor,
    [System.Drawing.Color]$ButtonBackColor = $MyDMColor.ButtonBackColor,
    [System.Drawing.Color]$ButtonForeColor = $MyDMColor.ButtonForeColor
  )
  Write-Verbose -Message "Enter Function Show-MyDMHelpDialog"
  $MyDMHFormComponents = New-Object -TypeName System.ComponentModel.Container

  #region $MyDMHToolTip = System.Windows.Forms.ToolTip
  Write-Verbose -Message "Creating Form Control `$MyDMHToolTip"
  $MyDMHToolTip = New-Object -TypeName System.Windows.Forms.ToolTip($MyDMHFormComponents)
  $MyDMHToolTip.Active = $False
  #$MyDMHToolTip.AutomaticDelay = 500
  #$MyDMHToolTip.AutoPopDelay = 5000
  #$MyDMHToolTip.BackColor = [System.Drawing.SystemColors]::Info
  #$MyDMHToolTip.ForeColor = [System.Drawing.SystemColors]::InfoText
  #$MyDMHToolTip.InitialDelay = 500
  #$MyDMHToolTip.IsBalloon = $False
  #$MyDMHToolTip.OwnerDraw = $False
  #$MyDMHToolTip.ReshowDelay = 100
  #$MyDMHToolTip.ShowAlways = $False
  #$MyDMHToolTip.Site = System.ComponentModel.ISite
  #$MyDMHToolTip.StripAmpersands = $False
  #$MyDMHToolTip.Tag = $Null
  #$MyDMHToolTip.ToolTipIcon = [System.Windows.Forms.ToolTipIcon]::None
  $MyDMHToolTip.ToolTipTitle = $Title
  #$MyDMHToolTip.UseAnimation = $True
  #$MyDMHToolTip.UseFading = $True
  #endregion
  #$MyDMHToolTip.SetToolTip($FormControl, "Form Control Help")

  #region $MyDMHForm = System.Windows.Forms.Form
  Write-Verbose -Message "Creating Form Control `$MyDMHForm"
  $MyDMHForm = New-Object -TypeName System.Windows.Forms.Form
  $MyDMHForm.BackColor = $BackColor
  $MyDMHForm.Font = $FontData.Regular
  $MyDMHForm.ForeColor = $ForeColor
  $MyDMHForm.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::Sizable
  $MyDMHForm.Icon = $Owner.Icon
  $MyDMHForm.MinimumSize = $Owner.MinimumSize
  $MyDMHForm.Name = "MyDMHForm"
  $MyDMHForm.Owner = $Owner
  $MyDMHForm.ShowInTaskbar = $False
  $MyDMHForm.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterParent
  $MyDMHForm.Text = $Title
  #endregion
  $MyDMHToolTip.SetToolTip($MyDMHForm, "Help for Control $($MyDMHForm.Name)")

  #region function Start-MyDMHFormShown
  function Start-MyDMHFormShown()
  {
    <#
      .SYNOPSIS
        Shown event for the MyDMHForm Control
      .DESCRIPTION
        Shown event for the MyDMHForm Control
      .PARAMETER Sender
         The Form Control that fired the Event
      .PARAMETER EventArg
         The Event Arguments for the Event
      .EXAMPLE
         Start-MyDMHFormShown -Sender $Sender -EventArg $EventArg
      .NOTES
        Original Function By Ken Sweet
      .LINK
    #>
    [CmdletBinding()]
    param (
      [parameter(Mandatory = $True)]
      [Object]$Sender,
      [parameter(Mandatory = $True)]
      [Object]$EventArg
    )
    Write-Verbose -Message "Enter Shown Event for `$MyDMHForm"
    Try
    {
      #$MyDMHForm.Cursor = [System.Windows.Forms.Cursors]::WaitCursor
      $Sender.Refresh()
      $MyDMHRichTextBox.Tag = "Introduction"
      $MyDMHRichTextBox.Rtf = (Decompress-MyData -Data $Introductionrtf -AsString)
      #$MyDMHForm.Cursor = [System.Windows.Forms.Cursors]::Arrow

      [System.GC]::Collect()
      [System.GC]::WaitForPendingFinalizers()
    }
    Catch
    {
      Write-Debug -Message "ErrMsg: $($Error[0].Exception.Message)"
      Write-Debug -Message "Line: $($Error[0].InvocationInfo.ScriptLineNumber)"
      Write-Debug -Message "Code: $(($Error[0].InvocationInfo.Line).Trim())"
    }
    Write-Verbose -Message "Exit Shown Event for `$MyDMHForm"
  }
  #endregion function Start-MyDMHFormShown
  $MyDMHForm.add_Shown({Start-MyDMHFormShown -Sender $This -EventArg $PSItem})

  #region ******** $MyDMHForm Controls ********

  #region $MyDMHRichTextBox = System.Windows.Forms.RichTextBox
  Write-Verbose -Message "Creating Form Control `$MyDMHRichTextBox"
  $MyDMHRichTextBox = New-Object -TypeName System.Windows.Forms.RichTextBox
  $MyDMHForm.Controls.Add($MyDMHRichTextBox)
  #$MyDMHRichTextBox.Anchor = [System.Windows.Forms.AnchorStyles]("Top", "Left", "Bottom", "Right")
  $MyDMHRichTextBox.BackColor = $TextBackColor
  #$MyDMHRichTextBox.BorderStyle = [System.Windows.Forms.BorderStyle]::Fixed3D
  $MyDMHRichTextBox.Dock = [System.Windows.Forms.DockStyle]::Fill
  $MyDMHRichTextBox.Font = $FontData.Regular
  $MyDMHRichTextBox.ForeColor = $TextForeColor
  #$MyDMHRichTextBox.Location = New-Object -TypeName System.Drawing.Point($FormSpacer, $FormSpacer)
  $MyDMHRichTextBox.Name = "MyDMHRichTextBox"
  $MyDMHRichTextBox.ReadOnly = $True
  $MyDMHRichTextBox.Rtf = ""
  $MyDMHRichTextBox.SelectionFont = $FontData.Regular
  $MyDMHRichTextBox.Text = ""
  #endregion
  $MyDMHToolTip.SetToolTip($MyDMHRichTextBox, "Help for Control $($MyDMHRichTextBox.Name)")

  #region $MyDMHMenuStrip = System.Windows.Forms.MenuStrip
  Write-Verbose -Message "Creating Form Control `$MyDMHMenuStrip"
  $MyDMHMenuStrip = New-Object -TypeName System.Windows.Forms.MenuStrip
  $MyDMHForm.Controls.Add($MyDMHMenuStrip)
  $MyDMHForm.MainMenuStrip = $MyDMHMenuStrip
  $MyDMHMenuStrip.BackColor = $BackColor
  $MyDMHMenuStrip.Dock = [System.Windows.Forms.DockStyle]::Left
  $MyDMHMenuStrip.Font = $FontData.Regular
  $MyDMHMenuStrip.ForeColor = $ForeColor
  $MyDMHMenuStrip.Location = New-Object -TypeName System.Drawing.Point($FormSpacer, $FormSpacer)
  $MyDMHMenuStrip.Name = "MyDMHMenuStrip"
  $MyDMHMenuStrip.Text = "MyDMHMenuStrip"
  $MyDMHMenuStrip.TextDirection = [System.Windows.Forms.ToolStripTextDirection]::Horizontal
  #endregion

  #region ******** $MyDMHMenuStrip MenuStrip MenuItems ********

  #region function Start-MyDMHToolStripButtonClick
  function Start-MyDMHToolStripButtonClick()
  {
    <#
      .SYNOPSIS
        Click event for the MyDMHToolStripButton Control
      .DESCRIPTION
        Click event for the MyDMHToolStripButton Control
      .PARAMETER Sender
         The Form Control that fired the Event
      .PARAMETER EventArg
         The Event Arguments for the Event
      .EXAMPLE
         Start-MyDMHToolStripButtonClick -Sender $Sender -EventArg $EventArg
      .NOTES
        Original Function By Ken Sweet
      .LINK
    #>
    [CmdletBinding()]
    param (
      [parameter(Mandatory = $True)]
      [Object]$Sender,
      [parameter(Mandatory = $True)]
      [Object]$EventArg
    )
    Write-Verbose -Message "Enter Click Event for `$MyDMHToolStripButton"
    Try
    {
      #$MyDMHForm.Cursor = [System.Windows.Forms.Cursors]::WaitCursor
      if ($MyDMHRichTextBox.Tag -ne $Sender.Name)
      {
        Switch ($Sender.Name)
        {
          "Introduction"
          {
            $MyDMHRichTextBox.Rtf = (Decompress-MyData -Data $Introductionrtf -AsString)
            Break
          }
          "Menu"
          {
            $MyDMHRichTextBox.Rtf = (Decompress-MyData -Data $DesktopMenurtf -AsString)
            Break
          }
          "AEMenu"
          {
            $MyDMHRichTextBox.Rtf = (Decompress-MyData -Data $AEDesktopMenurtf -AsString)
            Break
          }
          "Command"
          {
            $MyDMHRichTextBox.Rtf = (Decompress-MyData -Data $MenuCommandsrtf -AsString)
            Break
          }
          "AECommand"
          {
            $MyDMHRichTextBox.Rtf = (Decompress-MyData -Data $AEMenuCommandsrtf -AsString)
            Break
          }
          "Close"
          {
            $MyDMHForm.Close()
            Break
          }
        }
        $MyDMHRichTextBox.Tag = $Sender.Name
      }
      #$MyDMHForm.Cursor = [System.Windows.Forms.Cursors]::Arrow

      [System.GC]::Collect()
      [System.GC]::WaitForPendingFinalizers()
    }
    Catch
    {
      Write-Debug -Message "ErrMsg: $($Error[0].Exception.Message)"
      Write-Debug -Message "Line: $($Error[0].InvocationInfo.ScriptLineNumber)"
      Write-Debug -Message "Code: $(($Error[0].InvocationInfo.Line).Trim())"
    }
    Write-Verbose -Message "Exit Click Event for `$MyDMHToolStripButton"
  }
  #endregion function Start-MyDMHToolStripButtonClick

  New-MenuSeparator -Menu $MyDMHMenuStrip
  New-MenuLabel -Menu $MyDMHMenuStrip -Text "Help Menu" -FontStyle "Bold" -ForeColor "Yellow"
  New-MenuSeparator -Menu $MyDMHMenuStrip
  (New-MenuItem -Menu $MyDMHMenuStrip -Name "Introduction" -Text "Introduction" -Tag "Introduction" -Alignment "MiddleLeft" -DisplayStyle "ImageAndText" -Icon ([System.Drawing.Icon]([System.Convert]::FromBase64String($MyDMFormICO))) -PassThru).add_Click({Start-MyDMHToolStripButtonClick -Sender $This -EventArg $PSItem})
  (New-MenuItem -Menu $MyDMHMenuStrip -Name "Menu" -Text "Desktop Menus" -Tag "Menu" -Alignment "MiddleLeft" -DisplayStyle "ImageAndText" -Icon ([System.Drawing.Icon]([System.Convert]::FromBase64String($Newico))) -PassThru).add_Click({Start-MyDMHToolStripButtonClick -Sender $This -EventArg $PSItem})
  (New-MenuItem -Menu $MyDMHMenuStrip -Name "AEMenu" -Text "Add / Edit Menus" -Tag "AEMenu" -Alignment "MiddleLeft" -DisplayStyle "ImageAndText" -Icon ([System.Drawing.Icon]([System.Convert]::FromBase64String($Editico))) -PassThru).add_Click({Start-MyDMHToolStripButtonClick -Sender $This -EventArg $PSItem})
  (New-MenuItem -Menu $MyDMHMenuStrip -Name "Command" -Text "Menu Commands" -Tag "Command" -Alignment "MiddleLeft" -DisplayStyle "ImageAndText" -Icon ([System.Drawing.Icon]([System.Convert]::FromBase64String($Commandico))) -PassThru).add_Click({Start-MyDMHToolStripButtonClick -Sender $This -EventArg $PSItem})
  (New-MenuItem -Menu $MyDMHMenuStrip -Name "AECommand" -Text "Add / Edit Commands" -Tag "AECommand" -Alignment "MiddleLeft" -DisplayStyle "ImageAndText" -Icon ([System.Drawing.Icon]([System.Convert]::FromBase64String($Editico))) -PassThru).add_Click({Start-MyDMHToolStripButtonClick -Sender $This -EventArg $PSItem})
  New-MenuSeparator -Menu $MyDMHMenuStrip
  (New-MenuItem -Menu $MyDMHMenuStrip -Name "Close" -Text "Close Help" -Tag "Close" -Alignment "MiddleLeft" -DisplayStyle "ImageAndText" -Icon ([System.Drawing.Icon]([System.Convert]::FromBase64String($Exitico))) -PassThru).add_Click({Start-MyDMHToolStripButtonClick -Sender $This -EventArg $PSItem})
  New-MenuSeparator -Menu $MyDMHMenuStrip

  #endregion ******** $MyDMHMenuStrip MenuStrip MenuItems ********

  #region $MyDMHTopPanel = System.Windows.Forms.Panel
  Write-Verbose -Message "Creating Form Control `$MyDMHTopPanel"
  $MyDMHTopPanel = New-Object -TypeName System.Windows.Forms.Panel
  $MyDMHForm.Controls.Add($MyDMHTopPanel)
  $MyDMHTopPanel.BackColor = $BackColor
  $MyDMHTopPanel.Dock = [System.Windows.Forms.DockStyle]::Top
  $MyDMHTopPanel.ForeColor = $ForeColor
  $MyDMHTopPanel.Name = "MyDMHTopPanel"
  $MyDMHTopPanel.Text = "MyDMHTopPanel"
  #endregion

  #region ******** $MyDMHTopPanel Controls ********

  #region $MyDMHTopLabel = System.Windows.Forms.Label
  Write-Verbose -Message "Creating Form Control `$MyDMHTopLabel"
  $MyDMHTopLabel = New-Object -TypeName System.Windows.Forms.Label
  $MyDMHTopPanel.Controls.Add($MyDMHTopLabel)
  $MyDMHTopLabel.BackColor = $TitleBackColor
  $MyDMHTopLabel.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
  $MyDMHTopLabel.Font = New-Object -TypeName System.Drawing.Font($MyDMConfig.FontFamily, ($MyDMConfig.FontSize * 1.5), [System.Drawing.FontStyle]::Bold, [System.Drawing.GraphicsUnit]::Point)
  $MyDMHTopLabel.ForeColor = $TitleForeColor
  $MyDMHTopLabel.Location = New-Object -TypeName System.Drawing.Point($FormSpacer, $FormSpacer)
  $MyDMHTopLabel.Name = "MyDMHTopLabel"
  $MyDMHTopLabel.Text = $Title
  $MyDMHTopLabel.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
  #endregion
  $MyDMHTopLabel.Size = New-Object -TypeName System.Drawing.Size(($MyDMHTopPanel.ClientSize.Width - ($FormSpacer * 2)), $MyDMHTopLabel.PreferredHeight)
    
  $MyDMHTopPanel.ClientSize = New-Object -TypeName System.Drawing.Size(($($MyDMHTopPanel.Controls[$MyDMHTopPanel.Controls.Count - 1]).Right + $FormSpacer), ($($MyDMHTopPanel.Controls[$MyDMHTopPanel.Controls.Count - 1]).Bottom + $FormSpacer))

  $MyDMHTopLabel.Anchor = [System.Windows.Forms.AnchorStyles]("Top", "Left", "Bottom", "Right")

  #endregion ******** $MyDMHTopPanel Controls ********

  #$MyDMHForm.ClientSize = New-Object -TypeName System.Drawing.Size(($($MyDMHForm.Controls[$MyDMHForm.Controls.Count - 1]).Right + $FormSpacer), ($($MyDMHForm.Controls[$MyDMHForm.Controls.Count - 1]).Bottom + $FormSpacer))

  #endregion ******** $MyDMHForm Controls ********
  Write-Verbose -Message "Exit Function Show-MyDMHelpDialog"
  
  [Void]$MyDMHForm.ShowDialog()
  
  $MyDMHFormComponents.Dispose()
  $MyDMHForm.Dispose()
  
}
#endregion function Show-MyDMHelpDialog

#region function New-MyDMMenuCommand
function New-MyDMMenuCommand()
{
  <#
    .SYNOPSIS
      Function to do something specific
    .DESCRIPTION
      Function to do something specific
    .PARAMETER Value
      Value Command Line Parameter
    .INPUTS
    .OUTPUTS
    .EXAMPLE
      New-MyDMMenuCommand -Value "String"
    .NOTES
      Original Function By Ken Sweet
    .LINK
  #>
  [CmdletBinding()]
  param (
  )
  Write-Verbose -Message "Enter Function New-MyDMMenuCommand"
  Try
  {
    $MyDMStatusStrip.Items["Status"].Text = "Add New Desktop Menu Command..."
    
    $BadNames = [System.Collections.ArrayList]::New()
    $BadNames.AddRange(@($MyDMMidCmdsListView.Items | Select-Object -ExpandProperty Text))
    
    if ((($Data = Show-MyDMEditDialog -BadNames $BadNames -IconPath "" -Index -1)).DialogResult -eq [System.Windows.Forms.DialogResult]::OK)
    {
      $TempCommandFlags = 0x0
      if ($Data.SeparatorBefore)
      {
        $TempCommandFlags = $TempCommandFlags -bor $MyDMConfig.SeparatorBefore
        $SeparatorBefore = $MyDMConfig.SeparatorYes
      }
      else
      {
        $SeparatorBefore = $MyDMConfig.SeparatorNo
      }
      
      if ($Data.SeparatorAfter)
      {
        $TempCommandFlags = $TempCommandFlags -bor $MyDMConfig.SeparatorAfter
        $SeparatorAfter = $MyDMConfig.SeparatorYes
      }
      else
      {
        $SeparatorAfter = $MyDMConfig.SeparatorNo
      }
      
      $NewCmd = [MyMenuCommand]::New($Data.ReturnVal01Text, $Data.ReturnVal02Text, $TempCommandFlags, $Data.IconPath, $Data.Index)
      
      if ($MyDMConfig.EditRegistry)
      {
        if ($MyDMMidMenuTreeView.SelectedNode.Level -eq 2)
        {
          # ***********************************
          #  Write New Desktop Sub Menu Command
          # ***********************************
          $TempHive = $MyDMMidMenuTreeView.SelectedNode.Parent.Parent.Tag
          $TempMenuID = $MyDMMidMenuTreeView.SelectedNode.Parent.Tag.ID
          
          $TempSubCommandName = ($MyDMConfig.PrefixSubCommand -f $TempMenuID, $MyDMMidMenuTreeView.SelectedNode.Tag.ID, $MyDMMidCmdsListView.Items.Count)
          
          $CheckValue = 0
          $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.CreateKey($TempHive, $MyDMConfig.RegistrySubMenuCmds, $TempSubCommandName)).Failure
          $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.CreateKey($TempHive, "$($MyDMConfig.RegistrySubMenuCmds)\$TempSubCommandName", "Command")).Failure
          if ($Data.Index -ne -1)
          {
            $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetStringValue($TempHive, "$($MyDMConfig.RegistrySubMenuCmds)\$TempSubCommandName", "Icon", "$($Data.IconPath),$($Data.Index)")).Failure
          }
          $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetStringValue($TempHive, "$($MyDMConfig.RegistrySubMenuCmds)\$TempSubCommandName", "MUIVerb", $Data.ReturnVal01Text)).Failure
          $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetStringValue($TempHive, "$($MyDMConfig.RegistrySubMenuCmds)\$TempSubCommandName\Command", "", "$($Data.ReturnVal02Text)")).Failure
          $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetDWordValue($TempHive, "$($MyDMConfig.RegistrySubMenuCmds)\$TempSubCommandName", "CommandFlags", $TempCommandFlags)).Failure
          
          $TempSubMenuName = ($MyDMConfig.PrefixMenu -f $MyDMMidMenuTreeView.SelectedNode.Index)
          $MyDMMidMenuTreeView.SelectedNode.Tag.UpdateSubCommands("$($MyDMMidMenuTreeView.SelectedNode.Tag.SubCommands);$TempSubCommandName")
          $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetStringValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempSubMenuName", "SubCommands", "$($MyDMMidMenuTreeView.SelectedNode.Tag.SubCommands)")).Failure
          
          if ($CheckValue)
          {
            [Void]([System.Windows.Forms.MessageBox]::Show($MyDMForm, "Error Creating Desktop Sub Menu Command. - $CheckValue", "Error: $ComputerName", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error))
          }
        }
        else
        {
          # *******************************
          #  Write New Desktop Menu Command
          # *******************************
          $TempHive = $MyDMMidMenuTreeView.SelectedNode.Parent.Tag
          $TempMenuID = $MyDMMidMenuTreeView.SelectedNode.Tag.ID
          
          $TempCommandName = ($MyDMConfig.PrefixCommand -f $MyDMMidCmdsListView.Items.Count)
          
          $CheckValue = 0
          if ($MyDMMidCmdsListView.Items.Count -eq 0)
          {
            $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetStringValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell", "", $TempCommandName)).Failure
          }
          $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.CreateKey($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell", $TempCommandName)).Failure
          $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.CreateKey($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempCommandName", "Command")).Failure
          if ($Data.Index -ne -1)
          {
            $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetStringValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempCommandName", "Icon", "$($Data.IconPath),$($Data.Index)")).Failure
          }
          $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetStringValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempCommandName", "MUIVerb", $Data.ReturnVal01Text)).Failure
          $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetStringValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempCommandName\Command", "", $Data.ReturnVal02Text)).Failure
          $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetDWordValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempCommandName", "CommandFlags", $TempCommandFlags)).Failure
          
          if ($Data.SeparatorBefore)
          {
            $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetStringValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempCommandName", "SeparatorBefore", $MyDMConfig.SeparatorYes)).Failure
          }
          
          if ($Data.SeparatorAfter)
          {
            $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetStringValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempCommandName", "SeparatorAfter", $MyDMConfig.SeparatorYes)).Failure
          }
          
          if ($CheckValue)
          {
            [Void]([System.Windows.Forms.MessageBox]::Show($MyDMForm, "Error Creating Desktop Menu Command. - $CheckValue", "Error: $ComputerName", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error))
          }
        }
      }
      
      if ($Data.Index -eq -1)
      {
        $MyDMImageList.Images.Add($NewCmd.ID, $MyDMImageList.Images[0])
      }
      else
      {
        $MyDMImageList.Images.Add($NewCmd.ID, $Data.IconSmall)
      }
      
      New-ListViewItem -ListView $MyDMMidCmdsListView -Text $Data.ReturnVal01Text -SubItems @($Data.ReturnVal02Text, $Data.IconPath, $Data.Index, $SeparatorBefore, $SeparatorAfter) -Tag $NewCmd -ImageKey $NewCmd.ID
      
      if ($MyDMMidMenuTreeView.SelectedNode.Level -eq 2)
      {
        $MyDMMidCmdsMenuStrip.Items["New"].Enabled = ($MyDMMidCmdsListView.Items.Count -lt $MyDMConfig.MaxSubMenuCmds)
      }
      $MyDMMidCmdsMenuStrip.Items["Up"].Enabled = (($MyDMMidCmdsListView.SelectedIndices.Count -eq 1) -and (($MyDMMidCmdsListView.SelectedIndices)[0] -gt 0))
      $MyDMMidCmdsMenuStrip.Items["Down"].Enabled = (($MyDMMidCmdsListView.SelectedIndices.Count -eq 1) -and (($MyDMMidCmdsListView.SelectedIndices)[0] -lt ($MyDMMidCmdsListView.Items.Count - 1)))
    }
    
    $MyDMStatusStrip.Items["Status"].Text = $DMConfig.ScriptName
  }
  Catch
  {
    Write-Debug -Message "ErrMsg: $($Error[0].Exception.Message)"
    Write-Debug -Message "Line: $($Error[0].InvocationInfo.ScriptLineNumber)"
    Write-Debug -Message "Code: $(($Error[0].InvocationInfo.Line).Trim())"
  }
  Write-Verbose -Message "Exit Function New-MyDMMenuCommand"
}
#endregion

#region ******** $Introductionrtf Compressed Text ********
$Introductionrtf = @"
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
"@
#endregion

#region ******** $DesktopMenurtf Compressed Text ********
$DesktopMenurtf = @"
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
"@
#endregion

#region ******** $AEDesktopMenurtf Compressed Text ********
$AEDesktopMenurtf = @"
H4sIAAAAAAAEAO3dTXPrOJro+VkrQt/B0Zsb0RFdI0t8sfqubndNTPSi7+JWz84byZYzHeU853Qen87uqMhPNov7keYrjCCISZB4ewBSFin/wSqnj0z+CICSwIcgwP/v//3ff3v89f3l/nH35fvr6cfTt5/u1+X6
8fnw8rJ6/PL1x+vT11++7d7VC2+7Lz/drzabvz2+fP3y/r5/O/6yenz58vr2+PL08+7X74f31d2/7X7++svuv/9+/Nt9/2//vHt73f/6evrjuvvH9d1f/uuX/de3//7778vF3x7//vGnw5fDr7v3r7/e/a/Xp58P
z+vV3f3qT6s/3dd1tfn98T9eD7/99fXLc/H44+n+brl4/Lb79fnx+269Wj1+f1vX1fHnLz/e3u8f//3pcX/K5/fi4VEVYXv3P56f7/7Pu//r+fX97s+H7399//rt7l8PX358f9yr1daFwpaLEHpa4XHf3fxObe/e
tFgZ+fnb47fXp3dVyON/v/369dvvj7/9cnjfvby+HR7Ua7/dF/V2pX77ubgvi9NLP33dvT1sHsrTq+of601ZHgu+ul+tVtuVSpvq+P/V+vT7qti1v6/K83/3f7zSvva0Wm9296unarMtdkfvtFWxWb2oVZ+e9Erb
59Vq/dJu3WzR/Hv9cP7veR21vko6f/cPf+xV7bZaFUe5WB1Ouz//t5+qe9eyXLhfz13w8PAk3v3WvUwlf3h4k/f2p2W6+cPDGyb03uGTy99He9FP/I2V95JeRl3Ourwf61VFXRf69zYKO8ZvoyY8PDw8PDw8PDw8
PLzP5+lIa7Mt6/Khjbqmkz88PDw8PDw8PDw8PLx5e7oPcf1SvWyKpr9snJzpNLXy4uHh4eHh4eHh4eHhfax37uvaFA/LRVn37zEckqZZXjw8PDw8PDw8PDw8vI/1mv6t+hh5VSNFXVMuLx4eHh4eHh4eHh4e3kd7
OtIqd1VRHYZEXbvn3fNyoX6Ot+Dh4eHhfWZvWPvWtk5zKS8eHh4e3vS93PZIR1p1Ud5vVvlRl/J0Pg73YyzLxTgOHh4eHt4cvZyWrd++6TS0bZpn/eHh4eHhje+ltU399khHWuuX4lA850Rd/euJ86s/PDw8PLyp
ecOuJ5opv22ac/3h4eHh4Y3vSdsmd3t07uvaltXmIS3qil9P3G1TluUibX08PDw8vFvyclq2UPuW3zbNs/7w8PDw8Mb30tqmUHvUPCm52Bd7adQlvZ443frDw8PDw5uaN971xPy2ac71h4eHh4c3vidtm+Lt0Tnm
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
PV66/JIoqa0rFb+ZJTLrTK8VHhHXz6s7vsxP8/y84eHh4eHh4eHhfUYvJ+rKyd95No2yrIqHftTl9lKjLv26ijWaeKbpxTGjA3M7M/n6hLrxUTvvRXeGj/BsGuYemvKae1J70blptvCNtLJrRpVIxZd6rpD2r93e
wGZkWnw2DeXo+Tz6sZTKZ7fO3KPd7KjL3V+Wn+b8ecPDw8PDw8PDw/tcXs4dhvn5O8+msame6nUbdYW81HFdw/Ln3qf7fri0ZxybaZzj2+0/0nMg+uK0plcqNpPgmPnDw8PDw8PDw8PDwwtHV+6/Ds1fM66rXOun
JB/jBdHc8eH7+No+pkvEM/I7/OLymMe323+kZ/0I57WZH0T3uTF/Ox4eHh4eHh4eHt7lPPl8Ge2ay4V8rJc/necw3NbFclHs0p7Y1b2br3932+XimeneD+cbb+VLerZG5m/Hw8PDw8PDw8PDu7ynI5aU+TJynpPs
Sk3/VlEXpeyJXbL8jZnw8PDw8PDw8PDw8PDm7J17uw7F2p5PI8cbM+Hh4eHh4eHh4eHh4c3fa56TvNlWz/lR13zKi4eHh4eHh4eHh4eH97HeeT6Nh7KqXnKirrmVFw8PDw8PDw8PDw8P72O9Zj6NzVbPYiiPuuZZ
Xjw8PDw8PDw8PDw8vI/1/ujrWhdradQ15/Li4eHh4eHh4eHh4eF9rKcjreKhKuo6HnXNv7x4eHh4eHh4eHh4eHgf652jrqI4lME5DG+lvHh4eHh4eHh4eHh4eB/rNXMY1pvN+Q7D/qKe5zXmgoeHJ/Hut+5lKvnD
w5u8tz8t080fHt4wofcOn1z+PtqLfuJvrLyX9DLqctbl/VjvqbzfrFab1R9pufj98dvu1+ViuVD/fX78vluvVo/f39Z1dfz5y4+39/vH/d2/PH398o93j/vV3b/9/Pr97vi/958Pp1ePv+ze7357fXu72x/unl+/
f3vb/dfh+e70l8Pdnw/f//r+9duf7jp7+dvjty/vh/98f3xZP/63f6of33f73//2+PfHV4//e/uPt/3b+/GX4x+/fXn98nz48r46bfGf73u1+u+/P768/sOmWj2+vdbrlSvLd3/++mP/dviHf357ffprk5dTdl9e
D2/Pd+9f775+O+iX/+4vh7fD0/vpz393LMHu7etPf3rcR6vl7l8PX37c/d//z7/8WdXLPx5r5nCn60a9puvlVWX+9bjP72Zt6C1f9e5/Pfz0+v391//6k67a/9i9/TjcPe2+fPn6rmr08Pz6fnj+k87N8UicNv2f
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
bz6eivaO8cyAp3OYUqj/0rHFjOK3a3opx9OVpvz+w8PDw8PDw8PDw8ObhyftdTyN98t+Ooc7f3OK367n+etvzISHh4eHh4eHh4eHhxfy8p/O0U2x/kvHFjOK367pyWu0n+bw/sPDw8PDw8PDw8PDm4MXjxzb8Y3j
9Dq2+ZtT/HY9z19/4yQ8PDw8PDw8PDw8PLy4N06vY7z/0k5zit+u6clrtHs8xkx4eHh4eHh4eHh4eJ/bC8V7yst/Okc8f3OK367n+etvaMLDw8PDw8PDw8PDw5N6Q3sdpf2XdppT/HZNT16j3eMxTsLDw8PDw8PD
w8PDw/PFe603Tq+jO39zit+u5/nrLz/h4eHh4eHh4eHh4eGlefm9jmn9l449zyh+u6Ynrc95vv/w8PDw8PDw8PDw8Obg9eO9vje01zGUvznFb9f00o5oOE3t/YeHh4eHh4eHh4eHNw8vp9cxp//Ssf6s4rfrefGa
nPP7Dw8PDw8PDw8PDw9vDl4b77m9/F7HeP7mFL9d00s7or40zfcfHh4eHh4eHh4eHt48vLRex+ViyNM5cvKHh4eHh4eHh4eHh4eHd21PRXvLxZCnc5hSqP8yP+H50+ZB/XzYj+VJEh4eHh4eHh4eHh7e5/OkvY7K
y386R37+8MKeJHZM8cZKeHh4eHh4eHh4eHi35eU/naObYv2XufnDC6Vw5Hj9/OHh4eHh4eHh4eHh3YYXjxzb8Y3j9Dr687c+/dRxkO9nZc0a4/LCko63dNKe+dflwvxXcejb+pW6dpdBv663XXfyZ0Z55k9Jvs29
dcvrU+3tfMlVf+Ey+vbfLa9O8iPhi4Ibz5TWnhzbezC36nqSZL877Pei35PnSSddA933X+rRtNNyMeRomqk5vkOOpik1n7chR9NOt/X9jIeHh4eHh4c3JS8SO+7Vcv49EDnG+y/jKXY+qZMdm5nJPGM1z2S78YcZ
f/okc29m/Kh/Xy7sM3EzzrCTnSczNeX1raVte5+xeMu3XTjZsYb//eeLNnxHovHsIyGPNtbW6008Yx9HX5QeTsuFeTR9R818L4bz2q0/X57CNWAey5TvA0nk6Lq+IT+a9rFcLoYcTfv1Jn95R9NO8/l+xsPDw8PD
w8ObjheK95SX/3SO9PyF+5XM1PT32OfD+hW7b1KSXPnTkunZZ+JmH4nrfFfSV2Lvx5W/1N6dlbFnV/zm28IXbej8+WKKbryfeiTskvj7L839hCOj7vUIaV5cvc126sYzZv3K89T1hhxNf/7yjqZ9LJt4WpIkkaMr
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
"@
#endregion

#region ******** $MenuCommandsrtf Compressed Text ********
$MenuCommandsrtf = @"
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
CSwM4bMGAA==
"@
#endregion

#region ******** $AEMenuCommandsrtf Compressed Text ********
$AEMenuCommandsrtf = @"
H4sIAAAAAAAEAO3dy47rOJrg8Vkb8DsEejNAA10j3+3uVXdVLRqYnkVXL2YRG8mXzEDFucw5kZ1VKOSTzaIfaV5hRDN0RIkXkRQjTDn+VCHqpC39RFG2qM+fKP2///tff3v89nJZPJafvz9d/xy//rRYbpaPp/Pl
Ujx+/vLL0/HLp6/li3jhufz806JYrf72ePny+eWleq7/UTxePj89P16OP5ffvp9fiof/KH/+8qn8p9/q9xbd95YPf/rrp+rL8z/99tt89rfHv3/86fz5/K18+fLt4d+fjj+fT8viYVH8rvjdYrfbrn57/M+n869/
fvp8Wj/+clw8zGePX8tvp8fv5bIoHr8/L3fb+u+nX55fFo//5/hYXavyfb1/FLU8PPzz6fTwPx7+eHp6efi38+dfHn7/5dOn8vPp+2MlZluuBTafudDrDI/Vwx/O3//88uWrzpiFdaFU62+PX5+OL2Jb6///+u3L
198ef/10fikvT8/nvXjt18VGLFH/6+f1bnH9x68/fSmf99vXV8V/LLe7ot7+YlEUxaEQZVUUu6pYXv9dnMtd2fy72Lz+/493ldeOxXK7XSz3+1V1LuczudR6VVzErMfj64K76wI/lm6WaP57uf+BLpv5RZH1W+x/
rLWu6mVTrGt5XZyvq3/9/37ZLkzTfGZ+PXbCw8O7nbc4mKdc6oeHl71XXad864eHN2768QnPtH7v7Tm+8VnUb0peUFvewfZ+GM8UVQ6VOl5NWvDw8PDw8PDw8PDw8PBy88yRYz71w8PDw8PDw8PDw8PDw7u9F591
nOb24uHh4eHh4eHh4eHh4YWWfuSYW/3w8PDw8PDw8PDw8PDwbu/FZB2nvL14eHh4eHh4eHh4eHh4oaV7/5w4ozyZpvnM/HrshIeHh4eHl9qL6fXa/nd624uHh4eHh2fr/Ybjy7Cso9mTNTgvwqf5LGYpPDw8PDy8
ccv3+86Y32NdvV9u24uHh4eHhycmV+w4VLrP64gz+n3n1NoPDw8PD+/jeTF9Zz++jP/ldPrth4eHh4c3Rc/c+/n+fuqbdXR5et9ZHoam+Wx4npAJDw8PDw/PPZn7zvjxH+beL5/txcPDw8PDE9Nw7OhTRH8Z/3QO
ve9s49/c2w8PDw8P7+N58X2n73iNvLYXDw8PDw/P3fuF/X46HDkOe2F9Zw7th4eHh4f38bx+3ynuLxDSYw71fuL305y2Fw8PDw8PT0xjs45tPJgm6yj635jfXe9lf+Dh4eHh5e/F9J2M18DDw8PDm7aXbryGK3L0
9Xz7znzaDw8PDw/v43m9/OCIe8z1ez/Ga+Dh4eHh5eulG68xNusovPjRHveyP/Dw8PDw8vfC+k7Ga+Dh4eHh3YOXbryGOXIMy18O9525tR8e3m283Vn8Fd+atXF8sny1nbOZDmu53PKy3ck5d2cxrzqPeO+w7nrb
3fIi55LC1NsPD2/c1MsPJsk6zhmvgXeXnrm/aoroW0Tvclhvd3L+tg9S5xH90fKyPjWG2nfpaxCvrU/yXaHJd+W65LvzWfO+nMSyu7P1G6p45vn757tqL+yu39T3L95H89KN14jPOrZemqzjlPcHHt6QJ3or2QeZ
+lxzH9n0UOI94dliR33p4Zhxau2Hh5fC8+07Ga+B93E9tbca6o9kXyOWaKJGtX9z/+rZRmYiHtTXZOsXh39LFfWTkazvEk1txKty/WrkaK7fVPcv3sf00o3X6EeOMeMlXX1nnu2Hh/d+nv67pehRlxeTp/bY6m+f
tn6v/7r4/toyl1NtPzy8lN7Ye8yphfEaePfmufqr7iR7n+1ufRLvb3dNJq/tgeazpg9S85HxWcfr9+36vvuXWH0y96xt/WxTWNZxCvsX7yN76cZrbKvrFJR17Htj+87p7w88PLun9n/uXs5+fY4eO7p/672n9sPD
S+cN952M18D7uN5wb2X29L5LjThdkaPMX4Zcsbo+qV7/t1Jz/fRraW2lf72qq37T2794H9lLN16jzTnOZ2OezqH3nTm3Hx7e+3nm30fr75shvrP9xqlHjv3S/h576+3Fw8vZS5N1ZLwG3n16ofk8dWr7KdG/2b47
MVnH+awbyY7NOsr+sr0yR41RY8Y6Tmf/4n1kL914jbCxjmYvvu+8l/2Bh2f34rOObTxoyjrKvsw1duM+2g8PL53n6jsZr4H30T1XbxVfP/XONN3xGnpspkZutgjRPIKjiQe7a7X1oGoMaM6KmusX/wttDvsX72N7
qcZrNPnG+Kdz6H3ndfxl5u2Hh/deXr/vEf2bbfRI6FhH0/U0wxHktNoPDy+lN7bvZLwG3j17cWMdxb9F7OWfb7StTWT65L/b/tJdj7A7rMr+0ryEfne54chxavsX7yN76cZr+GYdXV5M33lf+wMPb2gO9xU2pviy
f0+7kDus9nvZ6bcfHl4Kz9x3xuQbXb1fPtuLhxc+9e+w6uqPYp4Aldv22r00WcfpbC/efXvpxmvEP51D7zuV8ZeZtx8e3m0895Oywp7r2L8+R78TQFgGcgrth4c3zovvOxmvgfexvLDnOk5/e31aoI0cc6gfHl7I
lG68xnDkOOyF9Z05tB8eHh4e3sfz+n1n7Y14OgfjNfDw7tkbm3Wc2vbi3beXbrxGmqyj6H/H3mNuyvsDDw8PDy9/L6bvZLwGHh4eHt60vXTjNVyRo6/n23fm0354eHh4eB/P6+UHR9xjrt/7MV4DDw8PDy9fL914
jbFZx+t4qyRPtpry/sDDw8PDy98L6zsZr4GHh4eHdw9euvEa5sgxLH853Hfm1n54eHh4eB/P6+UHk2Qd54zXwMPDw8PL3Es3XiM+69h6euwYM7X9eZoJDw8PDw/PNrn6zvjxGvluLx4eHh4e3tjxGv3IMWa8pKvv
nEL74eHh4eF9PG9s1tE8XiPf7cXDw8PDwxs7XiMm69j3ZA3iJ3G9T8oJDw8PDw/PZwrpL/Uyve3Fw8PDw8MTU0hv15Y2bpzPYp/OYS4x+Us8PDw8PDw8PDw8PDy8HL2wrOP0txcPDw8PDw8PDw8PDw8vtDT5xvin
c+gl5+3Fw8PDw8PDw8PDw8PDC/d8s473sr14eHh4eHh4eHh4eHh44V780znMXsqCh4eHh4eHh4eHh4eHl4M3HDne1/bi4eHh4eHh4eHh4eHhhXvb6jqNzDpOZ3vx8PDw8PDw8PDw8PDwQosr65hD/fDw8PDw8PDw
8PDw8PBu740d6zi17cXDw8PDw8PDw8PDw8MLLebIMZ/64eHh4eHh4eHh4eHh4d3e88k6no6maT4zvx474eHh4eHh4eHh4eHh4d3Ws0WF/cjRHF+6DVeZZjyNh4eHh4eHh4eHh4f3sbwmvrS97591fJv64eHh4eHh
4eHh4eHh4d3e8806zmf+sWPK+uHh4eHh4eHh4eHh4eHd3gu7YtVUWmEK24uHh4eHh4eHh4eHh4cX6g1HjiLfGHbFasr64eHh4eHh4eHh4eHh4d3eS5N1dI2XHFc/PDw8PDw8PDw8PDw8vFt7rshReDH3yUlZPzw8
PDw8PDw8PDw8PLzbe2OzjsKLfzrHcP3w8PDw8PDw8PDw8PDwbu2Zo77WS5N1zGd78fDw8PDw8PDw8PDw8MK9+Kxj66XJOk6z/fDw8PDw8PDw8PDw8O7f60d9fW9s1jG37cXDw8PDw8PDw8PDw8ML92Kyjn1vbNZx
yu2H9zG9laPMZ653zSV1/cZ4u1L83WxSeaEFDw8P7yN74T2Iuz9KXb/4ovcuU9gfeHh4ammjPrMXn3XMc3vx8NJ4sle+RJf5rPnXcOwYU7/4Ivv2+cw/dvQpU9u/eHh4eLfxhnuXtv9wF9/e5f22N/SXySEvruDh
4Y3xwrKOZi8+6zj99sP7mJ65b/ftz3379ttsr3/fns/+wMPDw7sXb+wvk21/lOaXyX794ovau0xnf+Dh4alFxHzz2ZincwyPlxxb8PDy8+L79n586du3ry7i777q/53P1P8KXVpfaj6TvbvPvGqxzd94aizqH53a
t9dm6Esst+27cn6Tp84VWku1dD8v7ra0rVkWuc+6+9e9J3xq3OSTferh56m1Df3U2L1UBQ9vap6rdwn7fdJ/PIT7++vfu5iOV2oJ7V2a+tmWCO1duvvDX7XNP5+5+5fQY6vf50VtcXdpjvdyfT41UMvQ9vof9cdt
r3/Bex9vIOtYXac6bpzPxjydI75+eHg5ev2+PSbf6OrbTfWTx153nGGLlZr+XC/yfbm0uh79GK/2it36bffmJWSRS7j7dtP2hqpyfvnX5Kn1V4utF07x+/hQfyn3lFy3ug9sdVXfVedvPPfZgH8L+Hn+dZ3P1NqO
L7kdD/DwUnrvPx7C3bs031/3b3F6sfUupvEQNsmnH+h6Pkctt9r0l7b+RS/uY6up/437ZbKpn2q4j6229Qz1b3Hb29TP/7zCp0zt+/sRvPinczRlaLzkuPrh4eXoxfTt5vgy/ooie3yp96M+Z+5+8YL+ru1XTbvn
H5Goqimf568OxatjcqMmz9+wrTk83hr6vT20hfx+v/f/hLnLlI8HeHjpvFzHQ7h7lxTjIUzxjK1/cddpKL81Xh3qP8Z5PkUubYvumvxg3DUqftvrf9Tn/kj35Q1HjiLfGP90jrH1w8PL0Wv79vh8o7lvj62f+itg
Nx/lc81kSLxg+73Wdq2Oew1D2xuq2u/vo7eNWvStSnG/oKH+0pZ19N9nIecvPi0Q/vu9u66m3+/HlDyPB3h4Kb33Hw8xVD9b/xLauwz9fhXau5iOL/6/+dnHL4SqtmNr0362/mXceAi1/7D9tUWWQ/2bT2Rp3x9j
9opapvn9/Qhemqyja7zkuPrh4eXohfXtrvgyrG9vzu9t/YTed/n0AN38VuivkXq5TT4v/PfsVLW0f17ixjr65Qf993VsPtnv9/u4utq98QUPb8reLcZDyCL7l9DeZSj+CO1dQn6ve5t8nlsNv74k3BtT18Zz/1aY
ur/U37Xt99y+b3jhy7giR+HFP50jTf3w8HL0mudlxfbopr59qH5qFGIbk6KWxrON5VN/sVQ9dT1dz7aErbhzavb708SpQ/FW6FjHbr42tJay2PtLd1v67LPu/Qr09ekldjyOuwXs7Rf6eXGXnI8HeHgpvfcfD6F/
0/2217936f5+5d8f2Ur3+GLLhPofd5r6uVX/Y+tQ/xvbn+tFrkG99tbnLjrh4xf0dZq21+e8Ytz2xhW8tN7YrKPw4p/OMVw/PLwcPd++ffj3Yt++vYkX4saU2a/3ceeufH557tbPfb2Svga1R9GvrbHnV/XRlj5Z
vdj7i9pq6Rfvx44n8d8H9v2rt+mYFmj2h79KvhEPL6zcYjyEz7dVL6brWf2vgvHrj9T6hfYu3d//9KNWaO9i6o/G3GG1e/9T9xWm7tL9PdF9FyBbLdWlxm3vUH56/PbKkuf39yN45qiv9dJkHfPZXjy8NF6aJ2/J
vl3kL4fXKo+wtnH9sjTH5/E5HrVMYX+IEjeawu6NL+PGX9rK0PWx6by4goeHN8Z7//EQau8ydHwJ7V2mvz9ESTF+Ia74eeodUd25vW5/GXc9a3j9/AveFLz4rGPrpck6TrP98D6mN9y3+/5e7Nu3N/Vzj0ZxR5bx
2zsFz+9+oKlKyPmGbW+F5C99inrHvdvvDzw8vJhyi/EQsvj3Ljm339t4qX6ZbLw0TuupV4r6nAcM3Z819+3Fu6XXj/r63tisY27bi4eXxlslKeL8wDd2DKsf3sf19Hh1nOdf8PDwxnvh/Ye7pK4f3v14/r2Fnzem
4E3Hi8k69r2xWccptx8eHh4eHh4eHh4eHt79e23UZ/bis455bi8eHh4eHh4eHh4eHh5euBeWdTR78VnH6bcfHh4eHh4eHh4eHh7e/Xsi5pvPxjydY3i85NiCh4eHh4eHh4eHh4eHd1vPN+s4n415Okd8/fDw8PDw
8PDw8PDw8PBu78U/naMpQ+Mlx9UPDw8PDw8PDw8PDw8P79becOQo8o3xT+cYWz88PDw8PDw8PDw8PDy823tpso6u8ZLj6oeHh4eHh4eHh4eHh4d3a88VOQov/ukcaeqHh4eHh4eHh4eHh4eHd3tvbNZRePFP5xiu
Hx4eHh4eHh4eHh4eHt6tPXPU13ppso75bC8eHh4eHh4eHh4eHh5euDeQdayukzFybL00Wcdpth8eHh4eHh4eHh4eHt79e/2or++NzTrmtr14eHh4eHh4eHh4eHh44V7MWMe+NzbrOOX2w8PDy8vbrrvTfNZ/ZdyE
h4eHh4eHh3dPnv9ZVhv1mc/X4rOOuZ1P4uHhfQxPHgVPq5BpPgubHw8PDw8PDw9v6l4/chw+XwvLOsaMl3SVKZ+f4uHh5ei1kWNux2c8PDw8PDw8vJy8mKxj7Y14OsfweMmxBQ8PD8/fC8s6Tvl4j4eHh4eHh4cX
P7WRo+/5mm/WcT4b83SO3vzZtl9enqsNp39+j4f3Nl5zPf+tv794eHh4eHh4eHl7YVlHcb4Wc5+cbhkaL2lYItv2y8vz3Y+2kvP5PR7eW3m+WcepHQ/w8PDw8PDw8FJ6ze/t/mdjw5GjyDfGP51DL9d4NdP2y8uz
t1/Kgod3b17MfXLyPx7gTdFbFbtdtdE/p7udOMCLOarNPW0vHh4eHt60PN+sY3u+libr6BovaVgi2/bLy/Nv0X6Zwvk9Ht7beMOR422PByKWOK02dTyxuh4LD9u86vdxvOE9MbZ+MnIU8mbT9Ypiszlsxevjf0u9
l/2Bh4eHh/f+XvzTOczna/FP5zB7r0tk2345efb2S1Pw8O7TS5N1fLvjgYwnqo3IPOVYv4/jpdkTMfXj9wM8PDw8vBy84cixf742Nus4PF5SL/m2X16ef4t290fK4uftSvF3X5n/ri66t9mY511uzfbGcM2X9Nzv
6++m9mSxbbvJi1vDdi89VZfzuj3bGpr62Wou15eu/eSnwLY2vUihqV9IcUWOru+bPJu/1tWg6lcYiv+X+SMRgfjkj+SSq+v84r/E33YS0YP0ZEbK7Mn3ZA11Q27DqpARSbWp98eu/5p7ieZdGcv096X4/m7qsir0
JeTWydZwt1x3f9jyb2oN+nk7V/2K17bpL+HeE+Z2sF0PImqsf0bc29Ctn60Vw9Yg6mduCdMa3J8E0RbzWffqWnXfqd8PW+v2691ur1pzGbHL2rat1P0G6vG8sOczv3b3naZ8foCHh4eXxkuTdVR+v0+SddTi1Wzb
LyfP3n5jSzqvGx/ZivquGjOqRY0suvWLi7TUd+ez8ZGb3ZMxlm0JuUXu9Q9tr/y33sYyztbXMLR//WPNFO2n7/Fu/eT76u8LtuVspb+9oVlHcbbbfN/EGet8ZspB6RkqNVZynb22xwO5JlsspdbDHKnKtYl4UM6l
n8Hr0cFw5Cjzb+376nbpZ/DyVTV27bdDfzy7T2yoxxFtawhPX1q+r9fPvb3N/tD3xPByti0RnmwDEavJ5Q7b0FZs1yDiI31749cg94frs+CO0tV2lfvDFDva9rJeb7V+zefFvS1hdp79OR4eHl6enityNJ9Pxmcd
fcdLGtaZbfvl5fm3aHd/pClDni2eGfJSZQlz8WztYPfiatyN39xLuMuQ51ObkPaTr+ixobvEf57NkaP5+6aeM4ddtxhzPJBnwOZz8zb/ttvJ6xj7uUl57i7quHqN0vRz6TY2kOf3frGjT6zZbm9MdGr21C0S2y7e
adumaQ3RHnIe8artrjKu+vnsCVO+Vt+K4XGRtlqYPb0VfdfQtt/YPWv+/cD/U22u9/D3Q40WN9ei/17S2s3vOUPt7jtN//wADw8PL403Nuuo/X4/MutoiVezbb+cPHv7xZd0Xkj8oRb9Gla1zGd6Dm9MljDd9aJ2
TxbbFbjurKNpf4TGXkOezxpsJUX7+V0fG/o5aupnetU/6zh0fp/ueCDPeMVWylilewasnkXLeEbPcTbXE8p4UUY+tmv+fOM6c/zhjmFc85vP7+V/yehQrUGbd1IjOZFhbNpKHF/k6/rSqqF/Bsy/A7TXd+p7wicO
K4ru1cz9z5+aRYxpxeZ6ZfvPhmFr6MeDrtjRJ3I092/uK731eg99/uLtt/v+4uHh4d2rZ44cXeeTMVnHsPGShnVm2355eb7tecvxjT65pHHXn4Zf3/m+nl6GvNA1xI6/tNcv9IrVce3nU3vTeNjY0o8cXd83WwSW
+nigRkkmT48C1FiqOR60r9misZB4oV3CPb9vvsx3DcLTY2U1opNXJ9q2va+2+dUxe2LIc2+jHo+Ge75rEPF0fx1j88m+saNpGvq82GJ19TPQZNJNWUdXPtT9i4x5upfzAzw8PLw0XnzW0fL7fXTW0RmvZtt+eXn+
+3G4pI8vQyMWWWwj2Orzq4v5HTVrpRfbvVaa7dWznKk9W1FHIurrt9//RV/C1jJdL/SKVb/4151F1Iut9qbtVVtIvz+Se6yj6/Mck3UMiz/k5Brr2B4P9ChJl9oRXs2Zs3pOLO+fY8q8yXfVDJstXrjuCWXEYH/8
pR49N9eLmq8h7I+NlMcr86hPfaSaLfJt77Iix+e1raVHfLZoxz7+zb0nzO3Undot6Y/n1PegbdvNtW/jLdsS7jX0X3flk2Oyjj7jK0LqLePB/jv659nXbvaH+ymZ/tMUzg/w8PDwUnj9yHE4XgjLOsaMlzTMn0v7
1ecUx+pcn2OWdY9Tbvbr4/lYHbfRXuL6DbfkLa9n9RnraPds13e677Bqut5RXuGqRiH6u2/pyWK/HlOP0NQauNdgup/MmCs+/cZz2uqqv2JvP73Yam/PN/rfJ6db2sixf31i84Q93zuNDH1/fe6To47na5fpe/o5
s3oP0M31rF+PGvrn3uJ6Vne8ICW9zYbGX+pL6FcgDt9hVdRPzmu7X5AtjjW/Luqn3lvIvNZuzGsbNdnNb6ntZIuq1bWZ89b9eNWnFV1raOIjU27NZz8N5X99WnHo++HTNnKf6dveH3ncv1+Vj+36vovfX4a3wn/K
7fwPDw8PL8aLyTrW3oincwyPlzQscYv2u8aJ1fZQb+/2cFnU5wrl5VL3MUv5d7/c1D2n/Huoduf1sjqVp/2hH02+5/7134+u8rbxpfqUCFuJjS/jysfz4u6TYx/PmaJWt/TUrGM/e6fn7vrxhzszGB5f2jIpav2K
wnxvy+7zEmy5K/97t6Q4Xr3f+NDUnntP3L5+qT3/q1CHxsNOY3vlNPyNv2398PDw8PLy2sjR93zNN+tYx1sjns7Rm/892k/JKKpx4uGw3RaFGjPqkaP4K9rvuDkcllUnmjTmJt9q/7raMK/ze5lp6j7P0JZZiit5
bW9eXorxl6El5/YTx8D6ePUaO6rRlftM0vZ8vKZ+YSMi7Vdldo8H7tGW7mfpdZ/X4X6SYbrjVcy4uNv2l649kUP93sYLiQfHjHXMZXvVLel/3+X40PDtyn978fDw8MZ6YVnH6/Uv7tixuk6eWUfveDV1+2lxYrXc
b5bLfoRY9x/esWNRnPfVcW14XUaUIpacz8ZEk8Pb67sfbSXn83u8dN74SLDrqWWMfav2U7OO6jmxuKpUXoH3Pvky91McEx7/lOnt80fjxoem3l4/b+yeeOv6vY0XeieeqW+vvtX9b/w9bi8eHh7euKn5vd3/bGw4
6yjyjfFP59BL//4CKdpPjwRtEeJw5Cjq544drTHl9jpdxJRi/9rbL2XBw7s3z/8+OX7Hl9THKzw8PDw8PDy8HDzfrGN7vhbzdI5uGRovaVgicfsNR4gi3yj/67g41G+fL9VxtT9dyvWijvP2p2Jz3O03RVEVu3o5
ubQrchT5RkPsWF0nGTsur9Oo/evfov0yhfN7PLy38YYjx3s53uPh4eHh4eHhjfHin85hPl+LfzqH2XtdInH7uWPHTpy42i/rGO+43+t/r+Mb1deqfVls1GjSnXVMvX/t7Zem4OHdp5cm6ziF4z0eHh4eHh4eXrw3
HDn2z9fGZh2Hx0vqJXX7nS/H5XpzulSL1f5YHg7LdSVCv1LkE+v6bcyRYu/vNes4PI/Y3qqq48/yUIjbhLtix7H7179Fu/sjZcHDm5rnihzv63iPh4eHh4eHhzfGS5N1VH6/T5J11OLVxO13XO7Pi/K0LpfLw/lQ
lauzzBLKvzJvqMaGp+PhsijPx2q3Wl2OR3G/m9N+tynrJc7bQ73EZnf4Me/ysCjK87KsI9LL5rhZr+Q1r/tqc2rWIJdKvX/t7Te24OHdsyePgvGTGC+ecsLDw8PDw8PDy9cLOV+Lzzr6jpc0rDNxPG2+XrW93438
W233h8XlWB6q5cHnDqvlarcuLud1HV+eTeMlh69YDYt/XbGjT5na+T0eHh4eHh4eHh4e3nS8ftSn/X4/MutoiVejM3HmeMs21rET1y3Kzeo1Y2i6f44hdlzstovNuajWMnb0iRxT5pPt7Rdf8PDw8PDw8PDw8PDw
YryYrGPYeEnDOoPzb+7J/vzG4djRJ3Kcz/xjx/j41xw7+pQpf/7w8PDw8PDw8PDw8KbgtVGf2YvPOjrj1Yj40BVvvd4n51yeV9vj5rBcHMv9bl3s1fixHzle843XsYtyHGN5FI8OVu99o2cd5b1aj1W9ho0c3yhH
SDbPgxwXAevbG7w7HSXPzx8eHh4eHh4eHh4e3jS8sKyj5frT6Kxjmus7X++SU4eE89lyey6r47p5moa8l83rvW/2i+JSlft1cZH3vrHeSfX6BI/qvBfx4EVGiq9Pf7QsUW12p+I0Lv7Vp+GWnP7nDw8PDw8PDw8P
Dw9vCp6I+ep4ZsTTOYbHSxqWCM6/uSefsY7VYX9arkUsKepXLrdHER3uLj/uvXr9q957tTodiuVa5iFlTvJ1zvNhu9wfz+V6fTktqrr9DosUEbC+vYE701Jy/vzh4aX3pnp/Mzw8PDw8PDy89/dCztd8s451/UY8
naM3f3D+bThybO93475Pjj5CUWYmz4tqudp3x0t6jWk8n1bVqtzuTsvueMnjdrsoQ+JffXK14fTP7/Hw3sZrjqdv83sOHh4eHh4eHt69eG3s6Hu+Fv90jqYMjZc0LJG4/XzvsDqfGWPH69+wO6meVue1qF/5uu7T
vjyu9vq8x1VVlVXs9vruR1vJ+fweD++tPHkUTHd8SX28wsPDw8PDw8PLwWt+b/c/GxuOHEW+Mf7pHHp5i/vJvEZ8yl1vjov9utjI61JlXtGadexFjh7PbzycVkdDvLovN5di07lLa7Gv49X1JW7L7O2XsuDh3Zvn
Gzv6Hl9SH6/w8PDw8PDw8HLwfLOO7flamqyja7ykYYnU7bcui9XKeteb+q/Y3uNhXxWlGk1as46HY7neHw+H1aI05C9f63epz013ndjxdTzldS45RvJQbqv4++f4t2i/TOH8Hg/vbbzhyPFejvd4eHh4eHh4eGO8
sCtW3ZHj9ff76KdzmL3XJd6o/Y5ldTgV1XK3fb2XjSOabO6SI2PJ0+JQzWeLy2l72BYXwxLXO+RUxW6rXrFadvKd/WWv8eqlPGw8YkfTZG+/NAUP7z69NFnHKRzv8fDw8PDw8PDiveHIsX++NjbrODxeUi/v137H
cj4LiSYNf8+Hy3p5WlS7fX0uerzMZ8ftq17//7GSUaP+7I5miTH7179Fu/sjZcHDm5rnihzf7vi8Kna7aqPXZiduznw95lWbcceDcfXDw8PDw8PDw+t7abKOyu/3SbKOWrx6w/YzZSav+cEmUqxfk+/LeY/nY3Xc
Vptys1+Xl8Nxt+14i+OmrOq/xeH8+rcbX46Y7O03tuDh3bM3NusYc3yRkeNpddhuOhFiUWw289lhK15/u+st8PDw8PDw8PDCl3FFjubztfiso+94ScM6M2u/azT5+vc6VadVVR62u+1KueuN2N7XZ0SW5XH8sxyH
6+ffot39kabg4U3TM0eOtzq+yIhSxI2r65HvYPlVKYf+Aw8PDw8PD+9jeWOzjtrv99V1is46WuLVbNtPTpdd3ZKV7Q6r+93mUm/04bj+EWu+Sf3s7RdfGm9Xir/7yvx3dekvt9mY55zPltv+vNLeGK7dG353PtPf
T+3JYtt29/pN+8O2hu3ebA95/mtQS+PJNd1ie93vys9UUz/9r22LbO/KYm4/NXaUkZr09JygnNprTeX9n9u5xFIH7RNeFHoOUV1Pt36buqwK8ZaIHavNbtf9loesQRxf+uswrUHGq7Z1drdXlrDrasOOp3h4eHh4
eHh5eubI0XV+GpN1DBsvaVhntu13Pp5W+0q9a2q52G3ns8VGjyBlVvIt6+fbniHxpRov2D31fdsZvIwF9Nf12KFbv9DII7UnIzq7p8deoWuYz+R/6a0s42xbdGcr9vhXV3X7PbbX/b47BpTvqr9WNJ5P7Ggq/cix
jbf02FHGWNcaGGJGPX4TcwtPxGoyHjtsZawlBKGJGExdQr4qv8xqFNeuof+8IunFr6H+vFhjR59IOt3xFA8PDw8PDy9vLz7raPn9PnqsozNezbb9LnXsuCnV2PF8Oa7Xe/nMRvmkjvIofqA/1jHmonzb+vnvx+Fi
j2fcxRZHdPOX47OE7+e528G2/qb9/Jdwz2/3fNZg8mSMeIvt9fP0XPaY4jq++GQd1ddFZFXX7/W45HuFaTOZo7T2eKC/H7MG4dmyiLY16PO3r8vt7Uvjjlepj394eHh4eHh4b+v1I8fhfFRY1jFmvKRh/mzb71yf
wx2UyLE+f36NIPWndjR3xXm7+g23ZEi+0eeqR5Nnu4ZVFj2nlfp6x7e5frJ7faf+Ny527cartjbz2ROy2ONfdSvUvNxtttf2vvqKbc3q+tNcn91GjuL7ZosdZdZPv05TzUP2S1s/NYvojgRtcZ307F/ymDW08eBw
7OgTOeZ2fMbDw8PDw8NL68VkHWtvxNM5hsdLGpbItv3kdFnU51ivEeR5WR6W687zOi5lHUi+R/3896Or+MUzthJ+fWLq6x1Te+5i8sZfY6uWIc9nDeo1qt183i22N4Xn/7kcPr7Yso76nN18o5zc0ZX0hCVjUBF9
ducX14u6vbA1iPuzupcIyzq68pdvczzFw8PDw8PDy9NrI0ff3+99s47z2Zinc/Tmz7b9Xqfr+Khjdb4ci/XmeDwsFmUdLx42p9Oiiry3akz9XG0Ynp8Zimdsy8WNdWzyW3px3xtFz3Gm9mQxba8aj+k1cK+hG7/Z
2kb1QvK/tuhU5nx97PTb69/ittboxr/6/ZbGjHWsj1de98mx5R77Yx3b72873tC9RDPZr2e1LeFegzlP2o8Hx2Ydsz4+4+Hh4eHh4SXywrKO1/szRD+doylD4yUNS2Tbfnl5vvvRVrr7I26so7qs6XpH9x1W9fll
tCOXMnnuaCiFJ4vPlZum60X916DP361fXGZQVUOu3029vfq9efTWMH3+fO7nq89v8uzF9w6r4vvmjqX0+5/KWrVyMzX3z5H3stHrpN8nZ3gNIt+oHyVs92TVr3BVt2qofjF3WJ3a8RQPDw8PDw+vOzW/t/udYV3P
NAYjR5FvjH86h1769xPMqf3y8uztF1/0O6za44+4ks/z/XL1wvO/ao7RHW8NXb87vkzB8386h8zw2eLBvI4Hds9/BOPwnFPYXjw8PDw8PLw0nm/WsT1fS5N1dI2XNCyRbfvl5fm3aL8MnY/rzxx054GmEC9Mx4sb
j6hm9ez1C7VN9RtfbusNj3U03+8m9+OBbQqJB8Puk5Pn9uLh4eHh4eGl8uKfzmE+X4t/OofZe10i2/bLybO3X5qCdxsvZDzimPJxPTV2vJ/jgd0LvRPP1LcXDw8PDw8PL403HDn2z9fGZh2Hx0vqJd/2y8vzb9Hu
/khZ8PCm5rkixykfD/Dw8PDw8PDw0nppso7K7/dJso5avJpt++Xk2dtvbMHDu2dvbNYxz+MBHh4eHh4eHl5azxU5ms/X4rOOvuMlDevMtv3y8vxbtLs/0hQ8vGl65shx+scDPDw8PDw8PLy03tiso/b7/cisoyVe
zbb9cvLs7Rdf8PDu34vPOuZ8PMDDw8PDw8PDS+uZI0fX+VpM1jFsvORwmeb5KR4eXo6ePAq2k3heUcoJDw8PDw8PD++ePP+zrDbqs/x+H511zO18Eg8PDw8PDw8PDw8PDy/WC8s6xoyXHFc/PHNZvT7fTz7tL1XJ
d3vx8PDw8PDw8PDw8G7piZhvPhvzdI7h8ZJjC56pyNjRJ3K8j+3Fw8PDw8PDw8PDw7ul55t1nM/GPJ0jvn54Ns8/dvTz0jh4eHh4eHh4eHh4ePfpxT+doylD4yWHy/L6V0ZB6t/mekz5d+vxtAqb1Hgy3pJFerZ5
1+e+LV/Z7dpXutsr35FLL5XX1RhP/avXu7u98q+6PrXYVHWp8P2hb6Naup5ag6U2r3tPNNfb6pJeVElfj6yx6fOiLhdXuvG5/tf2ibR/nm0t6253+br+iZzPbG2T2rNtkdo+6ndr6Hpq/33abT/1nfFlCsdnPDw8
PDw8PLx8vIHIsdpW81n9N/rpHH71c59JymKLzEzxh3oWq65BPde3ra3x9PNr2/m4GoPqpTl/1uuk1sw2j7RN8ao73tKXs5Xu/nDHHGqxRY7deMtnT7i3xC+e0fejLUr3+36o+9S250zxYOjelEVtdVP9bLGeT+SY
wlPn73q2dvL/NaDZv/py+j5VjwG2cl/HZzw8PDw8PDy8nLw0WUfXeMnhop+x2rfXdvYtX7HlgcLbT0qqZzofV7Mg7sybez11fO7MqYaemzf1c8c+erFFjk39fM7y3XuiWz9d0ktsfBSXdezmy3xaTo3A9E+NLN36
6XZolrDxUmUdhzyfGFp9d+h6att6htov1VXa0zk+4+Hh4eHh4eHl47kiR+HFP50jpH4+WUd9zu71p6FRkq6arhfVz+/d86ilmy+zFVsGSJ+nuV5PFp+zaLdt2h+2mEO/ilePHGPjVduWjIuP9LYPyTeG52tl8d+b
ej7bfj1rXNYxndf8vmH7tMVlHRvPlt/Ui9/vJakKHh4eHh4eHh5e97/HZh2FF/90Dlns16/Zih7J2Mc32kan2SJB2/q75+M+EYZP5Nh4odHGULxlW85dTOM55Wv6Vbm2rKNtT3T3h/8Vq7HxUVzWsbt/Q4s9n+ee
yz9L2PXGZx39PFV9y/GrQ+03Pus4teMzHh4eHh4eHl4+njnqaz3/rKNrEtezuuJL/6xjUz89dnRHSWr8o8/v1376+bgtyjDly2zFdo1e1wvN66j1M90PxbaEbRvl2mQt5Tzq+rvxfuie0LckRXzU/T3CPI+phF9v
qxafvWm6vjPuvja2lknvmZ2mhF9PHXrFqlvtX38/dmqPV3h4eHh4eHh4eP3Jdk7oihzTxb/269ds8/qcqw6NL3OfparxUePZzsdt0YY7cjTFl/53VlG3t7me0Pa+f+mOH5SGfhcYNZrU99nQ+b173+mtaB9/GXrF
qrs09fO/YtW9zu711G5bzefpS3XztT5tndqTr9vuOjx0vxv/fTrUfmOyjvn8XoeHh4eHh4eHd5+eT9YxxDMX/6xjc78W29mj7WkK9vF+7md0+Ge5mvNd+b772RR67cOf56Dfx9Tn2tuh/aFuo5pjVIv6rj3e998T
3fyl/7b4RI728Xm24r7HZ/jnWf1rin/l/+vtblvOdqXo23rup5S4Y7zu/vW5Ntz/2zO14ykeHh4eHh4e3v165sgxff3GPJ3D5CWrWsfzf3KFLLa8Vz77t1+a63dtEa4sehxxm/3xlp4ab9m2Ts/K2r0xBa8pcVnH
6W4vHh4eHh4eHt6UvPisY0j9fLIMQ8+vCC3h7eeOHE3emKfS3+bzol6B6L67jl/+yL/k+P3oXj/pk5l+3/p9NK+bvxzvqQUPDw8PDw8PD2/c8v3IMbf6va8XmnUc8sYXPLyP5IVmHae+vXh4eHh4eHh4U/Jiso5T
3l48PDw8PDw8PDw8PDy80NLGjfNZ3H1ybCXP7cXDw8PDw8PDw8PDw8ML98KyjtPfXjw8PDw8PDw8PDw8PLzQ0uQb45/OoZectxcPDw8PDw8PDw8PDw8v3PPNOt7L9uLh4eHh4eHh4eHh4eGFe/FP5zB7KQseHh4e
Hh4eHh4eHh5eDt5w5Hhf24uHh4eHh4eHh4eHh4cX7qmx4yW6zGfxy+Lh4eHh4eHh4eHh4eHl7bkixxzqh4eHh4eHh4eHh4eHh3d7b2zWcWrbi4eHh4eHh4eHh4eHhxdattV16kWO+dQPDw8PDw8PDw8PDw8P7/Ze
fNZxmtuLh4eHh4eHh4eHh4eHF1r6kWNu9cPDw8PDw8PDw8PDw8O7vReTdZzy9uLh4eHh4eHh4eHh4eGFljZunM/GPJ1DL3luLx4eHh4eHh4eHh4eHl64F5Z1nP724uHh4eHh4eHh4eHh4YWWJt8Y/3QOveS8vXh4
eHh4eHh4eHh4eFP1irrMZ0VxvBafJeScxbWMq59v1lF41Vb8a1UWxbb+16k6vK77VF2l7aqUr8j57PMfilMlPFF78W5bqu12K/6al7O9vt1W28ZryvYq6fPaiqiTWiOxP2Q5XF9pt1Oft/l/V13ns6Gt0F93zSm2
18eQdRY1PPxoGfH+qlyV6np8vbbFu+19uLaTaXvTlJy/v3h4eHh4eHh4eHjv5b1GgvtiV2xc8aPwfOf1rZ//FavDcYSIt8Trq9K2hHxFRjDqnOb1zGchkZF4f7tV69SP6Mz7Q42DVEOWZh3Vtlt78YqsXzuXjFbl
3KHxryl+izH68arcOjX+lXWV8WPYeoTXb4OmBcQeOFV6DO0q9/L9xcPDw8PDw8PDw3tfzx0VhsSX/mU4cmw9W+Qmsk0i6ySiK5l7Eq+eKn3+Jt+oxlj6GsPycmH5MrWY405X++kRovpu8RqnCSkk/nVtnT6nK/9r
bvFujdV91o0H/T11L/fn7G/v2DKd7y8eHh4eHh4eHh7ee3p6hCjKfJYq09iv35isYxtHzGdNJGGOn7pL6Feq9q9X9Y0HQ/Jl+ha5I0HX/M32+sSOPpGjOR6Mzzr24zf9ClM1PxjiDceOPpFjPt83PDw8PDw8PDw8
vGl7agTpGzPG1M8VOfY9PTpQYyU5jxpZVNe5TNc72q56ldewqtdEymhSnUf8d/Eab4VfF6qWfhQ0nzVxkK3YrtY0XwMq2k/Oq14vqkZx6jW7/a1rtq0VxPXAoYZtG7rxoG+Ld+vUv15VtF/YFavuMuXvLx4eHh4e
Hh4eHt77eG3kWMcL3rFjTP3iso7VdaSizL/J6KGJUtTrIavX8Yym++R0c4/2eHB7vQpWLe7RlP3XXddPhmYdm/az5U7VWEqtmbyWV51fztnEWz5b5zJUoT/eVBa5z/QMr76efnubPb0F+vfJsUWOeX7f8PDw8PDw
8PDw8Kbnma9YdV+vGl8/c+Ro9tQIQ9yf036nmyZb1dzlNM/xb+1YR3k9a/8OOfFlyp+/WC/sitVhL2XBw8PDw8PDw8PDuyevHyGK8Y2u90MzkOb6xWUdRX5JjvczxwjqdY2+1zDean+oGTTXHVZ53oSrDEeO97W9
eHh4eHh4eHh4eLfw/KPCofgytPQjR9f22kbE2cq0xr/pT0BsrsTsP9fxNvXL3UuTdZzO9uLh4eHh4eHh4eG9vydjlDZmHPZeI8iiGSEYXz//rKOfF1Pw8PDw8PDw8PDw8PDwcvbauHE+848dfUqe24uHh4eHh4eH
h4eHh4cX7oVlHae/vXh4eHh4eHh4eHh4eHihpck3hl2x6i45by8eHh4eHh4eHh4eHh5euLetrtNg5Hgv24uHh4eHh4eHh4eHh4cX7sXcJ8flpSx4eHh4eHh4eHh4eHh4OXjDkeN9bS8eHh4eHh4eHh4eHh5euJcm
6zid7cXDw8PDw8PDw8PDw8MLLWrk2J/a++ekmfDw8G7nLQ7mKZf64eFl7yn3Bsiyfnh446Yfn/BM6/fenuMbn0X9puQFteUdbO8H8IpV8aPMZ789fi2/zWfzmfj/0+P3clkUj9+fl7tt/ffTL88vi8fq4V+PXz7/
48NjVTz8x89P3x/q/738fL6+Wv+jfHn49en5+aE6P5yevn99Lv96Pj18Pv/l5eHly3W+33/59Kn8fPpdZ01/e/z6+aWe6fGyePzv/7J7fCmr3/72+Pf1q/X/nv/zuXp+qf9Rv/n189Pn0/nzS3Fd4i8vlZj9t98e
L0//sNoWj89Pu2VhqvbDH778Uj2f/+H3z0/HPz9ca/pa5cvT+fkkKvfl61m+/Hd/Oj+fjy/Xt/+u3ory+ctPr9U11fPfn376+eXBAR+fz+W36+tP9euP1WAbN2308L/KT2fRzv/YaWnx6sOXy/Xf/3b+/MuP2a+t
X8/0o+Hlmupd1szxP58+G0D13e4uPP/lfPzlpd6Dv/782jidFdbLy7Y6Z7A/68rIJtd25Gt1f+zLh3+9PJSfH/74v/+obkGnKa5tLP5x3ZVNc/zy9VSKOZ+ujf/Xh/Lb+eHzl5eH8vnbuTz99eH7+eV3Pt+gP52/
nr+VL1++/cv58uXb6x75g9xrD2XN1MuKtx+q+oNTXee51q6/A37s3x/gP19ezt/cXilmcXHa39/ms//2/wF7tNep6jIKAA==
"@
#endregion

#endregion ******** MyDM Custom Code ********

#region ******** $MyDMForm ********

#region $MyDMFolderBrowserDialog = System.Windows.Forms.FolderBrowserDialog
Write-Verbose -Message "Creating Form Control `$MyDMFolderBrowserDialog"
$MyDMFolderBrowserDialog = New-Object -TypeName System.Windows.Forms.FolderBrowserDialog
$MyDMFolderBrowserDialog.Description = "Export Desktop Menu"
$MyDMFolderBrowserDialog.SelectedPath = $MyDMConfig.ScriptPath
$MyDMFolderBrowserDialog.ShowNewFolderButton = $True
#endregion

$MyDMFormComponents = New-Object -TypeName System.ComponentModel.Container

#region $MyDMToolTip = System.Windows.Forms.ToolTip
Write-Verbose -Message "Creating Form Control `$MyDMToolTip"
$MyDMToolTip = New-Object -TypeName System.Windows.Forms.ToolTip($MyDMFormComponents)
$MyDMToolTip.Active = $False
#$MyDMToolTip.AutomaticDelay = 500
#$MyDMToolTip.AutoPopDelay = 5000
#$MyDMToolTip.BackColor = [System.Drawing.SystemColors]::Info
#$MyDMToolTip.ForeColor = [System.Drawing.SystemColors]::InfoText
#$MyDMToolTip.InitialDelay = 500
#$MyDMToolTip.IsBalloon = $False
#$MyDMToolTip.OwnerDraw = $False
#$MyDMToolTip.ReshowDelay = 100
#$MyDMToolTip.ShowAlways = $False
#$MyDMToolTip.Site = System.ComponentModel.ISite
#$MyDMToolTip.StripAmpersands = $False
#$MyDMToolTip.Tag = $Null
#$MyDMToolTip.ToolTipIcon = [System.Windows.Forms.ToolTipIcon]::None
$MyDMToolTip.ToolTipTitle = "$($MyDMConfig.ScriptName) - $($MyDMConfig.ScriptVersion)"
#endregion
#$MyDMToolTip.SetToolTip($FormControl, "Form Control Help")

#region $MyDMForm = System.Windows.Forms.Form
Write-Verbose -Message "Creating Form Control `$MyDMForm"
$MyDMForm = New-Object -TypeName System.Windows.Forms.Form
$MyDMForm.BackColor = $MyDMColor.BackColor
$MyDMForm.Font = $MyDMConfig.FontData.Regular
$MyDMForm.ForeColor = $MyDMColor.ForeColor
$MyDMForm.Icon = [System.Drawing.Icon]([System.Convert]::FromBase64String(($MyDMFormICO)))
$MyDMForm.KeyPreview = $True
$MyDMForm.MinimumSize = New-Object -TypeName System.Drawing.Size(800, 400)
$MyDMForm.Name = "MyDMForm"
$MyDMForm.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen
$MyDMForm.Tag = (-not $MyDMConfig.Production)
$MyDMForm.Text = "$($MyDMConfig.ScriptName) - $($MyDMConfig.ScriptVersion)"
#endregion
$MyDMToolTip.SetToolTip($MyDMForm, "Help for Control $($MyDMForm.Name)")

#region function Start-MyDMFormClosing
function Start-MyDMFormClosing()
{
  <#
    .SYNOPSIS
      Closing event for the MyDMForm Control
    .DESCRIPTION
      Closing event for the MyDMForm Control
    .PARAMETER Sender
       The Form Control that fired the Event
    .PARAMETER EventArg
       The Event Arguments for the Event
    .EXAMPLE
       Start-MyDMFormClosing -Sender $Sender -EventArg $EventArg
    .NOTES
      Original Function By Ken Sweet
    .LINK
  #>
  [CmdletBinding()]
  param (
    [parameter(Mandatory = $True)]
    [Object]$Sender,
    [parameter(Mandatory = $True)]
    [Object]$EventArg
  )
  Write-Verbose -Message "Enter Closing Event for `$MyDMForm"
  Try
  {
    #$MyDMForm.Cursor = [System.Windows.Forms.Cursors]::WaitCursor
    # Show Console Window
    $Script:VerbosePreference = "SilentlyContinue"
    $Script:DebugPreference = "Continue"
    
    [Void]$MyDMConfig.Registry.Close()
    
    [Void][Window.Display]::Show()
    $MyDMForm.Tag = $True
    #$MyDMForm.Cursor = [System.Windows.Forms.Cursors]::Arrow

    [System.GC]::Collect()
    [System.GC]::WaitForPendingFinalizers()
  }
  Catch
  {
    Write-Debug -Message "ErrMsg: $($Error[0].Exception.Message)"
    Write-Debug -Message "Line: $($Error[0].InvocationInfo.ScriptLineNumber)"
    Write-Debug -Message "Code: $(($Error[0].InvocationInfo.Line).Trim())"
  }
  Write-Verbose -Message "Exit Closing Event for `$MyDMForm"
}
#endregion function Start-MyDMFormClosing
$MyDMForm.add_Closing({Start-MyDMFormClosing -Sender $This -EventArg $PSItem})

#region function Start-MyDMFormKeyDown
function Start-MyDMFormKeyDown()
{
  <#
    .SYNOPSIS
      KeyDown event for the MyDMForm Control
    .DESCRIPTION
      KeyDown event for the MyDMForm Control
    .PARAMETER Sender
       The Form Control that fired the Event
    .PARAMETER EventArg
       The Event Arguments for the Event
    .EXAMPLE
       Start-MyDMFormKeyDown -Sender $Sender -EventArg $EventArg
    .NOTES
      Original Function By Ken Sweet
    .LINK
  #>
  [CmdletBinding()]
  param (
    [parameter(Mandatory = $True)]
    [Object]$Sender,
    [parameter(Mandatory = $True)]
    [Object]$EventArg
  )
  Write-Verbose -Message "Enter KeyDown Event for `$MyDMForm"
  Try
  {
    #$MyDMForm.Cursor = [System.Windows.Forms.Cursors]::WaitCursor
    if ($EventArg.Control -and $EventArg.Alt -and $EventArg.KeyCode -eq [System.Windows.Forms.Keys]::F10)
    {
      if ($MyDMForm.Tag)
      {
        # Hide Console Window
        $Script:VerbosePreference = "SilentlyContinue"
        $Script:DebugPreference = "SilentlyContinue"
        [Void][Window.Display]::Hide()
        $MyDMForm.Tag = $False
      }
      else
      {
        # Show Console Window
        $Script:VerbosePreference = "Continue"
        $Script:DebugPreference = "Continue"
        [Void][Window.Display]::Show()
        [System.Console]::Title = "DEBUG: $($MyDMConfig.ScriptName)"
        $MyDMForm.Tag = $True
      }
      $MyDMForm.Activate()
      $MyDMForm.Select()
    }
    elseif ($EventArg.KeyCode -eq [System.Windows.Forms.Keys]::F1)
    {
      $MyDMToolTip.Active = (-not $MyDMToolTip.Active)
    }
    #$MyDMForm.Cursor = [System.Windows.Forms.Cursors]::Arrow

    [System.GC]::Collect()
    [System.GC]::WaitForPendingFinalizers()
  }
  Catch
  {
    Write-Debug -Message "ErrMsg: $($Error[0].Exception.Message)"
    Write-Debug -Message "Line: $($Error[0].InvocationInfo.ScriptLineNumber)"
    Write-Debug -Message "Code: $(($Error[0].InvocationInfo.Line).Trim())"
  }
  Write-Verbose -Message "Exit KeyDown Event for `$MyDMForm"
}
#endregion function Start-MyDMFormKeyDown
$MyDMForm.add_KeyDown({Start-MyDMFormKeyDown -Sender $This -EventArg $PSItem})

#region function Start-MyDMFormLoad
function Start-MyDMFormLoad()
{
  <#
    .SYNOPSIS
      Load event for the MyDMForm Control
    .DESCRIPTION
      Load event for the MyDMForm Control
    .PARAMETER Sender
       The Form Control that fired the Event
    .PARAMETER EventArg
       The Event Arguments for the Event
    .EXAMPLE
       Start-MyDMFormLoad -Sender $Sender -EventArg $EventArg
    .NOTES
      Original Function By Ken Sweet
    .LINK
  #>
  [CmdletBinding()]
  param (
    [parameter(Mandatory = $True)]
    [Object]$Sender,
    [parameter(Mandatory = $True)]
    [Object]$EventArg
  )
  Write-Verbose -Message "Enter Load Event for `$MyDMForm"
  Try
  {
    #$MyDMForm.Cursor = [System.Windows.Forms.Cursors]::WaitCursor

    $Screen = ([System.Windows.Forms.Screen]::FromControl($Sender)).WorkingArea
    $Sender.Left = [Math]::Floor(($Screen.Width - $Sender.Width) / 2)
    $Sender.Top = [Math]::Floor(($Screen.Height - $Sender.Height) / 2)

    if ($MyDMConfig.Production)
    {
      # Hide Console Window
      $Script:VerbosePreference = "SilentlyContinue"
      $Script:DebugPreference = "SilentlyContinue"
      [Void][Window.Display]::Hide()
      $MyDMForm.Tag = $False
    }
    else
    {
      $MyDMForm.Tag = $True
    }
    #$MyDMForm.Cursor = [System.Windows.Forms.Cursors]::Arrow

    [System.GC]::Collect()
    [System.GC]::WaitForPendingFinalizers()
  }
  Catch
  {
    Write-Debug -Message "ErrMsg: $($Error[0].Exception.Message)"
    Write-Debug -Message "Line: $($Error[0].InvocationInfo.ScriptLineNumber)"
    Write-Debug -Message "Code: $(($Error[0].InvocationInfo.Line).Trim())"
  }
  Write-Verbose -Message "Exit Load Event for `$MyDMForm"
}
#endregion function Start-MyDMFormLoad
$MyDMForm.add_Load({Start-MyDMFormLoad -Sender $This -EventArg $PSItem})

#region function Start-MyDMFormShown
function Start-MyDMFormShown()
{
  <#
    .SYNOPSIS
      Shown event for the MyDMForm Control
    .DESCRIPTION
      Shown event for the MyDMForm Control
    .PARAMETER Sender
       The Form Control that fired the Event
    .PARAMETER EventArg
       The Event Arguments for the Event
    .EXAMPLE
       Start-MyDMFormShown -Sender $Sender -EventArg $EventArg
    .NOTES
      Original Function By Ken Sweet
    .LINK
  #>
  [CmdletBinding()]
  param (
    [parameter(Mandatory = $True)]
    [Object]$Sender,
    [parameter(Mandatory = $True)]
    [Object]$EventArg
  )
  Write-Verbose -Message "Enter Shown Event for `$MyDMForm"
  Try
  {
    $MyDMForm.Cursor = [System.Windows.Forms.Cursors]::WaitCursor
    $Sender.Refresh()
    
    # Load Default Icon
    $MyDMConfig.DefaultIconSmall = [Extract.MyIcon]::IconReturn($MyDMConfig.DefaultIconPath, $MyDMConfig.DefaultIconIndex, $False)
    
    if ($MyDMConfig.EditRegistry)
    {
      if ($MyDMConfig.EnableUser)
      {
        $MyDMStatusStrip.Items["Status"].Text = "Connectiong to Local Registry..."
        $Sender.Refresh()
        $MyDMConfig.Registry = [MyWMIRegistry]::New()
      }
      else
      {
        $MyDMStatusStrip.Items["Status"].Text = "Connectiong to Remote Registry..."
        $Sender.Refresh()
        $MyDMConfig.Registry = [MyWMIRegistry]::New($ComputerName, $MyDMConfig.Credential)
      }
    }
    else
    {
      $MyDMConfig.Registry = @{ "Connect" = $True }
    }
    
    $TempCount = 0
    
    Verify-MyWorkstation
    
    If ($MyDMConfig.Registry.Connect)
    {
      #region ******** Load User Desktop Menus ********
      if ($MyDMConfig.EnableUser)
      {
        $MyDMStatusStrip.Items["Status"].Text = "Loading User Desktop Menus..."
        $Sender.Refresh()
        $TempHive = "HKCU"
        if ($MyDMConfig.EditRegistry)
        {
          # *****************************
          # Create User Desktop Menu List
          # *****************************
          $TempAccess = $MyDMConfig.Registry.CheckAccess($TempHive, $MyDMConfig.RegistryMenuList, [RegRights]($MyDMConfig.RegistryRights))
          if ($TempAccess.Failure -eq 2)
          {
            if (($MyDMConfig.Registry.CheckAccess($TempHive, "Software", [RegRights]("KEY_CREATE_SUB_KEY"))).Granted)
            {
              if (($MyDMConfig.Registry.CreateKey($TempHive, "Software", $MyDMConfig.ScriptName)).Failue)
              {
                [Void]([System.Windows.Forms.MessageBox]::Show($MyDMForm, "Unable to Edit User Registry.", "Error: $ComputerName", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error))
              }
              else
              {
                $TempAccess = $MyDMConfig.Registry.CheckAccess($TempHive, $MyDMConfig.RegistryMenuList, [RegRights]($MyDMConfig.RegistryRights))
              }
            }
          }
          
          if ($TempAccess.Granted)
          {
            $CurTreeNode = New-TreeNode -PassThru -TreeNode $MyDMMidMenuTreeView -Text "User Desktop Menus" -Tag $TempHive -ImageKey "MyDM-UserIcon" -Expand
            
            If (($TempMenuList = $MyDMConfig.Registry.EnumValues($TempHive, $MyDMConfig.RegistryMenuList)).Failure)
            {
              [Void]([System.Windows.Forms.MessageBox]::Show($MyDMForm, "Unable to Read User Registry.", "Error: $ComputerName", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error))
            }
            else
            {
              $TempCount += @($TempMenuList.Values).Count
              # **********************
              # Add User Desktop Menus
              # **********************
              $CheckValue = 0
              ForEach ($TempMenu in $TempMenuList.Values)
              {
                $TempMenuID = $TempMenu.Name
                $TempMenuName = "Unknown Menu"
                $TempIconPath = ""
                $TempIndex = -1
                
                $CheckValue = $CheckValue -bor ($Data = $MyDMConfig.Registry.GetStringValue($TempHive, $MyDMConfig.RegistryMenuList, $TempMenuID)).Failure
                if ($Data.Failure -eq 0)
                {
                  $TempMenuName = $Data.Value
                }
                $MyDMStatusStrip.Items["Status"].Text = "Loading User Menu - $TempMenuName"
                $Sender.Refresh()
                
                $CheckValue = $CheckValue -bor ($Data = $MyDMConfig.Registry.GetStringValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\DefaultIcon", "")).Failure
                $TempArray = $Data.Value.Split(",", [System.StringSplitOptions]::RemoveEmptyEntries)
                Switch ($TempArray.Count)
                {
                  1
                  {
                    $TempIconPath = $TempArray[0]
                    $TempIndex = 0
                    Break
                  }
                  2
                  {
                    $TempIconPath = $TempArray[0]
                    $TempIndex = $TempArray[1]
                    Break
                  }
                }
                
                $NewMenu = [MyDesktopMenu]::New($TempMenuID, $TempMenuName, $TempIconPath, $TempIndex)
                if ([System.IO.File]::Exists($TempIconPath))
                {
                  $TempIconSmall = [Extract.MyIcon]::IconReturn($TempIconPath, $TempIndex, $False)
                }
                else
                {
                  $TempIconSmall = $MyDMImageList.Images[0]
                }
                $MyDMImageList.Images.Add($TempMenuID, $TempIconSmall)
                New-TreeNode -TreeNode $CurTreeNode -Text $TempMenuName -Tag $NewMenu -ImageKey $TempMenuID
                
                # ******************************
                # Add User Desktop Menu Commands
                # ******************************
                $TempCmdArray = [System.Collections.ArrayList]::New()
                $CheckValue = $CheckValue -bor ($TempCmdList = $MyDMConfig.Registry.EnumKey($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell")).Failure
                ForEach ($Key in $TempCmdList.Value)
                {
                  $TempCmdName = "Unknown Command"
                  $TempCmdLine = "C:\Windows\System32\cmd.exe"
                  $TempCmdIconPath = ""
                  $TempCmdIndex = -1
                  $TempCmdSeparatorBefore = $MyDMConfig.SeparatorNo
                  $TempCmdSeparatorAfter = $MyDMConfig.SeparatorNo
                  $TempCmdCommandFlags = 0x0
                  
                  $CheckValue = $CheckValue -bor ($TempCmdData = $MyDMConfig.Registry.EnumValues($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$Key")).Failure
                  ForEach ($ValueName in $TempCmdData.Values)
                  {
                    Switch ($ValueName.Name)
                    {
                      "Icon"
                      {
                        $CheckValue = $CheckValue -bor ($Data = $MyDMConfig.Registry.GetStringValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$Key", "Icon")).Failure
                        $TempArray = $Data.Value.Split(",", [System.StringSplitOptions]::RemoveEmptyEntries)
                        Switch ($TempArray.Count)
                        {
                          1
                          {
                            $TempCmdIconPath = $TempArray[0]
                            $TempCmdIndex = 0
                            Break
                          }
                          2
                          {
                            $TempCmdIconPath = $TempArray[0]
                            $TempCmdIndex = $TempArray[1]
                            Break
                          }
                        }
                        Break
                      }
                      "MUIVerb"
                      {
                        $CheckValue = $CheckValue -bor ($Data = $MyDMConfig.Registry.GetStringValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$Key", "MUIVerb")).Failure
                        if ($Data.Failure -eq 0)
                        {
                          $TempCmdName = $Data.Value
                        }
                        Break
                      }
                      "SeparatorBefore"
                      {
                        $TempCmdCommandFlags = $TempCmdCommandFlags -bor $MyDMConfig.SeparatorBefore
                        $TempCmdSeparatorBefore = $MyDMConfig.SeparatorYes
                        Break
                      }
                      "SeparatorAfter"
                      {
                        $TempCmdCommandFlags = $TempCmdCommandFlags -bor $MyDMConfig.SeparatorAfter
                        $TempCmdSeparatorAfter = $MyDMConfig.SeparatorYes
                        Break
                      }
                    }
                  }
                  
                  $CheckValue = $CheckValue -bor ($Data = $MyDMConfig.Registry.GetStringValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$Key\Command", "")).Failure
                  if ($Data.Failure -eq 0)
                  {
                    $TempCmdLine = $Data.Value
                  }
                  
                  $NewCmd = [MyMenuCommand]::New($TempCmdName, $TempCmdLine, $TempCmdCommandFlags, $TempCmdIconPath, $TempCmdIndex)
                  if ([System.IO.File]::Exists($TempCmdIconPath))
                  {
                    $TempIconSmall = [Extract.MyIcon]::IconReturn($TempCmdIconPath, $TempCmdIndex, $False)
                  }
                  else
                  {
                    $TempIconSmall = $MyDMImageList.Images[0]
                  }
                  $MyDMImageList.Images.Add($NewCmd.ID, $TempIconSmall)
                  
                  [Void]$TempCmdArray.Add((New-ListViewItem -PassThru -ListView $MyDMMidCmdsListView -Text $TempCmdName -SubItems @($TempCmdLine, $TempCmdIconPath, $TempCmdIndex, $TempCmdSeparatorBefore, $TempCmdSeparatorAfter) -Tag $NewCmd -ImageKey $NewCmd.ID))
                }
                
                $NewMenu.Command = $TempCmdArray.ToArray()
              }
              
              $CurTreeNode.Expand()
              
              if ($CheckValue)
              {
                [Void]([System.Windows.Forms.MessageBox]::Show($MyDMForm, "Error Loading User Menus. - $CheckValue", "Error: $ComputerName", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error))
              }
            }
          }
          else
          {
            [Void]([System.Windows.Forms.MessageBox]::Show($MyDMForm, "Unable to Open User Registry.", "Error: $ComputerName", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error))
          }
        }
        else
        {
          New-TreeNode -TreeNode $MyDMMidMenuTreeView -Text "User Desktop Menus" -Tag $TempHive -ImageKey "MyDM-UserIcon" -Expand
        }
      }
      #endregion ******** Load User Desktop Menus ********
      
      #region ******** Load System Desktop Menus ********
      if ($MyDMConfig.EnableSystem)
      {
        $MyDMStatusStrip.Items["Status"].Text = "Loading System Desktop Menus..."
        $Sender.Refresh()
        $TempHive = "HKLM"
        if ($MyDMConfig.EditRegistry)
        {
          $TempAccess = $MyDMConfig.Registry.CheckAccess($TempHive, $MyDMConfig.RegistryMenuList, [RegRights]($MyDMConfig.RegistryRights))
          # *******************************
          # Create System Desktop Menu List
          # *******************************
          if ($TempAccess.Failure -eq 2)
          {
            if (($MyDMConfig.Registry.CheckAccess($TempHive, "Software", [RegRights]("KEY_CREATE_SUB_KEY"))).Granted)
            {
              if (($MyDMConfig.Registry.CreateKey($TempHive, "Software", $MyDMConfig.ScriptName)).Failue)
              {
                [Void]([System.Windows.Forms.MessageBox]::Show($MyDMForm, "Unable to Edit System Registry.", "Error: $ComputerName", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error))
              }
              else
              {
                $TempAccess = $MyDMConfig.Registry.CheckAccess($TempHive, $MyDMConfig.RegistryMenuList, [RegRights]($MyDMConfig.RegistryRights))
              }
            }
          }
          
          if ($TempAccess.Granted)
          {
            $CurTreeNode = New-TreeNode -PassThru -TreeNode $MyDMMidMenuTreeView -Text "System Desktop Menus" -Tag $TempHive -ImageKey "MyDM-SystemIcon" -Expand
            
            If (($TempMenuList = $MyDMConfig.Registry.EnumValues($TempHive, $MyDMConfig.RegistryMenuList)).Failure)
            {
              [Void]([System.Windows.Forms.MessageBox]::Show($MyDMForm, "Unable to Read System Registry.", "Error: $ComputerName", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error))
            }
            else
            {
              $TempCount += @($TempMenuList.Values).Count
              # ************************
              # Add System Desktop Menus
              # ************************
              $CheckValue = 0
              ForEach ($TempMenu in $TempMenuList.Values)
              {
                $TempMenuID = $TempMenu.Name
                $TempMenuName = "Unknown Menu"
                $TempIconPath = ""
                $TempIndex = -1
                
                $CheckValue = $CheckValue -bor ($Data = $MyDMConfig.Registry.GetStringValue($TempHive, $MyDMConfig.RegistryMenuList, $TempMenuID)).Failure
                if ($Data.Failure -eq 0)
                {
                  $TempMenuName = $Data.Value
                }
                $MyDMStatusStrip.Items["Status"].Text = "Loading System Menu - $TempMenuName"
                $Sender.Refresh()
                
                $CheckValue = $CheckValue -bor ($Data = $MyDMConfig.Registry.GetStringValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\DefaultIcon", "")).Failure
                $TempArray = $Data.Value.Split(",", [System.StringSplitOptions]::RemoveEmptyEntries)
                Switch ($TempArray.Count)
                {
                  1
                  {
                    $TempIconPath = $TempArray[0]
                    $TempIndex = 0
                    Break
                  }
                  2
                  {
                    $TempIconPath = $TempArray[0]
                    $TempIndex = $TempArray[1]
                    Break
                  }
                }
                
                $NewMenu = [MyDesktopMenu]::New($TempMenuID, $TempMenuName, $TempIconPath, $TempIndex)
                if ([System.IO.File]::Exists($TempIconPath))
                {
                  $TempIconSmall = [Extract.MyIcon]::IconReturn($TempIconPath, $TempIndex, $False)
                }
                else
                {
                  $TempIconSmall = $MyDMImageList.Images[0]
                }
                $MyDMImageList.Images.Add($TempMenuID, $TempIconSmall)
                $MenuNode = New-TreeNode -PassThru -TreeNode $CurTreeNode -Text $TempMenuName -Tag $NewMenu -ImageKey $TempMenuID
                
                # ********************************
                # Add System Desktop Menu Commands
                # ********************************
                $TempCmdArray = [System.Collections.ArrayList]::New()
                $CheckValue = $CheckValue -bor ($TempCmdList = $MyDMConfig.Registry.EnumKey($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell")).Failure
                ForEach ($Key in @($TempCmdList.Value | Where-Object -FilterScript { $PSItem -match "XCmd" }))
                {
                  $TempCmdName = "Unknown Command"
                  $TempCmdLine = "C:\Windows\System32\cmd.exe"
                  $TempIconPath = ""
                  $TempIndex = -1
                  $TempSeparatorBefore = $MyDMConfig.SeparatorNo
                  $TempSeparatorAfter = $MyDMConfig.SeparatorNo
                  $TempCommandFlags = 0x0
                  
                  $CheckValue = $CheckValue -bor ($TempCmdData = $MyDMConfig.Registry.EnumValues($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$Key")).Failure
                  ForEach ($ValueName in $TempCmdData.Values)
                  {
                    Switch ($ValueName.Name)
                    {
                      "Icon"
                      {
                        $CheckValue = $CheckValue -bor ($Data = $MyDMConfig.Registry.GetStringValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$Key", "Icon")).Failure
                        $TempArray = $Data.Value.Split(",", [System.StringSplitOptions]::RemoveEmptyEntries)
                        Switch ($TempArray.Count)
                        {
                          1
                          {
                            $TempIconPath = $TempArray[0]
                            $TempIndex = 0
                            Break
                          }
                          2
                          {
                            $TempIconPath = $TempArray[0]
                            $TempIndex = $TempArray[1]
                            Break
                          }
                        }
                        Break
                      }
                      "MUIVerb"
                      {
                        $CheckValue = $CheckValue -bor ($Data = $MyDMConfig.Registry.GetStringValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$Key", "MUIVerb")).Failure
                        if ($Data.Failure -eq 0)
                        {
                          $TempCmdName = $Data.Value
                        }
                        Break
                      }
                      "SeparatorBefore"
                      {
                        $TempCommandFlags = $TempCommandFlags -bor $MyDMConfig.SeparatorBefore
                        $TempSeparatorBefore = $MyDMConfig.SeparatorYes
                        Break
                      }
                      "SeparatorAfter"
                      {
                        $TempCommandFlags = $TempCommandFlags -bor $MyDMConfig.SeparatorAfter
                        $TempSeparatorAfter = $MyDMConfig.SeparatorYes
                        Break
                      }
                    }
                  }
                  
                  $CheckValue = $CheckValue -bor ($Data = $MyDMConfig.Registry.GetStringValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$Key\Command", "")).Failure
                  if ($Data.Failure -eq 0)
                  {
                    $TempCmdLine = $Data.Value
                  }
                  
                  $NewCmd = [MyMenuCommand]::New($TempCmdName, $TempCmdLine, $TempCommandFlags, $TempIconPath, $TempIndex)
                  if ([System.IO.File]::Exists($TempIconPath))
                  {
                    $TempIconSmall = [Extract.MyIcon]::IconReturn($TempIconPath, $TempIndex, $False)
                  }
                  else
                  {
                    $TempIconSmall = $MyDMImageList.Images[0]
                  }
                  $MyDMImageList.Images.Add($NewCmd.ID, $TempIconSmall)
                  
                  [Void]$TempCmdArray.Add((New-ListViewItem -PassThru -ListView $MyDMMidCmdsListView -Text $TempCmdName -SubItems @($TempCmdLine, $TempIconPath, $TempIndex, $TempSeparatorBefore, $TempSeparatorAfter) -Tag $NewCmd -ImageKey $NewCmd.ID))
                }
                
                $NewMenu.Command = $TempCmdArray.ToArray()
                
                # ****************************
                # Add System Desktop Sub Menus
                # ****************************
                ForEach ($Key in @($TempCmdList.Value | Where-Object -FilterScript { $PSItem -match "Menu" }))
                {
                  $TempSubID = "{$([Guid]::NewGuid().Guid)}".ToUpper()
                  $TempSubName = "Unknown Sub Menu"
                  $TempSubCommands = ""
                  $TempIconPath = ""
                  $TempIndex = -1
                  $TempCommandFlags = 0x0
                  
                  $CheckValue = $CheckValue -bor ($TempCmdData = $MyDMConfig.Registry.EnumValues($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$Key")).Failure
                  ForEach ($ValueName in $TempCmdData.Values)
                  {
                    Switch ($ValueName.Name)
                    {
                      "Icon"
                      {
                        $CheckValue = $CheckValue -bor ($Data = $MyDMConfig.Registry.GetStringValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$Key", "Icon")).Failure
                        $TempArray = $Data.Value.Split(",", [System.StringSplitOptions]::RemoveEmptyEntries)
                        Switch ($TempArray.Count)
                        {
                          1
                          {
                            $TempIconPath = $TempArray[0]
                            $TempIndex = 0
                            Break
                          }
                          2
                          {
                            $TempIconPath = $TempArray[0]
                            $TempIndex = $TempArray[1]
                            Break
                          }
                        }
                        Break
                      }
                      "ID"
                      {
                        $CheckValue = $CheckValue -bor ($Data = $MyDMConfig.Registry.GetStringValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$Key", "ID")).Failure
                        if ($Data.Failure -eq 0)
                        {
                          $TempSubID = $Data.Value
                        }
                        Break
                      }
                      "MUIVerb"
                      {
                        $CheckValue = $CheckValue -bor ($Data = $MyDMConfig.Registry.GetStringValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$Key", "MUIVerb")).Failure
                        if ($Data.Failure -eq 0)
                        {
                          $TempSubName = $Data.Value
                        }
                        Break
                      }
                      "SubCommands"
                      {
                        $CheckValue = $CheckValue -bor ($Data = $MyDMConfig.Registry.GetStringValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$Key", "SubCommands")).Failure
                        if ($Data.Failure -eq 0)
                        {
                          $TempSubCommands = $Data.Value
                          
                          $TempSubCmdArray = [System.Collections.ArrayList]::New()
                          $TempSubCmdList = $TempSubCommands.Split(";", [System.StringSplitOptions]::RemoveEmptyEntries)
                          ForEach ($SubKey in $TempSubCmdList)
                          {
                            # **********************************
                            # Add Desktop Menu Sub Menu Commands
                            # **********************************
                            $TempSubCmdName = "Unknown Command"
                            $TempSubCmdLine = "C:\Windows\System32\cmd.exe"
                            $TempSubIconPath = ""
                            $TempSubIndex = -1
                            $TempSubSeparatorBefore = $MyDMConfig.SeparatorNo
                            $TempSubSeparatorAfter = $MyDMConfig.SeparatorNo
                            $TempSubCommandFlags = 0x0
                            
                            $CheckValue = $CheckValue -bor ($TempCmdData = $MyDMConfig.Registry.EnumValues($TempHive, "$($MyDMConfig.RegistrySubMenuCmds)\$SubKey")).Failure
                            ForEach ($ValueName in $TempCmdData.Values)
                            {
                              Switch ($ValueName.Name)
                              {
                                "Icon"
                                {
                                  $CheckValue = $CheckValue -bor ($Data = $MyDMConfig.Registry.GetStringValue($TempHive, "$($MyDMConfig.RegistrySubMenuCmds)\$SubKey", "Icon")).Failure
                                  $TempArray = $Data.Value.Split(",", [System.StringSplitOptions]::RemoveEmptyEntries)
                                  Switch ($TempArray.Count)
                                  {
                                    1
                                    {
                                      $TempSubIconPath = $TempArray[0]
                                      $TempSubIndex = 0
                                      Break
                                    }
                                    2
                                    {
                                      $TempSubIconPath = $TempArray[0]
                                      $TempSubIndex = $TempArray[1]
                                      Break
                                    }
                                  }
                                  Break
                                }
                                "MUIVerb"
                                {
                                  $CheckValue = $CheckValue -bor ($Data = $MyDMConfig.Registry.GetStringValue($TempHive, "$($MyDMConfig.RegistrySubMenuCmds)\$SubKey", "MUIVerb")).Failure
                                  if ($Data.Failure -eq 0)
                                  {
                                    $TempSubCmdName = $Data.Value
                                  }
                                  Break
                                }
                                "CommandFlags"
                                {
                                  $CheckValue = $CheckValue -bor ($Data = $MyDMConfig.Registry.GetDWordValue($TempHive, "$($MyDMConfig.RegistrySubMenuCmds)\$SubKey", "CommandFlags")).Failure
                                  if ($Data.Failure -eq 0)
                                  {
                                    Switch ($Data.Value)
                                    {
                                      {
                                        $PSItem -band $MyDMConfig.SeparatorBefore
                                      }
                                      {
                                        $TempSubCommandFlags = $TempSubCommandFlags -bor $MyDMConfig.SeparatorBefore
                                        $TempSubSeparatorBefore = $MyDMConfig.SeparatorYes
                                      }
                                      {
                                        $PSItem -band $MyDMConfig.SeparatorAfter
                                      }
                                      {
                                        $TempSubCommandFlags = $TempSubCommandFlags -bor $MyDMConfig.SeparatorAfter
                                        $TempSubSeparatorAfter = $MyDMConfig.SeparatorYes
                                      }
                                    }
                                  }
                                  Break
                                }
                              }
                            }
                            
                            $CheckValue = $CheckValue -bor ($Data = $MyDMConfig.Registry.GetStringValue($TempHive, "$($MyDMConfig.RegistrySubMenuCmds)\$SubKey\Command", "")).Failure
                            if ($Data.Failure -eq 0)
                            {
                              $TempSubCmdLine = $Data.Value
                            }
                            
                            $NewSubCmd = [MyMenuCommand]::New($TempSubCmdName, $TempSubCmdLine, $TempSubCommandFlags, $TempSubIconPath, $TempSubIndex)
                            if ([System.IO.File]::Exists($TempSubIconPath))
                            {
                              $TempSubIconSmall = [Extract.MyIcon]::IconReturn($TempSubIconPath, $TempSubIndex, $False)
                            }
                            else
                            {
                              $TempSubIconSmall = $MyDMImageList.Images[0]
                            }
                            $MyDMImageList.Images.Add($NewSubCmd.ID, $TempSubIconSmall)
                            
                            [Void]$TempSubCmdArray.Add((New-ListViewItem -PassThru -ListView $MyDMMidCmdsListView -Text $TempSubCmdName -SubItems @($TempSubCmdLine, $TempSubIconPath, $TempSubIndex, $TempSubSeparatorBefore, $TempSubSeparatorAfter) -Tag $NewSubCmd -ImageKey $NewSubCmd.ID))
                          }
                        }
                        Break
                      }
                      "SeparatorBefore"
                      {
                        $TempCommandFlags = $TempCommandFlags -bor $MyDMConfig.SeparatorBefore
                        $TempSeparatorBefore = $MyDMConfig.SeparatorYes
                        Break
                      }
                      "SeparatorAfter"
                      {
                        $TempCommandFlags = $TempCommandFlags -bor $MyDMConfig.SeparatorAfter
                        $TempSeparatorAfter = $MyDMConfig.SeparatorYes
                        Break
                      }
                    }
                  }
                  
                  $NewSubMenu = [MySubMenu]::New($TempSubID, $TempSubName, $TempSubCommands, $TempCommandFlags, $TempIconPath, $TempIndex)
                  
                  $NewSubMenu.Command = $TempSubCmdArray.ToArray()
                  
                  if ([System.IO.File]::Exists($TempIconPath))
                  {
                    $TempIconSmall = [Extract.MyIcon]::IconReturn($TempIconPath, $TempIndex, $False)
                  }
                  else
                  {
                    $TempIconSmall = $MyDMImageList.Images[0]
                  }
                  $MyDMImageList.Images.Add($TempSubID, $TempIconSmall)
                  
                  New-TreeNode -TreeNode $MenuNode -Text $TempSubName -Tag $NewSubMenu -ImageKey $TempSubID
                }
              }
              
              $CurTreeNode.ExpandAll()
              
              if ($CheckValue)
              {
                [Void]([System.Windows.Forms.MessageBox]::Show($MyDMForm, "Error Loading System Menus. - $CheckValue", "Error: $ComputerName", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error))
              }
            }
          }
          else
          {
            [Void]([System.Windows.Forms.MessageBox]::Show($MyDMForm, "Unable to Open System Registry.", "Error: $ComputerName", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error))
          }
        }
        else
        {
          New-TreeNode -TreeNode $MyDMMidMenuTreeView -Text "System Desktop Menus" -Tag $TempHive -ImageKey "MyDM-SystemIcon" -Expand
        }
      }
      #endregion ******** Load System Desktop Menus ********
    }
    else
    {
      [Void]([System.Windows.Forms.MessageBox]::Show($MyDMForm, "Unable to Connect to Registry.", "Error: $ComputerName", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error))
      $MyDMForm.Close()
      Return
    }
    
    $MyDMMidCmdsMenuStrip.Items["Help"].Enabled = $True
    $MyDMMidCmdsMenuStrip.Items["Exit"].Enabled = $True
    
    $MyDMStatusStrip.Items["Status"].Text = "loaded $TempCount Desktop Menus..."
    
    $MyDMForm.Cursor = [System.Windows.Forms.Cursors]::Arrow

    [System.GC]::Collect()
    [System.GC]::WaitForPendingFinalizers()
  }
  Catch
  {
    Write-Debug -Message "ErrMsg: $($Error[0].Exception.Message)"
    Write-Debug -Message "Line: $($Error[0].InvocationInfo.ScriptLineNumber)"
    Write-Debug -Message "Code: $(($Error[0].InvocationInfo.Line).Trim())"
  }
  Write-Verbose -Message "Exit Shown Event for `$MyDMForm"
}
#endregion function Start-MyDMFormShown
$MyDMForm.add_Shown({Start-MyDMFormShown -Sender $This -EventArg $PSItem})

#region ******** $MyDMForm Controls ********

#region $MyDMImageList = System.Windows.Forms.ImageList
Write-Verbose -Message "Creating Form Control `$MyDMImageList"
$MyDMImageList = New-Object -TypeName System.Windows.Forms.ImageList($MyDMFormComponents)
$MyDMImageList.ColorDepth = [System.Windows.Forms.ColorDepth]::Depth32Bit
$MyDMImageList.ImageSize = New-Object -TypeName System.Drawing.Size(16, 16)
#endregion

$MyDMImageList.Images.Add("MyDM-NoneIcon", [System.Drawing.Icon]([System.Convert]::FromBase64String($Noneico)))
$MyDMImageList.Images.Add("MyDM-UserIcon", [System.Drawing.Icon]([System.Convert]::FromBase64String($Userico)))
$MyDMImageList.Images.Add("MyDM-SystemIcon", [System.Drawing.Icon]([System.Convert]::FromBase64String($Systemico)))
$MyDMImageList.Images.Add("MyDM-NoneIcon", [System.Drawing.Icon]([System.Convert]::FromBase64String($Noneico)))

#region $MyDMMidSplitContainer = System.Windows.Forms.SplitContainer
Write-Verbose -Message "Creating Form Control `$MyDMMidSplitContainer"
$MyDMMidSplitContainer = New-Object -TypeName System.Windows.Forms.SplitContainer
$MyDMForm.Controls.Add($MyDMMidSplitContainer)
$MyDMMidSplitContainer.Dock = [System.Windows.Forms.DockStyle]::Fill
$MyDMMidSplitContainer.Name = "MyDMMidSplitContainer"
$MyDMMidSplitContainer.SplitterIncrement = 8
$MyDMMidSplitContainer.SplitterWidth = 4
$MyDMMidSplitContainer.Text = "MyDMMidSplitContainer"
#endregion

#region ******** $MyDMMidSplitContainer Panel1 Controls ********

#region $MyDMMidMenuMenuStrip = System.Windows.Forms.MenuStrip
Write-Verbose -Message "Creating Form Control `$MyDMMidMenuMenuStrip"
$MyDMMidMenuMenuStrip = New-Object -TypeName System.Windows.Forms.MenuStrip
$MyDMMidSplitContainer.Panel1.Controls.Add($MyDMMidMenuMenuStrip)
$MyDMMidMenuMenuStrip.BackColor = $MyDMColor.BackColor
$MyDMMidMenuMenuStrip.Dock = [System.Windows.Forms.DockStyle]::Top
$MyDMMidMenuMenuStrip.ForeColor = $MyDMColor.ForeColor
$MyDMMidMenuMenuStrip.Name = "MyDMMidMenuMenuStrip"
$MyDMMidMenuMenuStrip.Text = "MyDMMidMenuMenuStrip"
#endregion

#region ******** $MyDMMidMenuMenuStrip ToolStrip MenuItems ********

#region function Start-MyDMMidMenuToolStripButtonClick
function Start-MyDMMidMenuToolStripButtonClick()
{
  <#
    .SYNOPSIS
      Click event for the MyDMMidMenuToolStripButton Control
    .DESCRIPTION
      Click event for the MyDMMidMenuToolStripButton Control
    .PARAMETER Sender
       The Form Control that fired the Event
    .PARAMETER EventArg
       The Event Arguments for the Event
    .EXAMPLE
       Start-MyDMMidMenuToolStripButtonClick -Sender $Sender -EventArg $EventArg
    .NOTES
      Original Function By Ken Sweet
    .LINK
  #>
  [CmdletBinding()]
  param (
    [parameter(Mandatory = $True)]
    [Object]$Sender,
    [parameter(Mandatory = $True)]
    [Object]$EventArg
  )
  Write-Verbose -Message "Enter Click Event for `$MyDMMidMenuToolStripButton"
  Try
  {
    #$MyDMForm.Cursor = [System.Windows.Forms.Cursors]::WaitCursor
    switch ($Sender.Name)
    {
      "New"
      {
        if ($MyDMMidMenuTreeView.SelectedNode.Level -eq 1)
        {
          #region ******** Add New Desktop Sub Menu ********
          $MyDMStatusStrip.Items["Status"].Text = "Add New Desktop Menu Sub-Menu..."
          
          $BadNames = [System.Collections.ArrayList]::New()
          $BadNames.AddRange(@($MyDMMidMenuTreeView.SelectedNode.Nodes | Select-Object -ExpandProperty Name))
          
          if ((($Data = Show-MyDMEditDialog -SubMenu -BadNames $BadNames -IconPath "" -Index -1)).DialogResult -eq [System.Windows.Forms.DialogResult]::OK)
          {
            $TempCommandFlags = 0x0
            if ($Data.SeparatorBefore)
            {
              $TempCommandFlags = $TempCommandFlags -bor $MyDMConfig.SeparatorBefore
            }
            
            if ($Data.SeparatorAfter)
            {
              $TempCommandFlags = $TempCommandFlags -bor $MyDMConfig.SeparatorAfter
            }
            
            $NewSubMenu = [MySubMenu]::New($Data.ReturnVal01Text, $TempCommandFlags, $Data.IconPath, $Data.Index)
            
            if ($MyDMConfig.EditRegistry)
            {
              $TempHive = $MyDMMidMenuTreeView.SelectedNode.Parent.Tag
              $TempMenuID = $MyDMMidMenuTreeView.SelectedNode.Tag.ID
              
              $TempSubMenuName = ($MyDMConfig.PrefixMenu -f ($MyDMMidMenuTreeView.SelectedNode.Nodes).Count)
              
              $CheckValue = 0
              $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.CreateKey($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell", $TempSubMenuName)).Failure
              if ($Data.Index -ne -1)
              {
                $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetStringValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempSubMenuName", "Icon", "$($Data.IconPath),$($Data.Index)")).Failure
              }
              $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetStringValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempSubMenuName", "ID", $NewSubMenu.ID)).Failure
              $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetStringValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempSubMenuName", "MUIVerb", $Data.ReturnVal01Text)).Failure
              $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetStringValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempSubMenuName", "SubCommands", "")).Failure
              $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetDWordValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempSubMenuName", "CommandFlags", $TempCommandFlags)).Failure
              
              if ($Data.SeparatorBefore)
              {
                $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetStringValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempSubMenuName", "SeparatorBefore", $MyDMConfig.SeparatorYes)).Failure
              }
              
              if ($Data.SeparatorAfter)
              {
                $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetStringValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempSubMenuName", "SeparatorAfter", $MyDMConfig.SeparatorYes)).Failure
              }
              
              if ($CheckValue)
              {
                [Void]([System.Windows.Forms.MessageBox]::Show($MyDMForm, "Error Creating Desktop Sub Menu. - $CheckValue", "Error: $ComputerName", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error))
              }
            }
            
            if ($Data.Index -eq -1)
            {
              $MyDMImageList.Images.Add($NewSubMenu.ID, $MyDMImageList.Images[0])
            }
            else
            {
              $MyDMImageList.Images.Add($NewSubMenu.ID, $Data.IconSmall)
            }
            
            New-TreeNode -TreeNode $MyDMMidMenuTreeView.SelectedNode -Text $Data.ReturnVal01Text -Tag $NewSubMenu -ImageKey $NewSubMenu.ID
            $MyDMMidMenuTreeView.SelectedNode.Expand()
          }
          #endregion ******** Add New Desktop Sub Menu ********
        }
        else
        {
          #region ******** Add New Desktop Menu ********
          $MyDMStatusStrip.Items["Status"].Text = "Add New Desktop Menu..."
          
          $BadNames = [System.Collections.ArrayList]::New()
          $CurNode = 0
          if ($MyDMConfig.EnableUser)
          {
            $BadNames.AddRange(@($MyDMMidMenuTreeView.Nodes[$CurNode].Nodes | Select-Object -ExpandProperty Name))
            $CurNode++
          }
          
          if ($MyDMConfig.EnableSystem)
          {
            $BadNames.AddRange(@($MyDMMidMenuTreeView.Nodes[$CurNode].Nodes | Select-Object -ExpandProperty Name))
          }
          
          if ((($Data = Show-MyDMEditDialog -DesktopMenu -BadNames $BadNames -ReturnVal01Text ("{$([Guid]::NewGuid().Guid)}".ToUpper()))).DialogResult -eq [System.Windows.Forms.DialogResult]::OK)
          {
            $NewMenu = [MyDesktopMenu]::New($Data.ReturnVal01Text, $Data.ReturnVal02Text, $Data.IconPath, $Data.Index)
            $MyDMImageList.Images.Add($NewMenu.ID, $Data.IconSmall)
            New-TreeNode -TreeNode $MyDMMidMenuTreeView.SelectedNode -Text $Data.ReturnVal02Text -Tag $NewMenu -ImageKey $NewMenu.ID
            $MyDMMidMenuTreeView.SelectedNode.Expand()
            
            if ($MyDMConfig.EditRegistry)
            {
              $TempHive = $MyDMMidMenuTreeView.SelectedNode.Tag
              
              $CheckValue = 0
              $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetStringValue($TempHive, $MyDMConfig.RegistryMenuList, $Data.ReturnVal01Text, $Data.ReturnVal02Text)).Failure
              $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.CreateKey($TempHive, $MyDMConfig.RegistryMenuData, $Data.ReturnVal01Text)).Failure
              $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetStringValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$($Data.ReturnVal01Text)", "", $Data.ReturnVal02Text)).Failure
              $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.CreateKey($TempHive, "$($MyDMConfig.RegistryMenuData)\$($Data.ReturnVal01Text)", "DefaultIcon")).Failure
              $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetStringValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$($Data.ReturnVal01Text)\DefaultIcon", "", "$($Data.IconPath),$($Data.Index)")).Failure
              $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.CreateKey($TempHive, "$($MyDMConfig.RegistryMenuData)\$($Data.ReturnVal01Text)", "InProcServer32")).Failure
              $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetStringValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$($Data.ReturnVal01Text)\InProcServer32", "", "shell32.dll")).Failure
              $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetStringValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$($Data.ReturnVal01Text)\InProcServer32", "ThreadingModel", "Apartment")).Failure
              $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.CreateKey($TempHive, "$($MyDMConfig.RegistryMenuData)\$($Data.ReturnVal01Text)", "Shell")).Failure
              $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.CreateKey($TempHive, "$($MyDMConfig.RegistryMenuData)\$($Data.ReturnVal01Text)", "ShellEx")).Failure
              $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.CreateKey($TempHive, "$($MyDMConfig.RegistryMenuData)\$($Data.ReturnVal01Text)\ShellEx", "PropertySheetHandlers")).Failure
              $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.CreateKey($TempHive, "$($MyDMConfig.RegistryMenuData)\$($Data.ReturnVal01Text)\ShellEx\PropertySheetHandlers", $Data.ReturnVal01Text)).Failure
              $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.CreateKey($TempHive, "$($MyDMConfig.RegistryMenuData)\$($Data.ReturnVal01Text)", "ShellFolder")).Failure
              $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetBinaryValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$($Data.ReturnVal01Text)\ShellFolder", "Attributes", @(0, 0, 0))).Failure
              $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.CreateKey($TempHive, $MyDMConfig.RegistryMenuDisplay, $Data.ReturnVal01Text)).Failure
              
              if ($CheckValue)
              {
                [Void]([System.Windows.Forms.MessageBox]::Show($MyDMForm, "Error Creating Desktop Menu. - $CheckValue", "Error: $ComputerName", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error))
              }
            }
          }
          #endregion ******** Add New Desktop Menu ********
        }
        Break
      }
      "Edit"
      {
        if ($MyDMMidMenuTreeView.SelectedNode.Level -eq 2)
        {
          #region ******** Edit Desktop Sub Menu ********
          $MyDMStatusStrip.Items["Status"].Text = "Edit Desktop Menu Sub-Menu..."
          
          $BadNames = [System.Collections.ArrayList]::New()
          $BadNames.AddRange(@($MyDMMidMenuTreeView.SelectedNode.Nodes | Select-Object -ExpandProperty Name | Where-Object -FilterScript { $PSItem.Name -ne $MyDMMidMenuTreeView.SelectedNode.Name }))
          
          $TempSubMenu = $MyDMMidMenuTreeView.SelectedNode.Tag
          if ((($Data = Show-MyDMEditDialog -SubMenu -BadNames $BadNames -ReturnVal01Text $TempSubMenu.Name -SeparatorBefore ($TempSubMenu.CommandFlags -band $MyDMConfig.SeparatorBefore) -SeparatorAfter ($TempSubMenu.CommandFlags -band $MyDMConfig.SeparatorAfter) -IconPath $TempSubMenu.IconPath -Index $TempSubMenu.Index)).DialogResult -eq [System.Windows.Forms.DialogResult]::OK)
          {
            $TempCommandFlags = 0x0
            if ($Data.SeparatorBefore)
            {
              $TempCommandFlags = $TempCommandFlags -bor $MyDMConfig.SeparatorBefore
            }
            
            if ($Data.SeparatorAfter)
            {
              $TempCommandFlags = $TempCommandFlags -bor $MyDMConfig.SeparatorAfter
            }
            
            if ($MyDMConfig.EditRegistry)
            {
              $TempHive = $MyDMMidMenuTreeView.SelectedNode.Parent.Parent.Tag
              $TempMenuID = $MyDMMidMenuTreeView.SelectedNode.Parent.Tag.ID
              
              $TempSubMenuName = ($MyDMConfig.PrefixMenu -f $MyDMMidMenuTreeView.SelectedNode.Index)
              
              $CheckValue = 0
              if ($Data.Index -eq -1)
              {
                [Void]($MyDMConfig.Registry.DeleteValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempSubMenuName", "Icon"))
              }
              else
              {
                $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetStringValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempSubMenuName", "Icon", "$($Data.IconPath),$($Data.Index)")).Failure
              }
              $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetStringValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempSubMenuName", "MUIVerb", $Data.ReturnVal01Text)).Failure
              $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetDWordValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempSubMenuName", "CommandFlags", $TempCommandFlags)).Failure
              
              if ($Data.SeparatorBefore)
              {
                $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetStringValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempSubMenuName", "SeparatorBefore", $MyDMConfig.SeparatorYes)).Failure
              }
              else
              {
                [Void]($MyDMConfig.Registry.DeleteValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempSubMenuName", "SeparatorBefore"))
              }
              
              if ($Data.SeparatorAfter)
              {
                $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetStringValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempSubMenuName", "SeparatorAfter", $MyDMConfig.SeparatorYes)).Failure
              }
              else
              {
                [Void]($MyDMConfig.Registry.DeleteValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempSubMenuName", "SeparatorAfter"))
              }
              
              if ($CheckValue)
              {
                [Void]([System.Windows.Forms.MessageBox]::Show($MyDMForm, "Error Editing Desktop Sub Menu. - $CheckValue", "Error: $ComputerName", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error))
              }
            }
            
            $MyDMMidMenuTreeView.SelectedNode.Text = $Data.ReturnVal01Text
            
            if ($Data.Index -eq -1)
            {
              $MyDMImageList.Images[$MyDMImageList.Images.IndexOfKey($MyDMMidMenuTreeView.SelectedNode.ImageKey)] = $MyDMImageList.Images[0]
            }
            else
            {
              $MyDMImageList.Images[$MyDMImageList.Images.IndexOfKey($MyDMMidMenuTreeView.SelectedNode.ImageKey)] = $Data.IconSmall
            }
            $MyDMMidMenuTreeView.SelectedNode.Tag.UpdateSubMenu($Data.ReturnVal01Text, $TempCommandFlags, $Data.IconPath, $Data.Index)
          }
          #endregion ******** Edit Desktop Sub Menu ********
        }
        else
        {
          #region ******** Edit Desktop Menu ********
          $MyDMStatusStrip.Items["Status"].Text = "Edit Desktop Menu..."
          
          $BadNames = [System.Collections.ArrayList]::New()
          
          $CurNode = 0
          if ($MyDMConfig.EnableUser)
          {
            $BadNames.AddRange(@($MyDMMidMenuTreeView.Nodes[$CurNode].Nodes | Select-Object -ExpandProperty Name | Where-Object -FilterScript { $PSItem -ne $MyDMMidMenuTreeView.SelectedNode.Name }))
            $CurNode++
          }
          
          if ($MyDMConfig.EnableSystem)
          {
            $BadNames.AddRange(@($MyDMMidMenuTreeView.Nodes[$CurNode].Nodes | Select-Object -ExpandProperty Name | Where-Object -FilterScript { $PSItem -ne $MyDMMidMenuTreeView.SelectedNode.Name }))
          }
          
          $TempMenu = $MyDMMidMenuTreeView.SelectedNode.Tag
          if ((($Data = Show-MyDMEditDialog -DesktopMenu -BadNames $BadNames -ReturnVal01Text $TempMenu.ID -ReturnVal02Text $TempMenu.Name -IconPath $TempMenu.IconPath -Index $TempMenu.Index)).DialogResult -eq [System.Windows.Forms.DialogResult]::OK)
          {
            if ($MyDMConfig.EditRegistry)
            {
              $TempHive = $MyDMMidMenuTreeView.SelectedNode.Parent.Tag
              
              $CheckValue = 0
              $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetStringValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$($Data.ReturnVal01Text)", "", $Data.ReturnVal02Text)).Failure
              $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetStringValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$($Data.ReturnVal01Text)\DefaultIcon", "", "$($Data.IconPath),$($Data.Index)")).Failure
              
              if ($CheckValue)
              {
                [Void]([System.Windows.Forms.MessageBox]::Show($MyDMForm, "Error Editing Desktop Menu. - $CheckValue", "Error: $ComputerName", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error))
              }
              
              [Void]($MyDMConfig.Registry.DeleteKey($MyDMConfig.RegistryMenuDeleted, $Data.ReturnVal01Text))
            }
            
            $MyDMMidMenuTreeView.SelectedNode.Text = $Data.ReturnVal02Text
            $MyDMImageList.Images[$MyDMImageList.Images.IndexOfKey($MyDMMidMenuTreeView.SelectedNode.ImageKey)] = $Data.IconSmall
            $MyDMMidMenuTreeView.SelectedNode.Tag.UpdateMenu($Data.ReturnVal02Text, $Data.IconPath, $Data.Index)
          }
          #endregion ******** Edit Desktop Menu ********
        }
        Break
      }
      "Delete"
      {
        #region ******** Edit Desktop Menu ********
        if ($MyDMConfig.EditRegistry)
        {
          if ($MyDMMidMenuTreeView.SelectedNode.Level -eq 2)
          {
            # ****************************
            # Delete Desktop Menu Sub Menu
            # ****************************
            $MyDMStatusStrip.Items["Status"].Text = "Delete Desktop Menu Sub Menu..."
            
            if ([System.Windows.Forms.MessageBox]::Show($MyDMForm, "Delete Selected Desktop Sub Menu?", "Delete Desktop Sub Menu?", [System.Windows.Forms.MessageBoxButtons]::YesNo, [System.Windows.Forms.MessageBoxIcon]::Question) -eq [System.Windows.Forms.DialogResult]::Yes)
            {
              $TempHive = $MyDMMidMenuTreeView.SelectedNode.Parent.Parent.Tag
              $TempMenuID = $MyDMMidMenuTreeView.SelectedNode.Parent.Tag.ID
              
              $ParentNode = $MyDMMidMenuTreeView.SelectedNode.Parent
              
              $RemoveSubMenu = $MyDMMidMenuTreeView.SelectedNode.Tag
              
              $CheckValue = 0
              
              # ************************
              # Remove Sub Menu Commands
              # ************************
              $Total = @($RemoveSubMenu.Command).Count - 1
              For ($Count = $Total; $Count -gt -1; $Count--)
              {
                $Command = $RemoveSubMenu.Command[$Count]
                
                $MyDMImageList.Images.RemoveByKey($Command.ImageKey)
                
                $TempSubCommandName = ($MyDMConfig.PrefixSubCommand -f $TempMenuID, $RemoveSubMenu.ID, $Count)
                $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.DeleteKey($TempHive, "$($MyDMConfig.RegistrySubMenuCmds)\$TempSubCommandName", "Command")).Failure
                $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.DeleteKey($TempHive, "$($MyDMConfig.RegistrySubMenuCmds)", $TempSubCommandName)).Failure
              }
              
              # ****************
              # Remove Sub Menu
              # ****************
              $TempSubMenuName = ($MyDMConfig.PrefixMenu -f (($ParentNode.Nodes).Count - 1))
              $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.DeleteKey($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell", $TempSubMenuName)).Failure
              $MyDMImageList.Images.RemoveByKey($MyDMMidMenuTreeView.SelectedNode.ImageKey)
              $MyDMMidMenuTreeView.SelectedNode.Parent.Nodes.Remove($MyDMMidMenuTreeView.SelectedNode)
              
              # *************************
              # Write Remaining Sub Menus
              # *************************
              ForEach ($Node in $ParentNode.Nodes)
              {
                $TempSubMenuName = ($MyDMConfig.PrefixMenu -f $Node.Index)
                
                if ($Node.Tag.Index -eq -1)
                {
                  [Void]($MyDMConfig.Registry.DeleteValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempSubMenuName", "Icon"))
                }
                else
                {
                  $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetStringValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempSubMenuName", "Icon", "$($Node.Tag.IconPath),$($Node.Tag.Index)")).Failure
                }
                $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetStringValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempSubMenuName", "ID", $Node.Tag.ID)).Failure
                $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetStringValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempSubMenuName", "MUIVerb", $Node.Tag.Name)).Failure
                $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetStringValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempSubMenuName", "SubCommands", $Node.Tag.SubCommands)).Failure
                $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetDWordValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempSubMenuName", "CommandFlags", $Node.Tag.CommandFlags)).Failure
                
                if ($Node.Tag.CommandFlags -band $MyDMConfig.SeparatorBefore)
                {
                  $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetStringValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempSubMenuName", "SeparatorBefore", $MyDMConfig.SeparatorYes)).Failure
                }
                else
                {
                  [Void]($MyDMConfig.Registry.DeleteValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempSubMenuName", "SeparatorBefore"))
                }
                
                if ($Node.Tag.CommandFlags -band $MyDMConfig.SeparatorAfter)
                {
                  $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetStringValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempSubMenuName", "SeparatorAfter", $MyDMConfig.SeparatorYes)).Failure
                }
                else
                {
                  [Void]($MyDMConfig.Registry.DeleteValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempSubMenuName", "SeparatorAfter"))
                }
              }
              
              if ($CheckValue)
              {
                [Void]([System.Windows.Forms.MessageBox]::Show($MyDMForm, "Error Deleting Desktop Sub Menu. - $CheckValue", "Error: $ComputerName", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error))
              }
              else
              {
                [Void]([System.Windows.Forms.MessageBox]::Show($MyDMForm, "Successfully Deleted Desktop Sub Menu.", "Success: $ComputerName", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information))
              }
            }
          }
          else
          {
            # *******************
            # Delete Desktop Menu
            # *******************
            $MyDMStatusStrip.Items["Status"].Text = "Delete Desktop Menu..."
            
            if ([System.Windows.Forms.MessageBox]::Show($MyDMForm, "Delete Selected Desktop Menu?", "Delete Desktop Menu?", [System.Windows.Forms.MessageBoxButtons]::YesNo, [System.Windows.Forms.MessageBoxIcon]::Question) -eq [System.Windows.Forms.DialogResult]::Yes)
            {
              # ******************
              # Add More Code Here
              # ******************
              $TempHive = $MyDMMidMenuTreeView.SelectedNode.Parent.Tag
              $TempMenuID = $MyDMMidMenuTreeView.SelectedNode.Tag.ID
              
              $ParentNode = $MyDMMidMenuTreeView.SelectedNode
              
              $CheckValue = 0
              
              ForEach ($SubMenu in $ParentNode.Nodes)
              {
                $RemoveSubMenu = $SubMenu.Tag
                
                # ************************
                # Remove Sub Menu Commands
                # ************************
                $Total = @($RemoveSubMenu.Command).Count - 1
                For ($Count = $Total; $Count -gt -1; $Count--)
                {
                  $Command = $RemoveSubMenu.Command[$Count]
                  
                  $MyDMImageList.Images.RemoveByKey($Command.ImageKey)
                  
                  $TempSubCommandName = ($MyDMConfig.PrefixSubCommand -f $TempMenuID, $RemoveSubMenu.ID, $Count)
                  $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.DeleteKey($TempHive, "$($MyDMConfig.RegistrySubMenuCmds)\$TempSubCommandName", "Command")).Failure
                  $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.DeleteKey($TempHive, "$($MyDMConfig.RegistrySubMenuCmds)", $TempSubCommandName)).Failure
                }
                
                # ***************
                # Remove Sub Menu
                # ***************
                $TempSubMenuName = ($MyDMConfig.PrefixMenu -f $SubMenu.Index)
                $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.DeleteKey($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell", $TempSubMenuName)).Failure
                $MyDMImageList.Images.RemoveByKey($SubMenu.ImageKey)
              }
              
              # ********************
              # Remove Menu Commands
              # ********************
              $RemoveMenu = $ParentNode.Tag
              $Total = @($RemoveMenu.Command).Count - 1
              For ($Count = $Total; $Count -gt -1; $Count--)
              {
                $Command = $RemoveMenu.Command[$Count]
                
                $MyDMImageList.Images.RemoveByKey($Command.ImageKey)
                
                $TempCommandName = ($MyDMConfig.PrefixCommand -f $Count)
                $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.DeleteKey($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempCommandName", "Command")).Failure
                $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.DeleteKey($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell", $TempCommandName)).Failure
              }
              
              # *******************
              # Remove Desktop Icon
              # *******************
              $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.DeleteKey($TempHive, $MyDMConfig.RegistryMenuDisplay, $MyDMMidMenuTreeView.SelectedNode.Tag.ID)).Failure
              $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.DeleteKey($TempHive, "$($MyDMConfig.RegistryMenuData)\$($MyDMMidMenuTreeView.SelectedNode.Tag.ID)", "ShellFolder")).Failure
              $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.DeleteKey($TempHive, "$($MyDMConfig.RegistryMenuData)\$($MyDMMidMenuTreeView.SelectedNode.Tag.ID)\ShellEx\PropertySheetHandlers", $MyDMMidMenuTreeView.SelectedNode.Tag.ID)).Failure
              $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.DeleteKey($TempHive, "$($MyDMConfig.RegistryMenuData)\$($MyDMMidMenuTreeView.SelectedNode.Tag.ID)\ShellEx", "PropertySheetHandlers")).Failure
              $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.DeleteKey($TempHive, "$($MyDMConfig.RegistryMenuData)\$($MyDMMidMenuTreeView.SelectedNode.Tag.ID)", "Shell")).Failure
              $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.DeleteKey($TempHive, "$($MyDMConfig.RegistryMenuData)\$($MyDMMidMenuTreeView.SelectedNode.Tag.ID)", "ShellEx")).Failure
              $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.DeleteKey($TempHive, "$($MyDMConfig.RegistryMenuData)\$($MyDMMidMenuTreeView.SelectedNode.Tag.ID)", "InProcServer32")).Failure
              $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.DeleteKey($TempHive, "$($MyDMConfig.RegistryMenuData)\$($MyDMMidMenuTreeView.SelectedNode.Tag.ID)", "DefaultIcon")).Failure
              $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.DeleteKey($TempHive, $MyDMConfig.RegistryMenuData, $MyDMMidMenuTreeView.SelectedNode.Tag.ID)).Failure
              $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.DeleteValue($TempHive, $MyDMConfig.RegistryMenuList, $MyDMMidMenuTreeView.SelectedNode.Tag.ID)).Failure
              
              $ParentNode.Parent.Nodes.Remove($ParentNode)
              if ($CheckValue)
              {
                [Void]([System.Windows.Forms.MessageBox]::Show($MyDMForm, "Error Deleting Desktop Menu. - $CheckValue", "Error: $ComputerName", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error))
              }
              else
              {
                [Void]([System.Windows.Forms.MessageBox]::Show($MyDMForm, "Successfully Deleted Desktop Menu.", "Success: $ComputerName", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information))
              }
            }
          }
        }
        #endregion ******** Edit Desktop Menu ********
        Break
      }
      "Up"
      {
        #region ******** Move Desktop Sub Menu Up ********
        $MyDMStatusStrip.Items["Status"].Text = "Move Sub-Menu Up..."
        
        $TempNodeIndex = $MyDMMidMenuTreeView.SelectedNode.Index - 1
        if ($MyDMConfig.EditRegistry)
        {
          $TempHive = $MyDMMidMenuTreeView.SelectedNode.Parent.Parent.Tag
          $TempMenuID = $MyDMMidMenuTreeView.SelectedNode.Parent.Tag.ID
          
          $TempSubMenu = $MyDMMidMenuTreeView.SelectedNode.Parent.Nodes.Item($TempNodeIndex).Tag
          $TempSubMenuName = ($MyDMConfig.PrefixMenu -f $TempNodeIndex)
          
          $TempSubMenuUp = $MyDMMidMenuTreeView.SelectedNode.Parent.Nodes.Item($TempNodeIndex + 1).Tag
          $TempSubMenuUpName = ($MyDMConfig.PrefixMenu -f ($TempNodeIndex + 1))
          
          $CheckValue = 0
          # **********************
          # Move Lower Sub Menu Up
          # **********************
          if ($TempSubMenuUp.Index -eq -1)
          {
            [Void]($MyDMConfig.Registry.DeleteValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempSubMenuName", "Icon"))
          }
          else
          {
            $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetStringValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempSubMenuName", "Icon", "$($TempSubMenuUp.IconPath),$($TempSubMenuUp.Index)")).Failure
          }
          $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetStringValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempSubMenuName", "ID", $TempSubMenuUp.ID)).Failure
          $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetStringValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempSubMenuName", "MUIVerb", $TempSubMenuUp.Name)).Failure
          $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetStringValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempSubMenuName", "SubCommands", $TempSubMenuUp.SubCommands)).Failure
          $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetDWordValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempSubMenuName", "CommandFlags", $TempSubMenuUp.CommandFlags)).Failure
          
          if ($TempSubMenuUp.CommandFlags -band $MyDMConfig.SeparatorBefore)
          {
            $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetStringValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempSubMenuName", "SeparatorBefore", $MyDMConfig.SeparatorYes)).Failure
          }
          else
          {
            [Void]($MyDMConfig.Registry.DeleteValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempSubMenuName", "SeparatorBefore"))
          }
          
          if ($TempSubMenuUp.CommandFlags -band $MyDMConfig.SeparatorAfter)
          {
            $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetStringValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempSubMenuName", "SeparatorAfter", $MyDMConfig.SeparatorYes)).Failure
          }
          else
          {
            [Void]($MyDMConfig.Registry.DeleteValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempSubMenuName", "SeparatorAfter"))
          }
          
          # ************************
          # Move Upper Sub Menu Down
          # ************************
          if ($TempSubMenu.Index -eq -1)
          {
            [Void]($MyDMConfig.Registry.DeleteValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempSubMenuUpName", "Icon"))
          }
          else
          {
            $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetStringValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempSubMenuUpName", "Icon", "$($TempSubMenu.IconPath),$($TempSubMenu.Index)")).Failure
          }
          $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetStringValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempSubMenuUpName", "ID", $TempSubMenu.ID)).Failure
          $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetStringValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempSubMenuUpName", "MUIVerb", $TempSubMenu.Name)).Failure
          $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetStringValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempSubMenuUpName", "SubCommands", $TempSubMenu.SubCommands)).Failure
          $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetDWordValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempSubMenuUpName", "CommandFlags", $TempSubMenu.CommandFlags)).Failure
          
          if ($TempSubMenu.CommandFlags -band $MyDMConfig.SeparatorBefore)
          {
            $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetStringValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempSubMenuUpName", "SeparatorBefore", $MyDMConfig.SeparatorYes)).Failure
          }
          else
          {
            [Void]($MyDMConfig.Registry.DeleteValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempSubMenuUpName", "SeparatorBefore"))
          }
          
          if ($TempSubMenu.CommandFlags -band $MyDMConfig.SeparatorAfter)
          {
            $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetStringValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempSubMenuUpName", "SeparatorAfter", $MyDMConfig.SeparatorYes)).Failure
          }
          else
          {
            [Void]($MyDMConfig.Registry.DeleteValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempSubMenuUpName", "SeparatorAfter"))
          }
          
          if ($CheckValue)
          {
            [Void]([System.Windows.Forms.MessageBox]::Show($MyDMForm, "Error Moving Desktop Sub Menu Up. - $CheckValue", "Error: $ComputerName", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error))
          }
        }
        $MyDMMidMenuTreeView.BeginUpdate()
        $TempNode = $MyDMMidMenuTreeView.SelectedNode.Parent.Nodes.Item($TempNodeIndex)
        $MyDMMidMenuTreeView.SelectedNode.Parent.Nodes.RemoveAt($TempNodeIndex)
        $MyDMMidMenuTreeView.SelectedNode.Parent.Nodes.Insert(($TempNodeIndex + 1), $TempNode)
        $MyDMMidMenuTreeView.EndUpdate()
        #endregion ******** Move Desktop Sub Menu Up ********
        Break
      }
      "Down"
      {
        #region ******** Move Desktop Sub Menu Down ********
        $MyDMStatusStrip.Items["Status"].Text = "Move Sub-Menu Down..."
        
        $TempNodeIndex = $MyDMMidMenuTreeView.SelectedNode.Index + 1
        if ($MyDMConfig.EditRegistry)
        {
          $TempHive = $MyDMMidMenuTreeView.SelectedNode.Parent.Parent.Tag
          $TempMenuID = $MyDMMidMenuTreeView.SelectedNode.Parent.Tag.ID
          
          $TempSubMenu = $MyDMMidMenuTreeView.SelectedNode.Parent.Nodes.Item($TempNodeIndex).Tag
          $TempSubMenuName = ($MyDMConfig.PrefixMenu -f $TempNodeIndex)
          
          $TempSubMenuDown = $MyDMMidMenuTreeView.SelectedNode.Parent.Nodes.Item($TempNodeIndex - 1).Tag
          $TempSubMenuDownName = ($MyDMConfig.PrefixMenu -f ($TempNodeIndex - 1))
          
          $CheckValue = 0
          # ************************
          # Move Upper Sub Menu Down
          # ************************
          if ($TempSubMenuDown.Index -eq -1)
          {
            [Void]($MyDMConfig.Registry.DeleteValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempSubMenuName", "Icon"))
          }
          else
          {
            $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetStringValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempSubMenuName", "Icon", "$($TempSubMenuDown.IconPath),$($TempSubMenuDown.Index)")).Failure
          }
          $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetStringValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempSubMenuName", "ID", $TempSubMenuDown.ID)).Failure
          $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetStringValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempSubMenuName", "MUIVerb", $TempSubMenuDown.Name)).Failure
          $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetStringValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempSubMenuName", "SubCommands", $TempSubMenuDown.SubCommands)).Failure
          $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetDWordValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempSubMenuName", "CommandFlags", $TempSubMenuDown.CommandFlags)).Failure
          
          if ($TempSubMenuDown.CommandFlags -band $MyDMConfig.SeparatorBefore)
          {
            $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetStringValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempSubMenuName", "SeparatorBefore", $MyDMConfig.SeparatorYes)).Failure
          }
          else
          {
            [Void]($MyDMConfig.Registry.DeleteValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempSubMenuName", "SeparatorBefore"))
          }
          
          if ($TempSubMenuDown.CommandFlags -band $MyDMConfig.SeparatorAfter)
          {
            $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetStringValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempSubMenuName", "SeparatorAfter", $MyDMConfig.SeparatorYes)).Failure
          }
          else
          {
            [Void]($MyDMConfig.Registry.DeleteValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempSubMenuName", "SeparatorAfter"))
          }
          
          # **********************
          # Move Lower Sub Menu Up
          # **********************
          if ($TempSubMenu.Index -eq -1)
          {
            [Void]($MyDMConfig.Registry.DeleteValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempSubMenuDownName", "Icon"))
          }
          else
          {
            $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetStringValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempSubMenuDownName", "Icon", "$($TempSubMenu.IconPath),$($TempSubMenu.Index)")).Failure
          }
          $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetStringValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempSubMenuDownName", "ID", $TempSubMenu.ID)).Failure
          $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetStringValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempSubMenuDownName", "MUIVerb", $TempSubMenu.Name)).Failure
          $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetStringValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempSubMenuDownName", "SubCommands", $TempSubMenu.SubCommands)).Failure
          $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetDWordValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempSubMenuDownName", "CommandFlags", $TempSubMenu.CommandFlags)).Failure
          
          if ($TempSubMenu.CommandFlags -band $MyDMConfig.SeparatorBefore)
          {
            $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetStringValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempSubMenuDownName", "SeparatorBefore", $MyDMConfig.SeparatorYes)).Failure
          }
          else
          {
            [Void]($MyDMConfig.Registry.DeleteValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempSubMenuDownName", "SeparatorBefore"))
          }
          
          if ($TempSubMenu.CommandFlags -band $MyDMConfig.SeparatorAfter)
          {
            $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetStringValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempSubMenuDownName", "SeparatorAfter", $MyDMConfig.SeparatorYes)).Failure
          }
          else
          {
            [Void]($MyDMConfig.Registry.DeleteValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempSubMenuDownName", "SeparatorAfter"))
          }
          
          if ($CheckValue)
          {
            [Void]([System.Windows.Forms.MessageBox]::Show($MyDMForm, "Error Moving Desktop Sub Menu Down. - $CheckValue", "Error: $ComputerName", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error))
          }
        }
        $MyDMMidMenuTreeView.BeginUpdate()
        $TempNode = $MyDMMidMenuTreeView.SelectedNode.Parent.Nodes.Item($TempNodeIndex)
        $MyDMMidMenuTreeView.SelectedNode.Parent.Nodes.RemoveAt($TempNodeIndex)
        $MyDMMidMenuTreeView.SelectedNode.Parent.Nodes.Insert(($TempNodeIndex - 1), $TempNode)
        $MyDMMidMenuTreeView.EndUpdate()
        #endregion ******** Move Desktop Sub Menu Down ********
        Break
      }
      "Export"
      {
        #region ******** Export Desktop Menu ********
        $ExportNode = $MyDMMidMenuTreeView.SelectedNode
        $MyDMStatusStrip.Items["Status"].Text = "Export Desktop Menu - $($ExportNode.Tag.Name)"
        
        $MyDMFolderBrowserDialog.Description = "Export Desktop Menu - $($ExportNode.Tag.Name)"
        if ($MyDMFolderBrowserDialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK)
        {
          $TempMenuID = $ExportNode.Tag.ID
          
          $ExportDel = [System.Text.StringBuilder]::New()
          [Void]$ExportDel.AppendLine("Windows Registry Editor Version 5.00")
          
          $ExportAdd = [System.Text.StringBuilder]::New()
          [Void]$ExportAdd.AppendLine("Windows Registry Editor Version 5.00")
          
          Switch ($ExportNode.Parent.Tag)
          {
            "HKCU"
            {
              $TempHiveDel = "`r`n[-HKEY_CURRENT_USER"
              $TempHiveAdd = "`r`n[HKEY_CURRENT_USER"
              Break
            }
            "HKLM"
            {
              $TempHiveDel = "`r`n[-HKEY_LOCAL_MACHINE"
              $TempHiveAdd = "`r`n[HKEY_LOCAL_MACHINE"
              Break
            }
          }
          
          # *******************
          # Delete Desktop Menu
          # *******************
          [Void]$ExportDel.AppendLine("$TempHiveAdd\$($MyDMConfig.RegistryMenuList)]")
          [Void]$ExportDel.AppendLine("`"$TempMenuID`"=-")
          # Remove Deleted Menu
          [Void]$ExportDel.AppendLine("$TempHiveDel\$($MyDMConfig.RegistryMenuDeleted)\$TempMenuID]")
          # Delete Display Menu
          [Void]$ExportDel.AppendLine("$TempHiveDel\$($MyDMConfig.RegistryMenuDisplay)\$TempMenuID]")
          # Delete Desktop Menu
          [Void]$ExportDel.AppendLine("$TempHiveDel\$($MyDMConfig.RegistryMenuData)\$TempMenuID]")
          
          # ****************
          # Add Desktop Menu
          # ****************
          [Void]$ExportAdd.AppendLine("$TempHiveAdd\$($MyDMConfig.RegistryMenuList)]")
          [Void]$ExportAdd.AppendLine("`"$TempMenuID`"=`"$($ExportNode.Tag.Name)`"")
          # Remove Deleted Menu
          [Void]$ExportAdd.AppendLine("$TempHiveDel\$($MyDMConfig.RegistryMenuDeleted)\$TempMenuID]")
          # Add Display Menu
          [Void]$ExportAdd.AppendLine("$TempHiveAdd\$($MyDMConfig.RegistryMenuDisplay)\$TempMenuID]")
          # Add Desktop Menu
          [Void]$ExportAdd.AppendLine("$TempHiveAdd\$($MyDMConfig.RegistryMenuData)\$TempMenuID]")
          [Void]$ExportAdd.AppendLine("@=`"$($ExportNode.Tag.Name)`"")
          [Void]$ExportAdd.AppendLine("$TempHiveAdd\$($MyDMConfig.RegistryMenuData)\$TempMenuID\DefaultIcon]")
          if ($ExportNode.Tag.Index -ne -1)
          {
            $FilePath = "$($ExportNode.Tag.IconPath)".Replace("\", "\\").Replace("`"", "\`"")
            [Void]$ExportAdd.AppendLine("@=`"$FilePath,$($ExportNode.Tag.Index)`"")
          }
          [Void]$ExportAdd.AppendLine("$TempHiveAdd\$($MyDMConfig.RegistryMenuData)\$TempMenuID\InProcServer32]")
          [Void]$ExportAdd.AppendLine("@=`"shell32.dll`"")
          [Void]$ExportAdd.AppendLine("`"ThreadingModel`"=`"Apartment`"")
          [Void]$ExportAdd.AppendLine("$TempHiveAdd\$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell]")
          
          # *****************
          # Add Menu Commands
          # *****************
          $TotalCmds = @($ExportNode.Tag.Command).Count
          if ($TotalCmds)
          {
            [Void]$ExportAdd.AppendLine("@=`"XCmd000`"")
            For ($CountCmd = 0; $CountCmd -lt $TotalCmds; $CountCmd++)
            {
              $TempCmdName = ($MyDMConfig.PrefixCommand -f $CountCmd)
              $Cmd = $ExportNode.Tag.Command[$CountCmd].Tag
              [Void]$ExportAdd.AppendLine("$TempHiveAdd\$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempCmdName]")
              [Void]$ExportAdd.AppendLine("`"MUIVerb`"=`"$($Cmd.Name)`"")
              if ($Cmd.Index -ne -1)
              {
                $FilePath = "$($Cmd.IconPath)".Replace("\", "\\").Replace("`"", "\`"")
                [Void]$ExportAdd.AppendLine("`"Icon`"=`"$FilePath,$($Cmd.Index)`"")
              }
              [Void]$ExportAdd.AppendLine(("`"CommandFlags`"=dword:{0:X8}" -f $Cmd.CommandFlags))
              if ($Cmd.CommandFlags -band $MyDMConfig.SeparatorBefore)
              {
                [Void]$ExportAdd.AppendLine("`"SeparatorBefore`"=`"Yes`"")
              }
              if ($Cmd.CommandFlags -band $MyDMConfig.SeparatorAfter)
              {
                [Void]$ExportAdd.AppendLine("`"SeparatorAfter`"=`"Yes`"")
              }
              [Void]$ExportAdd.AppendLine("$TempHiveAdd\$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempCmdName\Command]")
              $FilePath = "$($Cmd.Command)".Replace("\", "\\").Replace("`"", "\`"")
              [Void]$ExportAdd.AppendLine("@=`"$FilePath`"")
            }
          }
          
          # *************
          # Add Sub Menus
          # *************
          $TotalSubMenus = $ExportNode.Nodes.Count
          For ($CountSubMenu = 0; $CountSubMenu -lt $TotalSubMenus; $CountSubMenu++)
          {
            $TempSubMenuName = ($MyDMConfig.PrefixMenu -f $CountSubMenu)
            $SubMenu = $ExportNode.Nodes[$CountSubMenu].Tag
            [Void]$ExportAdd.AppendLine("$TempHiveAdd\$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempSubMenuName]")
            [Void]$ExportAdd.AppendLine("`"ID`"=`"$($SubMenu.ID)`"")
            [Void]$ExportAdd.AppendLine("`"MUIVerb`"=`"$($SubMenu.Name)`"")
            if ($SubMenu.Index -ne -1)
            {
              $FilePath = "$($SubMenu.IconPath)".Replace("\", "\\").Replace("`"", "\`"")
              [Void]$ExportAdd.AppendLine("`"Icon`"=`"$FilePath,$($SubMenu.Index)`"")
            }
            [Void]$ExportAdd.AppendLine(("`"CommandFlags`"=dword:{0:X8}" -f $SubMenu.CommandFlags))
            if ($SubMenu.CommandFlags -band $MyDMConfig.SeparatorBefore)
            {
              [Void]$ExportAdd.AppendLine("`"SeparatorBefore`"=`"Yes`"")
            }
            if ($SubMenu.CommandFlags -band $MyDMConfig.SeparatorAfter)
            {
              [Void]$ExportAdd.AppendLine("`"SeparatorAfter`"=`"Yes`"")
            }
            [Void]$ExportAdd.AppendLine("`"SubCommands`"=`"$($SubMenu.SubCommands)`"")
            # *********************
            # Add Sub Menu Commands
            # *********************
            $TotalSubCmds = @($SubMenu.SubCommands.Split(";", [System.StringSplitOptions]::RemoveEmptyEntries)).Count
            For ($CountSubCmd = 0; $CountSubCmd -lt $TotalSubCmds; $CountSubCmd++)
            {
              $TempSubCmdName = ($MyDMConfig.PrefixSubCommand -f $TempMenuID, $SubMenu.ID, $CountSubCmd)
              $SubCmd = $SubMenu.Command[$CountSubCmd].Tag
              # Delete Existing Sub Menu Commands
              [Void]$ExportDel.AppendLine("$TempHiveDel\$($MyDMConfig.RegistrySubMenuCmds)\$TempSubCmdName]")
              [Void]$ExportAdd.AppendLine("$TempHiveDel\$($MyDMConfig.RegistrySubMenuCmds)\$TempSubCmdName]")
              [Void]$ExportAdd.AppendLine("$TempHiveAdd\$($MyDMConfig.RegistrySubMenuCmds)\$TempSubCmdName]")
              [Void]$ExportAdd.AppendLine("`"MUIVerb`"=`"$($SubCmd.Name)`"")
              if ($SubCmd.Index -ne -1)
              {
                $FilePath = "$($SubCmd.IconPath)".Replace("\", "\\").Replace("`"", "\`"")
                [Void]$ExportAdd.AppendLine("`"Icon`"=`"$FilePath,$($SubCmd.Index)`"")
              }
              [Void]$ExportAdd.AppendLine(("`"CommandFlags`"=dword:{0:X8}" -f $SubCmd.CommandFlags))
              [Void]$ExportAdd.AppendLine("$TempHiveAdd\$($MyDMConfig.RegistrySubMenuCmds)\$TempSubCmdName\Command]")
              $FilePath = "$($SubCmd.Command)".Replace("\", "\\").Replace("`"", "\`"")
              [Void]$ExportAdd.AppendLine("@=`"$FilePath`"")
            }
            For ($CountSubCmd = $CountSubCmd; $CountSubCmd -lt 16; $CountSubCmd++)
            {
              $TempSubCmdName = ($MyDMConfig.PrefixSubCommand -f $TempMenuID, $SubMenu.ID, $CountSubCmd)
              # Delete Unused Sub Menu Commands
              [Void]$ExportDel.AppendLine("$TempHiveDel\$($MyDMConfig.RegistrySubMenuCmds)\$TempSubCmdName]")
              [Void]$ExportAdd.AppendLine("$TempHiveDel\$($MyDMConfig.RegistrySubMenuCmds)\$TempSubCmdName]")
            }
          }
          [Void]$ExportAdd.AppendLine("$TempHiveAdd\$($MyDMConfig.RegistryMenuData)\$TempMenuID\ShellEx]")
          [Void]$ExportAdd.AppendLine("$TempHiveAdd\$($MyDMConfig.RegistryMenuData)\$TempMenuID\ShellEx\PropertySheetHandlers]")
          [Void]$ExportAdd.AppendLine("$TempHiveAdd\$($MyDMConfig.RegistryMenuData)\$TempMenuID\ShellEx\PropertySheetHandlers\$TempMenuID]")
          [Void]$ExportAdd.AppendLine("$TempHiveAdd\$($MyDMConfig.RegistryMenuData)\$TempMenuID\ShellFolder]")
          [Void]$ExportAdd.AppendLine("`"Attributes`"=hex:00,00,00")
          
          Out-File -Encoding utf8 -FilePath "$($MyDMFolderBrowserDialog.SelectedPath)\$($ExportNode.Tag.Name)_Del.reg" -InputObject ($ExportDel.ToString())
          Out-File -Encoding utf8 -FilePath "$($MyDMFolderBrowserDialog.SelectedPath)\$($ExportNode.Tag.Name)_Add.reg" -InputObject ($ExportAdd.ToString())
        }
        #endregion ******** Export Desktop Menu ********
        Break
      }
      "Command"
      {
        $MyDMStatusStrip.Items["Status"].Text = "Add New Desktop Menu Command..."
        
        New-MyDMMenuCommand
        if ($MyDMMidCmdsListView.Items.Count)
        {
          $MyDMMidMenuTreeView.SelectedNode.Tag.Command = ($MyDMMidCmdsListView.Items).Clone()
        }
        else
        {
          $MyDMMidMenuTreeView.SelectedNode.Tag.Command = @()
        }
        Break
      }
    }
    
    if ($MyDMMidCmdsListView.Items.Count)
    {
      $MyDMMidMenuTreeView.SelectedNode.Tag.Command = ($MyDMMidCmdsListView.Items).Clone()
    }
    else
    {
      if ($MyDMMidMenuTreeView.SelectedNode.Level)
      {
        $MyDMMidMenuTreeView.SelectedNode.Tag.Command = @()
      }
    }
    
    
    $MyDMStatusStrip.Items["Status"].Text = $MyDMConfig.ScriptName
    #$MyDMForm.Cursor = [System.Windows.Forms.Cursors]::Arrow
    
    [System.GC]::Collect()
    [System.GC]::WaitForPendingFinalizers()
  }
  Catch
  {
    Write-Debug -Message "ErrMsg: $($Error[0].Exception.Message)"
    Write-Debug -Message "Line: $($Error[0].InvocationInfo.ScriptLineNumber)"
    Write-Debug -Message "Code: $(($Error[0].InvocationInfo.Line).Trim())"
  }
  Write-Verbose -Message "Exit Click Event for `$MyDMMidMenuToolStripButton"
}
#endregion function Start-MyDMMidMenuToolStripButtonClick

(New-MenuItem -Menu $MyDMMidMenuMenuStrip -Disable -Name "New" -Text "Menu" -Tag "New" -DisplayStyle "ImageAndText" -Icon ([System.Drawing.Icon]([System.Convert]::FromBase64String($Newico))) -PassThru).add_Click({ Start-MyDMMidMenuToolStripButtonClick -Sender $This -EventArg $PSItem})
(New-MenuItem -Menu $MyDMMidMenuMenuStrip -Disable -Name "Edit" -Text "Edit" -Tag "Edit" -DisplayStyle "ImageAndText" -Icon ([System.Drawing.Icon]([System.Convert]::FromBase64String($Editico))) -PassThru).add_Click({ Start-MyDMMidMenuToolStripButtonClick -Sender $This -EventArg $PSItem})
(New-MenuItem -Menu $MyDMMidMenuMenuStrip -Disable -Name "Delete" -Text "Del" -Tag "Delete" -DisplayStyle "ImageAndText" -Icon ([System.Drawing.Icon]([System.Convert]::FromBase64String($Deleteico))) -PassThru).add_Click({ Start-MyDMMidMenuToolStripButtonClick -Sender $This -EventArg $PSItem})

#endregion ******** $MyDMMidMenuMenuStrip ToolStrip MenuItems ********

#region $MyDMMidMenuTreeView = System.Windows.Forms.TreeView
Write-Verbose -Message "Creating Form Control `$MyDMMidMenuTreeView"
$MyDMMidMenuTreeView = New-Object -TypeName System.Windows.Forms.TreeView
$MyDMMidSplitContainer.Panel1.Controls.Add($MyDMMidMenuTreeView)
$MyDMMidMenuTreeView.BackColor = $MyDMColor.TextBackColor
$MyDMMidMenuTreeView.BorderStyle = [System.Windows.Forms.BorderStyle]::None
$MyDMMidMenuTreeView.CheckBoxes = $False
$MyDMMidMenuTreeView.Font = $MyDMConfig.FontData.Regular
$MyDMMidMenuTreeView.ForeColor = $MyDMColor.TextForeColor
$MyDMMidMenuTreeView.HideSelection = $False
$MyDMMidMenuTreeView.ImageList = $MyDMImageList
$MyDMMidMenuTreeView.ItemHeight = $MyDMConfig.FontData.Height
$MyDMMidMenuTreeView.Location = New-Object -TypeName System.Drawing.Point($MyDMConfig.FormSpacer, $MyDMMidMenuMenuStrip.Bottom)
$MyDMMidMenuTreeView.Name = "MyDMMidMenuTreeView"
$MyDMMidMenuTreeView.Size = New-Object -TypeName System.Drawing.Size(($MyDMMidSplitContainer.Panel1.ClientSize.Width - $MyDMConfig.FormSpacer), ($MyDMMidSplitContainer.Panel1.ClientSize.Height - $MyDMConfig.FormSpacer))
$MyDMMidMenuTreeView.Sorted = $False
$MyDMMidMenuTreeView.Text = "MyDMMidMenuTreeView"
#endregion
$MyDMToolTip.SetToolTip($MyDMMidMenuTreeView, "Help for Control $($MyDMMidMenuTreeView.Name)")

$MyDMMidMenuTreeView.Anchor = [System.Windows.Forms.AnchorStyles]("Top", "Left", "Bottom", "Right")

#region function Start-MyDMMidMenuTreeViewAfterSelect
function Start-MyDMMidMenuTreeViewAfterSelect()
{
  <#
    .SYNOPSIS
      AfterSelect event for the MyDMMidMenuTreeView Control
    .DESCRIPTION
      AfterSelect event for the MyDMMidMenuTreeView Control
    .PARAMETER Sender
       The Form Control that fired the Event
    .PARAMETER EventArg
       The Event Arguments for the Event
    .EXAMPLE
       Start-MyDMMidMenuTreeViewAfterSelect -Sender $Sender -EventArg $EventArg
    .NOTES
      Original Function By Ken Sweet
    .LINK
  #>
  [CmdletBinding()]
  param (
    [parameter(Mandatory = $True)]
    [Object]$Sender,
    [parameter(Mandatory = $True)]
    [Object]$EventArg
  )
  Write-Verbose -Message "Enter AfterSelect Event for `$MyDMMidMenuTreeView"
  Try
  {
    #$MyDMForm.Cursor = [System.Windows.Forms.Cursors]::WaitCursor
    $MyDMMidCmdsListView.Items.Clear()
    if ($EventArg.Node.Level)
    {
      $EventArg.Node.ImageKey = $EventArg.Node.Tag.ID
      $EventArg.Node.SelectedImageKey = $EventArg.Node.Tag.ID
      
      $MyDMMidMenuMenuStrip.Items["New"].Enabled = (($MyDMMidMenuTreeView.SelectedNode.Level -eq 1) -and ($MyDMMidMenuTreeView.SelectedNode.Parent.Tag -eq "HKLM"))
      $MyDMMidMenuMenuStrip.Items["Edit"].Enabled = $True
      $MyDMMidMenuMenuStrip.Items["Delete"].Enabled = ($MyDMMidMenuTreeView.SelectedNode.Level -gt 0)
      
      if ($EventArg.Node.Tag.Command.Count)
      {
        $MyDMMidCmdsListView.Items.AddRange(@($EventArg.Node.Tag.Command))
      }
      
      $MyDMMidCmdsMenuStrip.Items["New"].Enabled = ((($MyDMMidCmdsListView.Items.Count -lt $MyDMConfig.MaxSubMenuCmds) -and ($MyDMMidMenuTreeView.SelectedNode.Level -eq 2)) -or ($MyDMMidMenuTreeView.SelectedNode.Level -eq 1))
    }
    else
    {
      $MyDMMidMenuMenuStrip.Items["New"].Enabled = $True
      $MyDMMidMenuMenuStrip.Items["Edit"].Enabled = $False
      $MyDMMidMenuMenuStrip.Items["Delete"].Enabled = $False
      
      $MyDMMidCmdsMenuStrip.Items["New"].Enabled = $False
    }
    $MyDMMidCmdsMenuStrip.Items["Edit"].Enabled = $False
    $MyDMMidCmdsMenuStrip.Items["Delete"].Enabled = $False
    $MyDMMidCmdsMenuStrip.Items["Up"].Enabled = $False
    $MyDMMidCmdsMenuStrip.Items["Down"].Enabled = $False
    #$MyDMForm.Cursor = [System.Windows.Forms.Cursors]::Arrow

    [System.GC]::Collect()
    [System.GC]::WaitForPendingFinalizers()
  }
  Catch
  {
    Write-Debug -Message "ErrMsg: $($Error[0].Exception.Message)"
    Write-Debug -Message "Line: $($Error[0].InvocationInfo.ScriptLineNumber)"
    Write-Debug -Message "Code: $(($Error[0].InvocationInfo.Line).Trim())"
  }
  Write-Verbose -Message "Exit AfterSelect Event for `$MyDMMidMenuTreeView"
}
#endregion function Start-MyDMMidMenuTreeViewAfterSelect
$MyDMMidMenuTreeView.add_AfterSelect({Start-MyDMMidMenuTreeViewAfterSelect -Sender $This -EventArg $PSItem})

#region function Start-MyDMMidMenuTreeViewBeforeSelect
function Start-MyDMMidMenuTreeViewBeforeSelect()
{
  <#
    .SYNOPSIS
      BeforeSelect event for the MyDMMidMenuTreeView Control
    .DESCRIPTION
      BeforeSelect event for the MyDMMidMenuTreeView Control
    .PARAMETER Sender
       The Form Control that fired the Event
    .PARAMETER EventArg
       The Event Arguments for the Event
    .EXAMPLE
       Start-MyDMMidMenuTreeViewBeforeSelect -Sender $Sender -EventArg $EventArg
    .NOTES
      Original Function By Ken Sweet
    .LINK
  #>
  [CmdletBinding()]
  param (
    [parameter(Mandatory = $True)]
    [Object]$Sender,
    [parameter(Mandatory = $True)]
    [Object]$EventArg
  )
  Write-Verbose -Message "Enter BeforeSelect Event for `$MyDMMidMenuTreeView"
  Try
  {
    #$MyDMForm.Cursor = [System.Windows.Forms.Cursors]::WaitCursor
    if ($Sender.SelectedNode.Level)
    {
      $Sender.SelectedNode.Tag.Command = $Null
      if ($MyDMMidCmdsListView.Items.Count)
      {
        $Sender.SelectedNode.Tag.Command = ($MyDMMidCmdsListView.Items).Clone()
      }
      else
      {
        $Sender.SelectedNode.Tag.Command = @()
      }
    }
    #$MyDMForm.Cursor = [System.Windows.Forms.Cursors]::Arrow

    [System.GC]::Collect()
    [System.GC]::WaitForPendingFinalizers()
  }
  Catch
  {
    Write-Debug -Message "ErrMsg: $($Error[0].Exception.Message)"
    Write-Debug -Message "Line: $($Error[0].InvocationInfo.ScriptLineNumber)"
    Write-Debug -Message "Code: $(($Error[0].InvocationInfo.Line).Trim())"
  }
  Write-Verbose -Message "Exit BeforeSelect Event for `$MyDMMidMenuTreeView"
}
#endregion function Start-MyDMMidMenuTreeViewBeforeSelect
#$MyDMMidMenuTreeView.add_BeforeSelect({Start-MyDMMidMenuTreeViewBeforeSelect -Sender $This -EventArg $PSItem})

#region function Start-MyDMMidMenuTreeViewDoubleClick
function Start-MyDMMidMenuTreeViewDoubleClick()
{
  <#
    .SYNOPSIS
      DoubleClick event for the MyDMMidMenuTreeView Control
    .DESCRIPTION
      DoubleClick event for the MyDMMidMenuTreeView Control
    .PARAMETER Sender
       The Form Control that fired the Event
    .PARAMETER EventArg
       The Event Arguments for the Event
    .EXAMPLE
       Start-MyDMMidMenuTreeViewDoubleClick -Sender $Sender -EventArg $EventArg
    .NOTES
      Original Function By Ken Sweet
    .LINK
  #>
  [CmdletBinding()]
  param (
    [parameter(Mandatory = $True)]
    [Object]$Sender,
    [parameter(Mandatory = $True)]
    [Object]$EventArg
  )
  Write-Verbose -Message "Enter DoubleClick Event for `$MyDMMidMenuTreeView"
  Try
  {
    $MyDMConfig.AutoExit = 0
    #$MyDMForm.Cursor = [System.Windows.Forms.Cursors]::WaitCursor
    if ($MyDMMidMenuTreeView.SelectedNode.Level)
    {
      Start-MyDMMidMenuToolStripButtonClick -Sender ($MyDMMidMenuContextMenuStrip.Items["Edit"]) -EventArg $EventArg
    }
    #$MyDMForm.Cursor = [System.Windows.Forms.Cursors]::Arrow
    
    [System.GC]::Collect()
    [System.GC]::WaitForPendingFinalizers()
  }
  Catch
  {
    Write-Debug -Message "ErrMsg: $($Error[0].Exception.Message)"
    Write-Debug -Message "Line: $($Error[0].InvocationInfo.ScriptLineNumber)"
    Write-Debug -Message "Code: $(($Error[0].InvocationInfo.Line).Trim())"
  }
  Write-Verbose -Message "Exit DoubleClick Event for `$MyDMMidMenuTreeView"
}
#endregion function Start-MyDMMidMenuTreeViewDoubleClick
$MyDMMidMenuTreeView.add_DoubleClick({ Start-MyDMMidMenuTreeViewDoubleClick -Sender $This -EventArg $PSItem})

#region function Start-MyDMMidMenuTreeViewMouseDown
function Start-MyDMMidMenuTreeViewMouseDown()
{
  <#
    .SYNOPSIS
      MouseDown event for the MyDMMidMenuTreeView Control
    .DESCRIPTION
      MouseDown event for the MyDMMidMenuTreeView Control
    .PARAMETER Sender
       The Form Control that fired the Event
    .PARAMETER EventArg
       The Event Arguments for the Event
    .EXAMPLE
       Start-MyDMMidMenuTreeViewMouseDown -Sender $Sender -EventArg $EventArg
    .NOTES
      Original Function By Ken Sweet
    .LINK
  #>
  [CmdletBinding()]
  param (
    [parameter(Mandatory = $True)]
    [Object]$Sender,
    [parameter(Mandatory = $True)]
    [Object]$EventArg
  )
  Write-Verbose -Message "Enter MouseDown Event for `$MyDMMidMenuTreeView"
  Try
  {
    #$MyDMForm.Cursor = [System.Windows.Forms.Cursors]::WaitCursor
    $Sender.SelectedNode = $Sender.GetNodeAt($EventArg.X, $EventArg.Y)
    #$MyDMForm.Cursor = [System.Windows.Forms.Cursors]::Arrow

    [System.GC]::Collect()
    [System.GC]::WaitForPendingFinalizers()
  }
  Catch
  {
    Write-Debug -Message "ErrMsg: $($Error[0].Exception.Message)"
    Write-Debug -Message "Line: $($Error[0].InvocationInfo.ScriptLineNumber)"
    Write-Debug -Message "Code: $(($Error[0].InvocationInfo.Line).Trim())"
  }
  Write-Verbose -Message "Exit MouseDown Event for `$MyDMMidMenuTreeView"
}
#endregion function Start-MyDMMidMenuTreeViewMouseDown
$MyDMMidMenuTreeView.add_MouseDown({Start-MyDMMidMenuTreeViewMouseDown -Sender $This -EventArg $PSItem})

#region $MyDMMidMenuContextMenuStrip = System.Windows.Forms.ContextMenuStrip
Write-Verbose -Message "Creating Form Control `$MyDMMidMenuContextMenuStrip"
$MyDMMidMenuContextMenuStrip = New-Object -TypeName System.Windows.Forms.ContextMenuStrip
$MyDMMidMenuTreeView.ContextMenuStrip = $MyDMMidMenuContextMenuStrip
$MyDMMidMenuContextMenuStrip.BackColor = $MyDMColor.BackColor
$MyDMMidMenuContextMenuStrip.Font = $MyDMConfig.FontData.Regular
$MyDMMidMenuContextMenuStrip.ForeColor = $MyDMColor.ForeColor
$MyDMMidMenuContextMenuStrip.Name = "MyDMMidMenuContextMenuStrip"
$MyDMMidMenuContextMenuStrip.Text = "MyDMMidMenuContextMenuStrip"
#endregion

#region ******** $MyDMMidMenuContextMenuStrip ContextMenuStrip MenuItems ********

#region function Start-MyDMMidMenuContextMenuStripOpening
function Start-MyDMMidMenuContextMenuStripOpening()
{
  <#
    .SYNOPSIS
      Opening event for the MyDMMidMenuContextMenuStrip Control
    .DESCRIPTION
      Opening event for the MyDMMidMenuContextMenuStrip Control
    .PARAMETER Sender
       The Form Control that fired the Event
    .PARAMETER EventArg
       The Event Arguments for the Event
    .EXAMPLE
       Start-MyDMMidMenuContextMenuStripOpening -Sender $Sender -EventArg $EventArg
    .NOTES
      Original Function By Ken Sweet
    .LINK
  #>
  [CmdletBinding()]
  param (
    [parameter(Mandatory = $True)]
    [Object]$Sender,
    [parameter(Mandatory = $True)]
    [Object]$EventArg
  )
  Write-Verbose -Message "Enter Opening Event for `$MyDMMidMenuContextMenuStrip"
  Try
  {
    #$MyDMForm.Cursor = [System.Windows.Forms.Cursors]::WaitCursor
    if ($MyDMMidMenuTreeView.Nodes.Count -and (-not [string]::IsNullOrEmpty($MyDMMidMenuTreeView.SelectedNode)))
    {
      Switch ($MyDMMidMenuTreeView.SelectedNode.Level)
      {
        0
        {
          $MyDMMidMenuContextMenuStrip.Items["Export"].Visible = $False
          $MyDMMidMenuContextMenuStrip.Items["New"].Visible = $True
          $MyDMMidMenuContextMenuStrip.Items["Edit"].Visible = $False
          $MyDMMidMenuContextMenuStrip.Items["Command"].Visible = $False
          $MyDMMidMenuContextMenuStrip.Items["Delete"].Visible = $False
          $MyDMMidMenuContextMenuStrip.Items["Up"].Visible = $False
          $MyDMMidMenuContextMenuStrip.Items["Down"].Visible = $False
          Break
        }
        1
        {
          $MyDMMidMenuContextMenuStrip.Items["Export"].Visible = $True
          $MyDMMidMenuContextMenuStrip.Items["New"].Visible = ($MyDMMidMenuTreeView.SelectedNode.Parent.Tag -eq "HKLM")
          $MyDMMidMenuContextMenuStrip.Items["Edit"].Visible = $True
          $MyDMMidMenuContextMenuStrip.Items["Command"].Visible = $True
          $MyDMMidMenuContextMenuStrip.Items["Delete"].Visible = $True
          $MyDMMidMenuContextMenuStrip.Items["Up"].Visible = $False
          $MyDMMidMenuContextMenuStrip.Items["Down"].Visible = $False
          Break
        }
        2
        {
          $MyDMMidMenuContextMenuStrip.Items["Export"].Visible = $False
          $MyDMMidMenuContextMenuStrip.Items["New"].Visible = $False
          $MyDMMidMenuContextMenuStrip.Items["Edit"].Visible = $True
          $MyDMMidMenuContextMenuStrip.Items["Command"].Visible = ($MyDMMidCmdsListView.Items.Count -lt $MyDMConfig.MaxSubMenuCmds)
          $MyDMMidMenuContextMenuStrip.Items["Delete"].Visible = $True
          $MyDMMidMenuContextMenuStrip.Items["Up"].Visible = ($MyDMMidMenuTreeView.SelectedNode.Index -gt 0)
          $MyDMMidMenuContextMenuStrip.Items["Down"].Visible = ($MyDMMidMenuTreeView.SelectedNode.Index -lt ($MyDMMidMenuTreeView.SelectedNode.parent.Nodes.Count - 1))
          Break
        }
      }
    }
    else
    {
      $EventArg.Cancel = $True
    }
    #$MyDMForm.Cursor = [System.Windows.Forms.Cursors]::Arrow

    [System.GC]::Collect()
    [System.GC]::WaitForPendingFinalizers()
  }
  Catch
  {
    Write-Debug -Message "ErrMsg: $($Error[0].Exception.Message)"
    Write-Debug -Message "Line: $($Error[0].InvocationInfo.ScriptLineNumber)"
    Write-Debug -Message "Code: $(($Error[0].InvocationInfo.Line).Trim())"
  }
  Write-Verbose -Message "Exit Opening Event for `$MyDMMidMenuContextMenuStrip"
}
#endregion function Start-MyDMMidMenuContextMenuStripOpening
$MyDMMidMenuContextMenuStrip.add_Opening({Start-MyDMMidMenuContextMenuStripOpening -Sender $This -EventArg $PSItem})

(New-MenuItem -Menu $MyDMMidMenuContextMenuStrip -Name "New" -Text "New Menu" -Tag "New Menu" -DisplayStyle "ImageAndText" -Icon ([System.Drawing.Icon]([System.Convert]::FromBase64String($Newico))) -PassThru).add_Click({ Start-MyDMMidMenuToolStripButtonClick -Sender $This -EventArg $PSItem})
(New-MenuItem -Menu $MyDMMidMenuContextMenuStrip -Name "Command" -Text "New Command" -Tag "New Command" -DisplayStyle "ImageAndText" -Icon ([System.Drawing.Icon]([System.Convert]::FromBase64String($Commandico))) -PassThru).add_Click({ Start-MyDMMidMenuToolStripButtonClick -Sender $This -EventArg $PSItem})
(New-MenuItem -Menu $MyDMMidMenuContextMenuStrip -Name "Edit" -Text "Edit" -Tag "Edit" -DisplayStyle "ImageAndText" -Icon ([System.Drawing.Icon]([System.Convert]::FromBase64String($Editico))) -PassThru).add_Click({ Start-MyDMMidMenuToolStripButtonClick -Sender $This -EventArg $PSItem})
(New-MenuItem -Menu $MyDMMidMenuContextMenuStrip -Name "Up" -Text "Move Up" -Tag "Up" -DisplayStyle "ImageAndText" -Icon ([System.Drawing.Icon]([System.Convert]::FromBase64String($Upico))) -PassThru).add_Click({ Start-MyDMMidMenuToolStripButtonClick -Sender $This -EventArg $PSItem})
(New-MenuItem -Menu $MyDMMidMenuContextMenuStrip -Name "Down" -Text "Move Down" -Tag "Down" -DisplayStyle "ImageAndText" -Icon ([System.Drawing.Icon]([System.Convert]::FromBase64String($Downico))) -PassThru).add_Click({ Start-MyDMMidMenuToolStripButtonClick -Sender $This -EventArg $PSItem})
(New-MenuItem -Menu $MyDMMidMenuContextMenuStrip -Name "Export" -Text "Export Menu" -Tag "Export Menu" -DisplayStyle "ImageAndText" -Icon ([System.Drawing.Icon]([System.Convert]::FromBase64String($Exportico))) -PassThru).add_Click({ Start-MyDMMidMenuToolStripButtonClick -Sender $This -EventArg $PSItem})
(New-MenuItem -Menu $MyDMMidMenuContextMenuStrip -Name "Delete" -Text "Delete" -Tag "Delete" -DisplayStyle "ImageAndText" -Icon ([System.Drawing.Icon]([System.Convert]::FromBase64String($Deleteico))) -PassThru).add_Click({ Start-MyDMMidMenuToolStripButtonClick -Sender $This -EventArg $PSItem})

#endregion ******** $MyDMMidMenuContextMenuStrip ContextMenuStrip MenuItems ********

#endregion ******** $MyDMMidSplitContainer Panel1 Controls ********

#region ******** $MyDMMidSplitContainer Panel2 Controls ********

#region $MyDMMidCmdsToolStrip = System.Windows.Forms.MenuStrip
Write-Verbose -Message "Creating Form Control `$MyDMMidCmdsMenuStrip"
$MyDMMidCmdsMenuStrip = New-Object -TypeName System.Windows.Forms.MenuStrip
$MyDMMidSplitContainer.Panel2.Controls.Add($MyDMMidCmdsMenuStrip)
$MyDMMidCmdsMenuStrip.BackColor = $MyDMColor.BackColor
$MyDMMidCmdsMenuStrip.Dock = [System.Windows.Forms.DockStyle]::Top
$MyDMMidCmdsMenuStrip.ForeColor = $MyDMColor.ForeColor
$MyDMMidCmdsMenuStrip.Name = "MyDMMidCmdsMenuStrip"
$MyDMMidCmdsMenuStrip.Text = "MyDMMidCmdsMenuStrip"
#endregion

#region ******** $MyDMMidCmdsMenuStrip ToolStrip MenuItems ********

#region function Start-MyDMMidCmdsToolStripButtonClick
function Start-MyDMMidCmdsToolStripButtonClick()
{
  <#
    .SYNOPSIS
      Click event for the MyDMMidCmdsToolStripButton Control
    .DESCRIPTION
      Click event for the MyDMMidCmdsToolStripButton Control
    .PARAMETER Sender
       The Form Control that fired the Event
    .PARAMETER EventArg
       The Event Arguments for the Event
    .EXAMPLE
       Start-MyDMMidCmdsToolStripButtonClick -Sender $Sender -EventArg $EventArg
    .NOTES
      Original Function By Ken Sweet
    .LINK
  #>
  [CmdletBinding()]
  param (
    [parameter(Mandatory = $True)]
    [Object]$Sender,
    [parameter(Mandatory = $True)]
    [Object]$EventArg
  )
  Write-Verbose -Message "Enter Click Event for `$MyDMMidCmdsToolStripButton"
  Try
  {
    #$MyDMForm.Cursor = [System.Windows.Forms.Cursors]::WaitCursor
    switch ($Sender.Name)
    {
      "Edit"
      {
        #region ******** Edit Desktop Menu Command ********
        $MyDMStatusStrip.Items["Status"].Text = "Edit Desktop Menu Command..."
        
        $BadNames = [System.Collections.ArrayList]::New()
        $BadNames.AddRange(@($MyDMMidCmdsListView.Items | Select-Object -ExpandProperty Text | Where-Object -FilterScript { $PSItem -ne $MyDMMidCmdsListView.SelectedItems[0].Text }))
        
        # Icon, Group, & Command
        $TempCmd = $MyDMMidCmdsListView.SelectedItems[0]
        
        if (($Data = Show-MyDMEditDialog -BadNames $BadNames -ReturnVal01Text ($TempCmd.Tag.Name) -ReturnVal02Text ($TempCmd.Tag.Command) -SeparatorBefore ($TempCmd.Tag.CommandFlags -band $MyDMConfig.SeparatorBefore) -SeparatorAfter ($TempCmd.Tag.CommandFlags -band $MyDMConfig.SeparatorAfter) -IconPath ($TempCmd.Tag.IconPath) -Index ($TempCmd.Tag.Index)).DialogResult -eq [System.Windows.Forms.DialogResult]::OK)
        {
          $TempCommandFlags = 0x0
          if ($Data.SeparatorBefore)
          {
            $TempCommandFlags = $TempCommandFlags -bor $MyDMConfig.SeparatorBefore
            $SeparatorBefore = $MyDMConfig.SeparatorYes
          }
          else
          {
            $SeparatorBefore = $MyDMConfig.SeparatorNo
          }
          
          if ($Data.SeparatorAfter)
          {
            $TempCommandFlags = $TempCommandFlags -bor $MyDMConfig.SeparatorAfter
            $SeparatorAfter = $MyDMConfig.SeparatorYes
          }
          else
          {
            $SeparatorAfter = $MyDMConfig.SeparatorNo
          }
          
          ($TempCmd.CommandFlags -eq $MyDMConfig.SeparatorYes)
          
          $TempCmd.Tag.UpdateCommand($Data.ReturnVal01Text, $Data.ReturnVal02Text, $TempCommandFlags, $Data.IconPath, $Data.Index)
          $TempCmd.SubItems[0].Text = $Data.ReturnVal01Text
          $TempCmd.SubItems[1].Text = $Data.ReturnVal02Text
          $TempCmd.SubItems[2].Text = $Data.IconPath
          $TempCmd.SubItems[3].Text = $Data.Index
          $TempCmd.SubItems[4].Text = $SeparatorBefore
          $TempCmd.SubItems[5].Text = $SeparatorAfter
          
          if ($Data.Index -eq -1)
          {
            $MyDMImageList.Images[$MyDMImageList.Images.IndexOfKey($TempCmd.ImageKey)] = $MyDMImageList.Images[0]
          }
          else
          {
            $MyDMImageList.Images[$MyDMImageList.Images.IndexOfKey($TempCmd.ImageKey)] = $Data.IconSmall
          }
          
          if ($MyDMConfig.EditRegistry)
          {
            if ($MyDMMidMenuTreeView.SelectedNode.Level -eq 2)
            {
              # *****************************
              # Edit Desktop Sub Menu Command
              # *****************************
              $TempHive = $MyDMMidMenuTreeView.SelectedNode.Parent.Parent.Tag
              $TempMenuID = $MyDMMidMenuTreeView.SelectedNode.Parent.Tag.ID
              
              # Write Sub Menu Commands to Registry
              $Item = $MyDMMidCmdsListView.SelectedItems[0]
              
              $TempSubCommandName = ($MyDMConfig.PrefixSubCommand -f $TempMenuID, $MyDMMidMenuTreeView.SelectedNode.Tag.ID, $Item.Index)
              
              $CheckValue = 0
              if ($Data.Index -eq -1)
              {
                [Void]($MyDMConfig.Registry.DeleteValue($TempHive, "$($MyDMConfig.RegistrySubMenuCmds)\$TempSubCommandName", "Icon"))
              }
              else
              {
                $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetStringValue($TempHive, "$($MyDMConfig.RegistrySubMenuCmds)\$TempSubCommandName", "Icon", "$($Data.IconPath),$($Data.Index)")).Failure
              }
              $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetStringValue($TempHive, "$($MyDMConfig.RegistrySubMenuCmds)\$TempSubCommandName", "MUIVerb", $Data.ReturnVal01Text)).Failure
              $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetStringValue($TempHive, "$($MyDMConfig.RegistrySubMenuCmds)\$TempSubCommandName\Command", "", $Data.ReturnVal02Text)).Failure
              $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetDWordValue($TempHive, "$($MyDMConfig.RegistrySubMenuCmds)\$TempSubCommandName", "CommandFlags", $TempCommandFlags)).Failure
              
              if ($CheckValue)
              {
                [Void]([System.Windows.Forms.MessageBox]::Show($MyDMForm, "Error Editing Desktop Sub Menu Command. - $CheckValue", "Error: $ComputerName", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error))
              }
              
              $MyDMMidCmdsMenuStrip.Items["New"].Enabled = ($MyDMMidCmdsListView.Items.Count -lt $MyDMConfig.MaxSubMenuCmds)
            }
            else
            {
              # *************************
              # Edit Desktop Menu Command
              # *************************
              $TempHive = $MyDMMidMenuTreeView.SelectedNode.Parent.Tag
              $TempMenuID = $MyDMMidMenuTreeView.SelectedNode.Tag.ID
              
              # Write Menu Commands to Registry
              $Item = $MyDMMidCmdsListView.SelectedItems[0]
              $TempCommandName = ($MyDMConfig.PrefixCommand -f $Item.Index)
              
              $CheckValue = 0
              if ($Data.Index -eq -1)
              {
                [Void]($MyDMConfig.Registry.DeleteValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempCommandName", "Icon"))
              }
              else
              {
                $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetStringValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempCommandName", "Icon", "$($Data.IconPath),$($Data.Index)")).Failure
              }
              $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetStringValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempCommandName", "MUIVerb", $Data.ReturnVal01Text)).Failure
              $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetStringValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempCommandName\Command", "", $Data.ReturnVal02Text)).Failure
              $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetDWordValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempCommandName", "CommandFlags", $TempCommandFlags)).Failure
              
              if ($Data.SeparatorBefore)
              {
                $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetStringValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempCommandName", "SeparatorBefore", $MyDMConfig.SeparatorYes)).Failure
              }
              else
              {
                [Void]($MyDMConfig.Registry.DeleteValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempCommandName", "SeparatorBefore"))
              }
              
              if ($Data.SeparatorAfter)
              {
                $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetStringValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempCommandName", "SeparatorAfter", $MyDMConfig.SeparatorYes)).Failure
              }
              else
              {
                [Void]($MyDMConfig.Registry.DeleteValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempCommandName", "SeparatorAfter"))
              }
              
              if ($CheckValue)
              {
                [Void]([System.Windows.Forms.MessageBox]::Show($MyDMForm, "Error Editing Desktop Menu Command. - $CheckValue", "Error: $ComputerName", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error))
              }
            }
          }
        }
        #endregion ******** Edit Desktop Menu Command ********
        Break
      }
      "Delete"
      {
        #region ******** Delete Desktop Menu Command ********
        $MyDMStatusStrip.Items["Status"].Text = "Delete Desktop Menu Command(s)..."
        
        if ([System.Windows.Forms.MessageBox]::Show($MyDMForm, "Delete Selected Desktop Menu Commands?", "Delete Commands?", [System.Windows.Forms.MessageBoxButtons]::YesNo, [System.Windows.Forms.MessageBoxIcon]::Question) -eq [System.Windows.Forms.DialogResult]::Yes)
        {
          $TotalCommandsStart = $MyDMMidCmdsListView.Items.Count
          
          # Remove Deleted Commands
          $MyDMMidCmdsListView.BeginUpdate()
          $RemoveList = $MyDMMidCmdsListView.SelectedItems
          ForEach ($Remove in $RemoveList)
          {
            $MyDMImageList.Images.RemoveByKey($Remove.ImageKey)
            $MyDMMidCmdsListView.Items.Remove($Remove)
          }
          
          $TotalCommandsEnd = $MyDMMidCmdsListView.Items.Count
          
          $MyDMMidCmdsMenuStrip.Items["Edit"].Enabled = $False
          $MyDMMidCmdsMenuStrip.Items["Up"].Enabled = $False
          $MyDMMidCmdsMenuStrip.Items["Down"].Enabled = $False
          $MyDMMidCmdsMenuStrip.Items["Delete"].Enabled = $False
          $MyDMMidCmdsListView.EndUpdate()
          
          if ($MyDMConfig.EditRegistry)
          {
            if ($MyDMMidMenuTreeView.SelectedNode.Level -eq 2)
            {
              # *******************************
              # Delete Desktop Sub Menu Command
              # *******************************
              $TempHive = $MyDMMidMenuTreeView.SelectedNode.Parent.Parent.Tag
              $TempMenuID = $MyDMMidMenuTreeView.SelectedNode.Parent.Tag.ID
              
              $TempSubCommands = [System.Collections.ArrayList]::New()
              
              # Write Remaining Sub Menu Commands to Registry
              ForEach ($Item in $MyDMMidCmdsListView.Items)
              {
                $Item.ImageKey = $Item.ImageKey
                
                $TempSubCommandName = ($MyDMConfig.PrefixSubCommand -f $TempMenuID, $MyDMMidMenuTreeView.SelectedNode.Tag.ID, $Item.Index)
                [Void]$TempSubCommands.Add($TempSubCommandName)
                
                $CheckValue = 0
                if ($Item.SubItems[3].Text -eq "-1")
                {
                  [Void]($MyDMConfig.Registry.DeleteValue($TempHive, "$($MyDMConfig.RegistrySubMenuCmds)\$TempSubCommandName", "Icon"))
                }
                else
                {
                  $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetStringValue($TempHive, "$($MyDMConfig.RegistrySubMenuCmds)\$TempSubCommandName", "Icon", "$($Item.SubItems[2].Text),$($Item.SubItems[3].Text)")).Failure
                }
                $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetStringValue($TempHive, "$($MyDMConfig.RegistrySubMenuCmds)\$TempSubCommandName", "MUIVerb", $Item.SubItems[0].Text)).Failure
                $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetStringValue($TempHive, "$($MyDMConfig.RegistrySubMenuCmds)\$TempSubCommandName", "", $Item.SubItems[1].Text)).Failure
                
                $TempCommandFlags = 0x0
                if ($Item.SubItems[4].Text -eq $MyDMConfig.SeparatorYes)
                {
                  $TempCommandFlags = $TempCommandFlags -bor $MyDMConfig.SeparatorBefore
                }
                
                if ($Item.SubItems[5].Text -eq $MyDMConfig.SeparatorYes)
                {
                  $TempCommandFlags = $TempCommandFlags -bor $MyDMConfig.SeparatorAfter
                }
                
                $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetDWordValue($TempHive, "$($MyDMConfig.RegistrySubMenuCmds)\$TempSubCommandName", "CommandFlags", $TempCommandFlags)).Failure
              }
              
              $TempSubMenuName = ($MyDMConfig.PrefixMenu -f $MyDMMidMenuTreeView.SelectedNode.Index)
              $MyDMMidMenuTreeView.SelectedNode.Tag.UpdateSubCommands("$(($TempSubCommands.ToArray() -join ";"))")
              $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetStringValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempSubMenuName", "SubCommands", "$($MyDMMidMenuTreeView.SelectedNode.Tag.SubCommands)")).Failure
              
              # Delete Unused Sub Menu Commands Keys
              For ($CmdCount = $TotalCommandsEnd; $CmdCount -lt $TotalCommandsStart; $CmdCount++)
              {
                $TempSubCommandName = ($MyDMConfig.PrefixSubCommand -f $TempMenuID, $MyDMMidMenuTreeView.SelectedNode.Tag.ID, $CmdCount)
                
                $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.DeleteKey($TempHive, "$($MyDMConfig.RegistrySubMenuCmds)\$TempSubCommandName", "Command")).Failure
                $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.DeleteKey($TempHive, "$($MyDMConfig.RegistrySubMenuCmds)", $TempSubCommandName)).Failure
              }
              
              if ($CheckValue)
              {
                [Void]([System.Windows.Forms.MessageBox]::Show($MyDMForm, "Error Deleting Desktop Sub Menu Command. - $CheckValue", "Error: $ComputerName", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error))
              }
              else
              {
                [Void]([System.Windows.Forms.MessageBox]::Show($MyDMForm, "Successfully Deleted Desktop Menu Commands.", "Success: $ComputerName", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information))
              }
              
              $MyDMMidCmdsMenuStrip.Items["New"].Enabled = ($MyDMMidCmdsListView.Items.Count -lt $MyDMConfig.MaxSubMenuCmds)
            }
            else
            {
              # ***************************
              # Delete Desktop Menu Command
              # ***************************
              $TempHive = $MyDMMidMenuTreeView.SelectedNode.Parent.Tag
              $TempMenuID = $MyDMMidMenuTreeView.SelectedNode.Tag.ID
              
              # Write Remaining Menu Commands to Registry
              ForEach ($Item in $MyDMMidCmdsListView.Items)
              {
                $Item.ImageKey = $Item.ImageKey
                
                $TempCommandName = ($MyDMConfig.PrefixCommand -f $Item.Index)
                
                $CheckValue = 0
                if ($Item.SubItems[3].Text -eq "-1")
                {
                  [Void]($MyDMConfig.Registry.DeleteValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempCommandName", "Icon"))
                }
                else
                {
                  $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetStringValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempCommandName", "Icon", "$($Item.SubItems[2].Text),$($Item.SubItems[3].Text)")).Failure
                }
                $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetStringValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempCommandName", "MUIVerb", $Item.SubItems[0].Text)).Failure
                $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetStringValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempCommandName\Command", "", $Item.SubItems[1].Text)).Failure
                
                
                $TempCommandFlags = 0x0
                if ($Item.SubItems[4].Text -eq $MyDMConfig.SeparatorYes)
                {
                  $TempCommandFlags = $TempCommandFlags -bor $MyDMConfig.SeparatorBefore
                  $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetStringValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempCommandName", "SeparatorBefore", $MyDMConfig.SeparatorYes)).Failure
                }
                else
                {
                  [Void]($MyDMConfig.Registry.DeleteValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempCommandName", "SeparatorBefore"))
                }
                
                if ($Item.SubItems[5].Text -eq $MyDMConfig.SeparatorYes)
                {
                  $TempCommandFlags = $TempCommandFlags -bor $MyDMConfig.SeparatorAfter
                  $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetStringValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempCommandName", "SeparatorAfter", $MyDMConfig.SeparatorYes)).Failure
                }
                else
                {
                  [Void]($MyDMConfig.Registry.DeleteValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempCommandName", "SeparatorAfter"))
                }
                
                $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetDWordValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempCommandName", "CommandFlags", $TempCommandFlags)).Failure
              }
              
              # Delete Unused Menu Commands Keys
              For ($CmdCount = $TotalCommandsEnd; $CmdCount -lt $TotalCommandsStart; $CmdCount++)
              {
                $TempCommandName = ($MyDMConfig.PrefixCommand -f $CmdCount)
                
                if ($CmdCount -eq 0)
                {
                  [Void]($MyDMConfig.Registry.DeleteValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell", ""))
                }
                $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.DeleteKey($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempCommandName", "Command")).Failure
                $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.DeleteKey($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell", $TempCommandName)).Failure
              }
              
              if ($CheckValue)
              {
                [Void]([System.Windows.Forms.MessageBox]::Show($MyDMForm, "Error Deleting Desktop Menu Command. - $CheckValue", "Error: $ComputerName", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error))
              }
            }
          }
        }
        
        #endregion ******** Delete Desktop Menu Command ********
        Break
      }
      "Up"
      {
        #region ******** Move Desktop Menu / Sub Menu  Command Up ********
        $MyDMStatusStrip.Items["Status"].Text = "Move Desktop Menu Command Up..."
        
        $MyDMMidCmdsListView.BeginUpdate()
        $TempRowIndex = ($MyDMMidCmdsListView.SelectedIndices)[0] - 1
        $TempRow = $MyDMMidCmdsListView.Items[$TempRowIndex]
        $MyDMMidCmdsListView.Items.RemoveAt($TempRowIndex)
        $MyDMMidCmdsListView.Items.Insert(($TempRowIndex + 1), $TempRow)
        $MyDMMidCmdsListView.RedrawItems($TempRowIndex, ($TempRowIndex + 1), $False)
        $MyDMMidCmdsMenuStrip.Items["Up"].Enabled = (($MyDMMidCmdsListView.SelectedIndices.Count -eq 1) -and (($MyDMMidCmdsListView.SelectedIndices)[0] -gt 0))
        $MyDMMidCmdsMenuStrip.Items["Down"].Enabled = (($MyDMMidCmdsListView.SelectedIndices.Count -eq 1) -and (($MyDMMidCmdsListView.SelectedIndices)[0] -lt ($MyDMMidCmdsListView.Items.Count - 1)))
        $MyDMMidCmdsListView.EndUpdate()
        
        if ($MyDMConfig.EditRegistry)
        {
          if ($MyDMMidMenuTreeView.SelectedNode.Level -eq 2)
          {
            # ********************************
            # Move Desktop Sub Menu Command Up
            # ********************************
            $TempHive = $MyDMMidMenuTreeView.SelectedNode.Parent.Parent.Tag
            $TempMenuID = $MyDMMidMenuTreeView.SelectedNode.Parent.Tag.ID
            
            $CheckValue = 0
            For ($Count = $TempRowIndex; $Count -le ($TempRowIndex + 1); $Count++)
            {
              $Item = $MyDMMidCmdsListView.Items[$Count]
              
              $TempSubCommandName = ($MyDMConfig.PrefixSubCommand -f $TempMenuID, $MyDMMidMenuTreeView.SelectedNode.Tag.ID, $Item.Index)
              
              if ($Item.SubItems[3].Text -eq "-1")
              {
                [Void]($MyDMConfig.Registry.DeleteValue($TempHive, "$($MyDMConfig.RegistrySubMenuCmds)\$TempSubCommandName", "Icon"))
              }
              else
              {
                $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetStringValue($TempHive, "$($MyDMConfig.RegistrySubMenuCmds)\$TempSubCommandName", "Icon", "$($Item.SubItems[2].Text),$($Item.SubItems[3].Text)")).Failure
              }
              $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetStringValue($TempHive, "$($MyDMConfig.RegistrySubMenuCmds)\$TempSubCommandName", "MUIVerb", $Item.SubItems[0].Text)).Failure
              $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetStringValue($TempHive, "$($MyDMConfig.RegistrySubMenuCmds)\$TempSubCommandName\Command", "", $Item.SubItems[1].Text)).Failure
              
              $TempCommandFlags = 0x0
              if ($Item.SubItems[4].Text -eq $MyDMConfig.SeparatorYes)
              {
                $TempCommandFlags = $TempCommandFlags -bor $MyDMConfig.SeparatorBefore
              }
              
              if ($Item.SubItems[5].Text -eq $MyDMConfig.SeparatorYes)
              {
                $TempCommandFlags = $TempCommandFlags -bor $MyDMConfig.SeparatorAfter
              }
              
              $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetDWordValue($TempHive, "$($MyDMConfig.RegistrySubMenuCmds)\$TempSubCommandName", "CommandFlags", $TempCommandFlags)).Failure
            }
            
            if ($CheckValue)
            {
              [Void]([System.Windows.Forms.MessageBox]::Show($MyDMForm, "Error Moving Desktop Sub Menu Command Up. - $CheckValue", "Error: $ComputerName", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error))
            }
            
            $MyDMMidCmdsMenuStrip.Items["New"].Enabled = ($MyDMMidCmdsListView.Items.Count -lt $MyDMConfig.MaxSubMenuCmds)
          }
          else
          {
            # ****************************
            # Move Desktop Menu Command Up
            # ****************************
            $TempHive = $MyDMMidMenuTreeView.SelectedNode.Parent.Tag
            $TempMenuID = $MyDMMidMenuTreeView.SelectedNode.Tag.ID
            
            $CheckValue = 0
            For ($Count = $TempRowIndex; $Count -le ($TempRowIndex + 1); $Count++)
            {
              $Item = $MyDMMidCmdsListView.Items[$Count]
              
              $TempCommandName = ($MyDMConfig.PrefixCommand -f $Item.Index)
              
              if ($Item.SubItems[3].Text -eq "-1")
              {
                [Void]($MyDMConfig.Registry.DeleteValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempCommandName", "Icon"))
              }
              else
              {
                $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetStringValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempCommandName", "Icon", "$($Item.SubItems[2].Text),$($Item.SubItems[3].Text)")).Failure
              }
              $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetStringValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempCommandName", "MUIVerb", $Item.SubItems[0].Text)).Failure
              $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetStringValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempCommandName\Command", "", $Item.SubItems[1].Text)).Failure
              
              $TempCommandFlags = 0x0
              if ($Item.SubItems[4].Text -eq $MyDMConfig.SeparatorYes)
              {
                $TempCommandFlags = $TempCommandFlags -bor $MyDMConfig.SeparatorBefore
                $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetStringValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempCommandName", "SeparatorBefore", $MyDMConfig.SeparatorYes)).Failure
              }
              else
              {
                [Void]($MyDMConfig.Registry.DeleteValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempCommandName", "SeparatorBefore"))
              }
              
              if ($Item.SubItems[5].Text -eq $MyDMConfig.SeparatorYes)
              {
                $TempCommandFlags = $TempCommandFlags -bor $MyDMConfig.SeparatorAfter
                $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetStringValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempCommandName", "SeparatorAfter", $MyDMConfig.SeparatorYes)).Failure
              }
              else
              {
                [Void]($MyDMConfig.Registry.DeleteValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempCommandName", "SeparatorAfter"))
              }
              
              $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetDWordValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempCommandName", "CommandFlags", $TempCommandFlags)).Failure
            }
            
            if ($CheckValue)
            {
              [Void]([System.Windows.Forms.MessageBox]::Show($MyDMForm, "Error Moving Desktop Menu Command Up. - $CheckValue", "Error: $ComputerName", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error))
            }
          }
        }
        #endregion ******** Move Desktop Menu / Sub Menu  Command Up ********
        Break
      }
      "Down"
      {
        #region ******** Move Desktop Menu / Sub Menu Command Down ********
        $MyDMStatusStrip.Items["Status"].Text = "Move Desktop Menu Command Down..."
        
        $MyDMMidCmdsListView.BeginUpdate()
        $TempRowIndex = ($MyDMMidCmdsListView.SelectedIndices)[0] + 1
        $TempRow = $MyDMMidCmdsListView.Items[$TempRowIndex]
        $MyDMMidCmdsListView.Items.RemoveAt($TempRowIndex)
        $MyDMMidCmdsListView.Items.Insert(($TempRowIndex - 1), $TempRow)
        $MyDMMidCmdsListView.RedrawItems(($TempRowIndex - 1), $TempRowIndex, $False)
        $MyDMMidCmdsMenuStrip.Items["Up"].Enabled = (($MyDMMidCmdsListView.SelectedIndices.Count -eq 1) -and (($MyDMMidCmdsListView.SelectedIndices)[0] -gt 0))
        $MyDMMidCmdsMenuStrip.Items["Down"].Enabled = (($MyDMMidCmdsListView.SelectedIndices.Count -eq 1) -and (($MyDMMidCmdsListView.SelectedIndices)[0] -lt ($MyDMMidCmdsListView.Items.Count - 1)))
        $MyDMMidCmdsListView.EndUpdate()
        
        #$MyDMMidCmdsListView.Refresh()
        
        if ($MyDMConfig.EditRegistry)
        {
          if ($MyDMMidMenuTreeView.SelectedNode.Level -eq 2)
          {
            # **********************************
            # Move Desktop Sub Menu Command Down
            # **********************************
            $TempHive = $MyDMMidMenuTreeView.SelectedNode.Parent.Parent.Tag
            $TempMenuID = $MyDMMidMenuTreeView.SelectedNode.Parent.Tag.ID
            
            For ($Count = ($TempRowIndex - 1); $Count -le $TempRowIndex; $Count++)
            {
              $Item = $MyDMMidCmdsListView.Items[$Count]
              
              $TempSubCommandName = ($MyDMConfig.PrefixSubCommand -f $TempMenuID, $MyDMMidMenuTreeView.SelectedNode.Tag.ID, $Item.Index)
              
              $CheckValue = 0
              if ($Item.SubItems[3].Text -eq "-1")
              {
                [Void]($MyDMConfig.Registry.DeleteValue($TempHive, "$($MyDMConfig.RegistrySubMenuCmds)\$TempSubCommandName", "Icon"))
              }
              else
              {
                $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetStringValue($TempHive, "$($MyDMConfig.RegistrySubMenuCmds)\$TempSubCommandName", "Icon", "$($Item.SubItems[2].Text),$($Item.SubItems[3].Text)")).Failure
              }
              $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetStringValue($TempHive, "$($MyDMConfig.RegistrySubMenuCmds)\$TempSubCommandName", "MUIVerb", $Item.SubItems[0].Text)).Failure
              $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetStringValue($TempHive, "$($MyDMConfig.RegistrySubMenuCmds)\$TempSubCommandName\Command", "", $Item.SubItems[1].Text)).Failure
              
              $TempCommandFlags = 0x0
              if ($Item.SubItems[4].Text -eq $MyDMConfig.SeparatorYes)
              {
                $TempCommandFlags = $TempCommandFlags -bor $MyDMConfig.SeparatorBefore
              }
              
              if ($Item.SubItems[5].Text -eq $MyDMConfig.SeparatorYes)
              {
                $TempCommandFlags = $TempCommandFlags -bor $MyDMConfig.SeparatorAfter
              }
              
              $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetDWordValue($TempHive, "$($MyDMConfig.RegistrySubMenuCmds)\$TempSubCommandName", "CommandFlags", $TempCommandFlags)).Failure
            }
            
            if ($CheckValue)
            {
              [Void]([System.Windows.Forms.MessageBox]::Show($MyDMForm, "Error Moving Desktop Sub Menu Command Down. - $CheckValue", "Error: $ComputerName", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error))
            }
            
            $MyDMMidCmdsMenuStrip.Items["New"].Enabled = ($MyDMMidCmdsListView.Items.Count -lt $MyDMConfig.MaxSubMenuCmds)
          }
          else
          {
            # ******************************
            # Move Desktop Menu Command Down
            # ******************************
            $TempHive = $MyDMMidMenuTreeView.SelectedNode.Parent.Tag
            $TempMenuID = $MyDMMidMenuTreeView.SelectedNode.Tag.ID
            
            For ($Count = ($TempRowIndex - 1); $Count -le $TempRowIndex; $Count++)
            {
              $Item = $MyDMMidCmdsListView.Items[$Count]
              
              $TempCommandName = ($MyDMConfig.PrefixCommand -f $Item.Index)
              
              $CheckValue = 0
              if ($Item.SubItems[3].Text -eq "-1")
              {
                [Void]($MyDMConfig.Registry.DeleteValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempCommandName", "Icon"))
              }
              else
              {
                $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetStringValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempCommandName", "Icon", "$($Item.SubItems[2].Text),$($Item.SubItems[3].Text)")).Failure
              }
              $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetStringValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempCommandName", "MUIVerb", $Item.SubItems[0].Text)).Failure
              $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetStringValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempCommandName\Command", "", $Item.SubItems[1].Text)).Failure
              
              $TempCommandFlags = 0x0
              if ($Item.SubItems[4].Text -eq $MyDMConfig.SeparatorYes)
              {
                $TempCommandFlags = $TempCommandFlags -bor $MyDMConfig.SeparatorBefore
                $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetStringValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempCommandName", "SeparatorBefore", $MyDMConfig.SeparatorYes)).Failure
              }
              else
              {
                [Void]($MyDMConfig.Registry.DeleteValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempCommandName", "SeparatorBefore"))
              }
              
              if ($Item.SubItems[5].Text -eq $MyDMConfig.SeparatorYes)
              {
                $TempCommandFlags = $TempCommandFlags -bor $MyDMConfig.SeparatorAfter
                $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetStringValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempCommandName", "SeparatorAfter", $MyDMConfig.SeparatorYes)).Failure
              }
              else
              {
                [Void]($MyDMConfig.Registry.DeleteValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempCommandName", "SeparatorAfter"))
              }
              
              $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetDWordValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempCommandName", "CommandFlags", $TempCommandFlags)).Failure
            }
            
            if ($CheckValue)
            {
              [Void]([System.Windows.Forms.MessageBox]::Show($MyDMForm, "Error Moving Desktop Menu Command Down. - $CheckValue", "Error: $ComputerName", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error))
            }
          }
        }
        #endregion ******** Move Desktop Menu / Sub Menu Command Down ********
        Break
      }
      "New"
      {
        $MyDMStatusStrip.Items["Status"].Text = "Add New Desktop Menu Command..."
        
        # ***********************************
        # Add Desktop Menu \ Sub Menu Command
        # ***********************************
        New-MyDMMenuCommand
        
        Break
      }
      "Help"
      {
        $MyDMStatusStrip.Items["Status"].Text = "Viewing My Desktop Menu Help..."
        
        Show-MyDMHelpDialog
        Break
      }
      "Exit"
      {
        $MyDMForm.Close()
        Break
      }
    }
    
    if ($MyDMMidCmdsListView.Items.Count)
    {
      $MyDMMidMenuTreeView.SelectedNode.Tag.Command = ($MyDMMidCmdsListView.Items).Clone()
    }
    else
    {
      if ($MyDMMidMenuTreeView.SelectedNode.Level)
      {
        $MyDMMidMenuTreeView.SelectedNode.Tag.Command = @()
      }
    }
    
    $MyDMStatusStrip.Items["Status"].Text = $MyDMConfig.ScriptName
    #$MyDMForm.Cursor = [System.Windows.Forms.Cursors]::Arrow
    
    [System.GC]::Collect()
    [System.GC]::WaitForPendingFinalizers()
  }
  Catch
  {
    Write-Debug -Message "ErrMsg: $($Error[0].Exception.Message)"
    Write-Debug -Message "Line: $($Error[0].InvocationInfo.ScriptLineNumber)"
    Write-Debug -Message "Code: $(($Error[0].InvocationInfo.Line).Trim())"
  }
  Write-Verbose -Message "Exit Click Event for `$MyDMMidCmdsToolStripButton"
}
#endregion function Start-MyDMMidCmdsToolStripButtonClick

(New-MenuItem -Disable -Menu $MyDMMidCmdsMenuStrip -Name "New" -Text "New" -Tag "New" -DisplayStyle "ImageAndText" -Icon ([System.Drawing.Icon]([System.Convert]::FromBase64String($Commandico))) -PassThru).add_Click({ Start-MyDMMidCmdsToolStripButtonClick -Sender $This -EventArg $PSItem})
(New-MenuItem -Disable -Menu $MyDMMidCmdsMenuStrip -Name "Edit" -Text "Edit" -Tag "Edit" -DisplayStyle "ImageAndText" -Icon ([System.Drawing.Icon]([System.Convert]::FromBase64String($Editico))) -PassThru).add_Click({ Start-MyDMMidCmdsToolStripButtonClick -Sender $This -EventArg $PSItem})
(New-MenuItem -Disable -Menu $MyDMMidCmdsMenuStrip -Name "Up" -Text "Up" -Tag "Up" -DisplayStyle "ImageAndText" -Icon ([System.Drawing.Icon]([System.Convert]::FromBase64String($Upico))) -PassThru).add_Click({ Start-MyDMMidCmdsToolStripButtonClick -Sender $This -EventArg $PSItem})
(New-MenuItem -Disable -Menu $MyDMMidCmdsMenuStrip -Name "Down" -Text "Down" -Tag "Down" -DisplayStyle "ImageAndText" -Icon ([System.Drawing.Icon]([System.Convert]::FromBase64String($Downico))) -PassThru).add_Click({ Start-MyDMMidCmdsToolStripButtonClick -Sender $This -EventArg $PSItem})
(New-MenuItem -Disable -Menu $MyDMMidCmdsMenuStrip -Name "Delete" -Text "Delete" -Tag "Delete" -DisplayStyle "ImageAndText" -Icon ([System.Drawing.Icon]([System.Convert]::FromBase64String($Deleteico))) -PassThru).add_Click({ Start-MyDMMidCmdsToolStripButtonClick -Sender $This -EventArg $PSItem})
(New-MenuItem -Disable -Menu $MyDMMidCmdsMenuStrip -Name "Help" -Text "Help" -Tag "Help" -DisplayStyle "ImageAndText" -Icon ([System.Drawing.Icon]([System.Convert]::FromBase64String($Helpico))) -PassThru).add_Click({ Start-MyDMMidCmdsToolStripButtonClick -Sender $This -EventArg $PSItem})
(New-MenuItem -Disable -Menu $MyDMMidCmdsMenuStrip -Name "Exit" -Text "Exit" -Tag "Exit" -DisplayStyle "ImageAndText" -Icon ([System.Drawing.Icon]([System.Convert]::FromBase64String($Exitico))) -PassThru).add_Click({ Start-MyDMMidCmdsToolStripButtonClick -Sender $This -EventArg $PSItem})

#endregion ******** $MyDMMidCmdsMenuStrip ToolStrip MenuItems ********

#region $MyDMMidCmdsListView = System.Windows.Forms.ListView
Write-Verbose -Message "Creating Form Control `$MyDMMidCmdsListView"
$MyDMMidCmdsListView = New-Object -TypeName System.Windows.Forms.ListView
$MyDMMidSplitContainer.Panel2.Controls.Add($MyDMMidCmdsListView)
$MyDMMidCmdsListView.BackColor = $MyDMColor.TextBackColor
$MyDMMidCmdsListView.BorderStyle = [System.Windows.Forms.BorderStyle]::None
$MyDMMidCmdsListView.CheckBoxes = $False
$MyDMMidCmdsListView.Font = $MyDMConfig.FontData.Bold
$MyDMMidCmdsListView.ForeColor = $MyDMColor.TextForeColor
$MyDMMidCmdsListView.FullRowSelect = $True
$MyDMMidCmdsListView.GridLines = $True
$MyDMMidCmdsListView.HeaderStyle = [System.Windows.Forms.ColumnHeaderStyle]::Nonclickable
$MyDMMidCmdsListView.HideSelection = $False
$MyDMMidCmdsListView.Location = New-Object -TypeName System.Drawing.Point(0, $MyDMMidCmdsMenuStrip.Bottom)
$MyDMMidCmdsListView.MultiSelect = $True
$MyDMMidCmdsListView.Name = "MyDMMidCmdsListView"
$MyDMMidCmdsListView.Size = New-Object -TypeName System.Drawing.Size(($MyDMMidSplitContainer.Panel2.ClientSize.Width - $MyDMConfig.FormSpacer), ($MyDMMidSplitContainer.Panel2.ClientSize.Height - ($MyDMMidCmdsListView.Top + $MyDMConfig.FormSpacer)))
$MyDMMidCmdsListView.SmallImageList = $MyDMImageList
$MyDMMidCmdsListView.Sorting = [System.Windows.Forms.SortOrder]::None
$MyDMMidCmdsListView.Text = "MyDMMidCmdsListView"
$MyDMMidCmdsListView.View = [System.Windows.Forms.View]::Details
#endregion

$MyDMMidCmdsListView.Anchor = [System.Windows.Forms.AnchorStyles]("Top", "Left", "Bottom", "Right")

New-ColumnHeader -ListView $MyDMMidCmdsListView -Text "Command Name" -Width -2
New-ColumnHeader -ListView $MyDMMidCmdsListView -Text "Command Line" -Width -2
New-ColumnHeader -ListView $MyDMMidCmdsListView -Text "Icon" -Width -2
New-ColumnHeader -ListView $MyDMMidCmdsListView -Text "Index" -Width -2
New-ColumnHeader -ListView $MyDMMidCmdsListView -Text "Separator Before" -Width -2
New-ColumnHeader -ListView $MyDMMidCmdsListView -Text "Separator After" -Width -2

#region function Start-MyDMMidCmdsListViewDoubleClick
function Start-MyDMMidCmdsListViewDoubleClick()
{
  <#
    .SYNOPSIS
      DoubleClick event for the MyDMMidCmdsListView Control
    .DESCRIPTION
      DoubleClick event for the MyDMMidCmdsListView Control
    .PARAMETER Sender
       The Form Control that fired the Event
    .PARAMETER EventArg
       The Event Arguments for the Event
    .EXAMPLE
       Start-MyDMMidCmdsListViewDoubleClick -Sender $Sender -EventArg $EventArg
    .NOTES
      Original Function By Ken Sweet
    .LINK
  #>
  [CmdletBinding()]
  param (
    [parameter(Mandatory = $True)]
    [Object]$Sender,
    [parameter(Mandatory = $True)]
    [Object]$EventArg
  )
  Write-Verbose -Message "Enter DoubleClick Event for `$MyDMMidCmdsListView"
  Try
  {
    $MyDMConfig.AutoExit = 0
    #$MyDMForm.Cursor = [System.Windows.Forms.Cursors]::WaitCursor
    Start-MyDMMidCmdsToolStripButtonClick -Sender ($MyDMMidCmdsContextMenuStrip.Items["Edit"]) -EventArg ""
    #$MyDMForm.Cursor = [System.Windows.Forms.Cursors]::Arrow

    [System.GC]::Collect()
    [System.GC]::WaitForPendingFinalizers()
  }
  Catch
  {
    Write-Debug -Message "ErrMsg: $($Error[0].Exception.Message)"
    Write-Debug -Message "Line: $($Error[0].InvocationInfo.ScriptLineNumber)"
    Write-Debug -Message "Code: $(($Error[0].InvocationInfo.Line).Trim())"
  }
  Write-Verbose -Message "Exit DoubleClick Event for `$MyDMMidCmdsListView"
}
#endregion function Start-MyDMMidCmdsListViewDoubleClick
$MyDMMidCmdsListView.add_DoubleClick({Start-MyDMMidCmdsListViewDoubleClick -Sender $This -EventArg $PSItem})



#region function Start-MyDMMidCmdsListViewSelectedIndexChanged
function Start-MyDMMidCmdsListViewSelectedIndexChanged()
{
  <#
    .SYNOPSIS
      SelectedIndexChanged event for the MyDMMidCmdsListView Control
    .DESCRIPTION
      SelectedIndexChanged event for the MyDMMidCmdsListView Control
    .PARAMETER Sender
       The Form Control that fired the Event
    .PARAMETER EventArg
       The Event Arguments for the Event
    .EXAMPLE
       Start-MyDMMidCmdsListViewSelectedIndexChanged -Sender $Sender -EventArg $EventArg
    .NOTES
      Original Function By Ken Sweet
    .LINK
  #>
  [CmdletBinding()]
  param (
    [parameter(Mandatory = $True)]
    [Object]$Sender,
    [parameter(Mandatory = $True)]
    [Object]$EventArg
  )
  Write-Verbose -Message "Enter SelectedIndexChanged Event for `$MyDMMidCmdsListView"
  Try
  {
    #$MyDMForm.Cursor = [System.Windows.Forms.Cursors]::WaitCursor
    if ($MyDMMidCmdsListView.SelectedIndices.Count)
    {
      $MyDMMidCmdsMenuStrip.Items["Edit"].Enabled = ($MyDMMidCmdsListView.SelectedIndices.Count -eq 1)
      $MyDMMidCmdsMenuStrip.Items["Delete"].Enabled = ($MyDMMidCmdsListView.SelectedIndices.Count -gt 0)
      $MyDMMidCmdsMenuStrip.Items["Up"].Enabled = (($MyDMMidCmdsListView.SelectedIndices.Count -eq 1) -and (($MyDMMidCmdsListView.SelectedIndices)[0] -gt 0))
      $MyDMMidCmdsMenuStrip.Items["Down"].Enabled = (($MyDMMidCmdsListView.SelectedIndices.Count -eq 1) -and (($MyDMMidCmdsListView.SelectedIndices)[0] -lt ($MyDMMidCmdsListView.Items.Count - 1)))
    }
    else
    {
      $MyDMMidCmdsMenuStrip.Items["Edit"].Enabled = $False
      $MyDMMidCmdsMenuStrip.Items["Delete"].Enabled = $False
      $MyDMMidCmdsMenuStrip.Items["Up"].Enabled = $False
      $MyDMMidCmdsMenuStrip.Items["Down"].Enabled = $False
    }
    #$MyDMForm.Cursor = [System.Windows.Forms.Cursors]::Arrow

    [System.GC]::Collect()
    [System.GC]::WaitForPendingFinalizers()
  }
  Catch
  {
    Write-Debug -Message "ErrMsg: $($Error[0].Exception.Message)"
    Write-Debug -Message "Line: $($Error[0].InvocationInfo.ScriptLineNumber)"
    Write-Debug -Message "Code: $(($Error[0].InvocationInfo.Line).Trim())"
  }
  Write-Verbose -Message "Exit SelectedIndexChanged Event for `$MyDMMidCmdsListView"
}
#endregion function Start-MyDMMidCmdsListViewSelectedIndexChanged
$MyDMMidCmdsListView.add_SelectedIndexChanged({Start-MyDMMidCmdsListViewSelectedIndexChanged -Sender $This -EventArg $PSItem})

#region $MyDMMidCmdsContextMenuStrip = System.Windows.Forms.ContextMenuStrip
Write-Verbose -Message "Creating Form Control `$MyDMMidCmdsContextMenuStrip"
$MyDMMidCmdsContextMenuStrip = New-Object -TypeName System.Windows.Forms.ContextMenuStrip
$MyDMMidCmdsListView.ContextMenuStrip = $MyDMMidCmdsContextMenuStrip
$MyDMMidCmdsContextMenuStrip.BackColor = $MyDMColor.BackColor
$MyDMMidCmdsContextMenuStrip.Font = $MyDMConfig.FontData.Regular
$MyDMMidCmdsContextMenuStrip.ForeColor = $MyDMColor.ForeColor
$MyDMMidCmdsContextMenuStrip.Name = "MyDMMidCmdsContextMenuStrip"
$MyDMMidCmdsContextMenuStrip.Text = "MyDMMidCmdsContextMenuStrip"
#endregion

#region ******** $MyDMMidCmdsContextMenuStrip ContextMenuStrip MenuItems ********

#region function Start-MyDMMidCmdsContextMenuStripOpening
function Start-MyDMMidCmdsContextMenuStripOpening()
{
  <#
    .SYNOPSIS
      Opening event for the MyDMMidCmdsContextMenuStrip Control
    .DESCRIPTION
      Opening event for the MyDMMidCmdsContextMenuStrip Control
    .PARAMETER Sender
       The Form Control that fired the Event
    .PARAMETER EventArg
       The Event Arguments for the Event
    .EXAMPLE
       Start-MyDMMidCmdsContextMenuStripOpening -Sender $Sender -EventArg $EventArg
    .NOTES
      Original Function By Ken Sweet
    .LINK
  #>
  [CmdletBinding()]
  param (
    [parameter(Mandatory = $True)]
    [Object]$Sender,
    [parameter(Mandatory = $True)]
    [Object]$EventArg
  )
  Write-Verbose -Message "Enter Opening Event for `$MyDMMidCmdsContextMenuStrip"
  Try
  {
    #$MyDMForm.Cursor = [System.Windows.Forms.Cursors]::WaitCursor
    if ($MyDMMidMenuTreeView.SelectedNode.Level -gt 0)
    {
      $ShowMenu = ((($MyDMMidCmdsListView.Items.Count -lt $MyDMConfig.MaxSubMenuCmds) -and ($MyDMMidMenuTreeView.SelectedNode.Level -eq 2)) -or ($MyDMMidMenuTreeView.SelectedNode.Level -eq 1))
      $MyDMMidCmdsContextMenuStrip.Items["New"].Visible = $ShowMenu
      if (($MyDMMidCmdsListView.SelectedIndices.Count -eq 0) -and (-not $ShowMenu))
      {
        $EventArg.Cancel = $True
      }
      else
      {
        $MyDMMidCmdsContextMenuStrip.Items["Edit"].Visible = ($MyDMMidCmdsListView.SelectedIndices.Count -eq 1)
        $MyDMMidCmdsContextMenuStrip.Items["Delete"].Visible = ($MyDMMidCmdsListView.SelectedIndices.Count -gt 0)
        $MyDMMidCmdsContextMenuStrip.Items["Up"].Visible = (($MyDMMidCmdsListView.SelectedIndices.Count -eq 1) -and (($MyDMMidCmdsListView.SelectedIndices)[0] -gt 0))
        $MyDMMidCmdsContextMenuStrip.Items["Down"].Visible = (($MyDMMidCmdsListView.SelectedIndices.Count -eq 1) -and (($MyDMMidCmdsListView.SelectedIndices)[0] -lt ($MyDMMidCmdsListView.Items.Count - 1)))
      }
    }
    else
    {
      Write-Host -Object "Cancel 1"
      $EventArg.Cancel = $True
    }
    #$MyDMForm.Cursor = [System.Windows.Forms.Cursors]::Arrow

    [System.GC]::Collect()
    [System.GC]::WaitForPendingFinalizers()
  }
  Catch
  {
    Write-Debug -Message "ErrMsg: $($Error[0].Exception.Message)"
    Write-Debug -Message "Line: $($Error[0].InvocationInfo.ScriptLineNumber)"
    Write-Debug -Message "Code: $(($Error[0].InvocationInfo.Line).Trim())"
  }
  Write-Verbose -Message "Exit Opening Event for `$MyDMMidCmdsContextMenuStrip"
}
#endregion function Start-MyDMMidCmdsContextMenuStripOpening
$MyDMMidCmdsContextMenuStrip.add_Opening({Start-MyDMMidCmdsContextMenuStripOpening -Sender $This -EventArg $PSItem})

(New-MenuItem -Menu $MyDMMidCmdsContextMenuStrip -Name "New" -Text "New Command" -Tag "New Command" -DisplayStyle "ImageAndText" -Icon ([System.Drawing.Icon]([System.Convert]::FromBase64String($Commandico))) -PassThru).add_Click({ Start-MyDMMidCmdsToolStripButtonClick -Sender $This -EventArg $PSItem})
(New-MenuItem -Menu $MyDMMidCmdsContextMenuStrip -Name "Edit" -Text "Edit" -Tag "Edit" -DisplayStyle "ImageAndText" -Icon ([System.Drawing.Icon]([System.Convert]::FromBase64String($Editico))) -PassThru).add_Click({ Start-MyDMMidCmdsToolStripButtonClick -Sender $This -EventArg $PSItem})
(New-MenuItem -Menu $MyDMMidCmdsContextMenuStrip -Name "Up" -Text "Move Up" -Tag "Up" -DisplayStyle "ImageAndText" -Icon ([System.Drawing.Icon]([System.Convert]::FromBase64String($Upico))) -PassThru).add_Click({ Start-MyDMMidCmdsToolStripButtonClick -Sender $This -EventArg $PSItem})
(New-MenuItem -Menu $MyDMMidCmdsContextMenuStrip -Name "Down" -Text "Move Down" -Tag "Down" -DisplayStyle "ImageAndText" -Icon ([System.Drawing.Icon]([System.Convert]::FromBase64String($Downico))) -PassThru).add_Click({ Start-MyDMMidCmdsToolStripButtonClick -Sender $This -EventArg $PSItem})
(New-MenuItem -Menu $MyDMMidCmdsContextMenuStrip -Name "Delete" -Text "Delete" -Tag "Delete" -DisplayStyle "ImageAndText" -Icon ([System.Drawing.Icon]([System.Convert]::FromBase64String($Deleteico))) -PassThru).add_Click({ Start-MyDMMidCmdsToolStripButtonClick -Sender $This -EventArg $PSItem})

#endregion ******** $MyDMMidCmdsContextMenuStrip ContextMenuStrip MenuItems ********

#endregion ******** $MyDMMidSplitContainer Panel2 Controls ********

#region $MyDMTopPanel = System.Windows.Forms.Panel
Write-Verbose -Message "Creating Form Control `$MyDMTopPanel"
$MyDMTopPanel = New-Object -TypeName System.Windows.Forms.Panel
$MyDMForm.Controls.Add($MyDMTopPanel)
$MyDMTopPanel.BackColor = $MyDMColor.BackColor
$MyDMTopPanel.Dock = [System.Windows.Forms.DockStyle]::Top
$MyDMTopPanel.ForeColor = $MyDMColor.ForeColor
$MyDMTopPanel.Name = "MyDMTopPanel"
$MyDMTopPanel.Text = "MyDMTopPanel"
#endregion

#region ******** $MyDMTopPanel Controls ********

#region $MyDMTopAppNameLabel = System.Windows.Forms.Label
Write-Verbose -Message "Creating Form Control `$MyDMTopAppNameLabel"
$MyDMTopAppNameLabel = New-Object -TypeName System.Windows.Forms.Label
$MyDMTopPanel.Controls.Add($MyDMTopAppNameLabel)
$MyDMTopAppNameLabel.BackColor = $MyDMColor.TitleBackColor
$MyDMTopAppNameLabel.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
$MyDMTopAppNameLabel.Font = New-Object -TypeName System.Drawing.Font($MyDMConfig.FontFamily, ($MyDMConfig.FontSize * 1.5), [System.Drawing.FontStyle]::Bold, [System.Drawing.GraphicsUnit]::Point)
$MyDMTopAppNameLabel.ForeColor = $MyDMColor.TitleForeColor
$MyDMTopAppNameLabel.Location = New-Object -TypeName System.Drawing.Point($MyDMConfig.FormSpacer, $MyDMConfig.FormSpacer)
$MyDMTopAppNameLabel.Name = "MyDMTopAppNameLabel"
$MyDMTopAppNameLabel.Text = $MyDMForm.Text
$MyDMTopAppNameLabel.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
#endregion
$MyDMTopAppNameLabel.Size = New-Object -TypeName System.Drawing.Size(($MyDMTopPanel.ClientSize.Width - ($MyDMConfig.FormSpacer * 2)), $MyDMTopAppNameLabel.PreferredHeight)

$MyDMTopPanel.ClientSize = New-Object -TypeName System.Drawing.Size(($($MyDMTopPanel.Controls[$MyDMTopPanel.Controls.Count - 1]).Right + $MyDMConfig.FormSpacer), ($($MyDMTopPanel.Controls[$MyDMTopPanel.Controls.Count - 1]).Bottom + $MyDMConfig.FormSpacer))

$MyDMTopAppNameLabel.Anchor = [System.Windows.Forms.AnchorStyles]("Top", "Left", "Bottom", "Right")

#endregion ******** $MyDMTopPanel Controls ********

#region $MyDMStatusStrip = System.Windows.Forms.StatusStrip
Write-Verbose -Message "Creating Form Control `$MyDMStatusStrip"
$MyDMStatusStrip = New-Object -TypeName System.Windows.Forms.StatusStrip
$MyDMForm.Controls.Add($MyDMStatusStrip)
$MyDMStatusStrip.BackColor = $MyDMColor.BackColor
$MyDMStatusStrip.Dock = [System.Windows.Forms.DockStyle]::Bottom
$MyDMStatusStrip.Font = $MyDMConfig.FontData.Regular
$MyDMStatusStrip.ForeColor = $MyDMColor.ForeColor
$MyDMStatusStrip.Name = "MyDMStatusStrip"
$MyDMStatusStrip.TabStop = $False
$MyDMStatusStrip.Text = "MyDMStatusStrip"
#endregion

#region ******** $MyDMStatusStrip StatusStrip MenuItems ********

New-MenuLabel -Menu $MyDMStatusStrip -Name "Status" -Text $MyDMForm.Text

#endregion ******** $MyDMStatusStrip StatusStrip MenuItems ********

$MyDMForm.ClientSize = New-Object -TypeName System.Drawing.Size(($($MyDMForm.Controls[$MyDMForm.Controls.Count - 1]).Right + $MyDMConfig.FormSpacer), ($($MyDMForm.Controls[$MyDMForm.Controls.Count - 1]).Bottom + $MyDMConfig.FormSpacer))

#endregion ******** $MyDMForm Controls ********

#endregion ******** $MyDMForm ********  

#Scale-MyForm -Control $MyDMForm -Scale ($MyDMConfig.FontData.Ratio * 2)
#Scale-MyForm -Control $MyDMMidMenuContextMenuStrip -Scale ($MyDMConfig.FontData.Ratio * 2)
#Scale-MyForm -Control $MyDMMidCmdsContextMenuStrip -Scale ($MyDMConfig.FontData.Ratio * 2)

[System.Windows.Forms.Application]::EnableVisualStyles()
[System.Windows.Forms.Application]::Run($MyDMForm)

$MyDMFormComponents.Dispose()
$MyDMForm.Dispose()

if ($MyDMConfig.Production)
{
  [Environment]::Exit(0)
}
