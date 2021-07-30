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
    [Void]([System.Windows.Forms.MessageBox]::Show("CimCmdlets Module not Found.", "Error: CimCmdlets", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error))
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
$MyDMConfig.ScriptVersion = "3.1.5.0"
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
    [System.Windows.Forms.ListViewGroup]$Group,
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
    $GZipStream = New-Object -TypeName System.IO.Compression.GZipStream($MemoryStream, [System.IO.Compression.CompressionMode]::XDecompress)
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
      $MaxLength01 = 50
      $ReturnVal02Label = "Menu Name"
      $ReturnVal02ReadOnly = $False
      $ShowSperarator = $False
      $MaxLength02 = 50
      Break
    }
    "SubMenu"
    {
      $TitleName = "Sub Menu"
      $ReturnName = "Desktop Menu Sub Menu"
      $ReturnVals = 1
      $ReturnVal01Label = "Sub Menu Name"
      $ReturnVal01ReadOnly = $False
      $MaxLength01 = 50
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
      $MaxLength01 = 50
      $ReturnVal02Label = "Command Line"
      $ReturnVal02ReadOnly = $False
      $MaxLength02 = 1024
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
    $MyDMEReturnVal02TextBox.MaxLength = $MaxLength02
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
  $MyDMEReturnVal01TextBox.MaxLength = $MaxLength01
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
          $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetExpandedStringValue($TempHive, "$($MyDMConfig.RegistrySubMenuCmds)\$TempSubCommandName\Command", "", "$($Data.ReturnVal02Text)")).Failure
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
          $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetExpandedStringValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempCommandName\Command", "", $Data.ReturnVal02Text)).Failure
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
H4sIAAAAAAAEAOy9za7rSLLvNxegd9hjA27k9wfu8NrDCxg+NjypSX52F051V9+qavc9OOgn88CP5FdwRCa1RC1JSx+ktkjuYFRxr0WlfsxIprjyr0hG/n//z//7nz/99kflP4W//f5z26W//5kLLX7KpVb2099+
/cfP6de//j38gQd+CX/7M2dS/udP9de//fFH/AV+YD/Vv/38y081/SX89nv5g337P8Jffv1r+C//gtf46Wvi27/9x1/jr7/8l3/9a7/7z5/+p5/+XP5Wfgt//Prbt//95/SXkgX7xtmf2J+4k0b866f/++fyz3//
+W9Z/fSPxL/tdz/9PfyWf/o9CMZ++v0XYQ3s//qPX/7gP/339FNsVflduZ+wlv7b/5p//uN//m//8b+U3//9j1///t/K3/7x+08RSwiFnP3uK14r8FO8Avn27effv4Vv//jj519+/uM/vv3x67f0Wwl/lG/hb/lb
gbd8+z9/L7+13/7tP37/o/z12wAAN//8lz++/ddffk7//u2/QhOW//HHt0b9Uz/l/wXe/vrP36EVvv0Po7798+c//vLtf/v1n+W3f/tL+eWXb/pP7Bs01l+AAnyoxG/lv//j599Kxjr89o+/ffvjL+XjXMhtDvz6
25+ueKzYqAX/86e//5z+wMsC//79t1///q+f/vnX8keoP/9SHB77J9eGM/zpL9Yx3Q79+dfwizOqH8VflISLuN8xzhjzDDcpQ81Mtp8Zj8efmRr+lVDawb96+D0xkX0tqjDRjwGPsQi/HbZDSQvvVKdkxVnEgikx
JuD1Rhm2A7Xx2ibcUJWhFL6j4+A/93E+VlX1cLYr25EHhCIEd8LwxBXsM9ef9mXYm7ZXo58/Xt3vxr992h/ep4FnLp4B9/rjZ9N4l155et945+e+Xpvr9Ssf9VOfGOiv/bQ3J0fcp705/Dy03+fXz8uaL8voM149
2ZvhZ/9pb86OfNoD77533CKFViYMvDDeCzbszejnwz5+vd/v7il1x76fLV3ntbpGwT+OpP5zO56u1XjgDfQ7qOf7NN4PvPGxPOz5p325Y1+Bd0cpuE+Ytte39sA7PWYkw58f3Z/ynmNc2gNPtt8+7znszeiIuVDm
wv4qT9zz7gd4T+7v4nGh7t0D7+6yZ3sBe3ORJ+7YS7gT39qLB3jn+/Mav+d6HHvkcT9uh9F+8Fde3R/bRp3t9fkeeOevmLP9lXeP9qaVhL+X/d8J+0s8B39XP+/dE3v4+3bhlXP2V3s77LFedqjf8Nv4lef2n3jH
vTvZ43l89+jr/eDv+FiYsh94kxjD3g88f+c7Yit5vk/jn4EX2rFr+/jlq8d97PsTXhzt09nP18qc7IGHNch37NPZ/kLJG7wy2tcLe6iTYiLBnuMRxTvv8Ntoz4af02N74D34ju/EkyLjHnj5+NvVPYyxlbpnD7zL
r+iTPYwClTnb2/PjwDu+YkGOauVH+yBhvKbisBej/fF4GO3hftD+de3d9mOvoFVAc0gch3nTrCnGphWvacvP+nKOjXjEIx7xiEc84hGPeMQjHvGIt2SeTmidJyxGyeagdt5cJOItkMc7T7f+ImboNQv3l3jEIx7x
iEc84hGPeMRbOS+KZgzt5AhHO/D6b/2VfkQXNPypz6t8Vf2ItzFemwVtMu6Fn4H30EY84hGPeMQjHvGIRzziEe/ezQDPwD46tKDRVEGLFi0YtOFIK9N1Y3/3SDHqg2K8VD9ecS/F5+OyvVe3+awq9UOfy+x3simL
HpHqjP4+Pirbz63lkSea+JWRfdr2uz5/tpfSjadMe2n0DKdIZ7w+/3ZU5sD7fOTSJro64rdLAq/5okI7NxvVsrUiP2vF8TYur4frwftZW5spP3q9+SXHs4lbGVnPat/aR+Whfr3dW0uofgXb06589MyrGLdxOz8v
I2BXjKrzjD1613nspooERGsfef16dCr/ON3J1nvbuJ2G7zvU8V39bR+83gbiWKpvYtzzzPFs447cf+5n2++Gsx5P8VGptuu+j1qL+9GZz6jw+fiyRzy6Lft+RTziEY94xCMe8YhHvO/PEx5NV7TxEZXRPh/Z7w7H
+jbSjIqna1HGPto1I/XWR+wm9PoNY+J2fjsajfexsOWjMu1n39SC6AqlndN2TWoHXnvdNDXhRoPyXj/XVWerDc/HM8uue1pJ134WeeB1UleuZ5r2nq23LT5vekfhVta3inTdO1bcrh6Pf1zf1jamqzd29Kt71PVc
b1bT1VE5etWPyOYV953nRtex63Lf2+PMo0FN90bTx7raVj9ROq/X1uYjr2+DVuzt3sqoVid7NVo9br+uFu2V3EzDdQyjercz9ydvB22XOk+233o/7krT9fYdq+lWe9fLuOMpht7UD7ih/XrLjpqrX82hVP/2oJ2z
x1k7u1/F0FtOjf3t35n4XqcRtX8yrrXApW399yviEY94xCMe8YhHPOIthxcc2niuao84XokyynPFeOT1qKDpQ+auH3osJXyug22jbdGOqzZuNh9xpCOv60rReB1qzyIt/YAdKdyuqdSHDrjcfnqkX8ebavX+SjE2
XqvtoMnqsR5mpN7GEaQLW3vVmYF3llGIN7XtRn7J1lr2y9xDH/Ubk3pkbBTp7UdsOda7N74cX9muu+W19rMjDTreusIzI31jup77+CbhyOuvnEc7T3j9u4LRNwK6q61+Bt95rmvhzuv1+1ph9dbvbTn2IQ08e3yl
x2cv9LxWM3PtevRais6zo+8Epm7rur8Qj3jEIx7xiEc84hFvvbwecRzmpTbrEcdhXurwJGPnjTSjuB5lPFGMTesMcaRR3PFQv15qGG439da1UJ+x2Gdr9hhQH6rLHmE7OzPmk27vHumzflbDj7w+Z7LHtnrN+vnP
1cp+N8z5/DLKOMSDRnNe+xm6QrbtvaKM/b2wfWhGdjJXdrx13dOjiF0x7ne26+w88qtr1q5yetnG7jqrR766VuyRzR7J7SpmvxteN2cnV19UbNDo588nHuZPmtG3BINmPFPQunuSrpziwOtXc3SlegTRjM49KMZ2
pMcSe/3UKCLbWwnzP7dfW9nLmvGTYmw/XlCMQz6osWYUox7he3xxPK/2ptrf0v2FeMQjHvGIRzziEY94a+fhHFRcz+bCXNX2ROO47Egx8q8UY6/f/VHG8xhVn/vYn+Nzg789miO7Jjt/xyhi1rc+C7CP23vcaZib
eZifOHrC70KUsauMr+elNt/MMD9RjLzT3a97okkXFOP59R0ipl27dE97nLBHrcKoxv369Fbvc0fjwDt7zrPPmezXZjzD9EQg9tnCJ56M6/dwlPFMk+qh/fSXz+gNinE087THcPsJum7rV58P85/HUcbu6dBO/ar1
enQ9fK7hemy1X1F9wjvveX3W9YjRz9m/meAXxPaS7wfEIx7xiEc84hGPeMQj3r3bMC91NFO1K8ZBH32pGXE/jgT2WFifc8pHuVVQbxzrx4cnHtvPPVdLf6Ksj9xH0aSuBntcaogpfSieEc8ejh14fSbmoBC6W/0J
ta7FwvFdXVBg9O6O9uvn6Vpt9ASkuhhNOuN9HWXsz9r1ZwtHzxAOOm/wt3s3zPJlh1cOMblBV7ZX+xopXXcP7TNSg4KP52P2KzXodnVkd3XORkeGZxn73h9bA+s1mn/aI3r93L0e8njk623QycP82D4nlY+uf39y
1vYj+Vi/IdLLD7U5xFyHvEZh8LdHRLu/Pb9NPzJSscPM2LMrJOrRN9xa/foc4PZ7b8Ue++3fotzh7mhbyv2AeMQjHvGIRzziEY94xDvyhrmqfWaqROuv3htlxH0ff5/WT43mPg5xvXHMpj9V2Of09XF7VyUj5XXK
G0r1fJwjJTXeur7pUb/+3CIflTnwhqyqo5rZK884Xt2GfKVdPdlRDpob2/hpurPtkF/0wpOLo7wuPd4mz8oM0bheZshX2tusS+KuJe2Zj10ddRXeY6dunHG0t6LtvOFM5vOZzp/Xk6OrqUc9gY+e07zen7vKdd3r
MnKvR53bj32G8Cdev/K9F/R2Gsc57cjTdmDoKb2VRj2l95r9Tp5FyrsmPI+znvTk3qJnz1Wu435APOIRj3jEIx7xiEc84p1ufV4qrsVxOonws2K8xhuydd6xcsJz9bu09TjSabxqCm+Y5Xmiiu/hdWXhx89MXt0G
XtMrYZSPs2s4N1rx43wtki94d289a4+7Oh904PUo49ms1se3Kdejq60u1+SF+btdn8VRTPHxbSufX+IRj3jEIx7xiEc84hHvXbyT7DfhapSxa51PKufV9etRLXOeveVJXl8p5PLc0md4U7dX8PjZ84bTeHNuxCMe
8YhHPOIRj3jEIx7x1sa7rhiXUT/iEY94xCMe8YhHPOIRj3jEI977eCeaMV6LMt7Pm2cjHvGIRzziEY94xCMe8YhHPOK9nzdSjOravNQt+Us84hGPeMQjHvGIRzziEY94xLt3w/U1Rprx6SjjcVu2v8QjHvGIRzzi
EY94xCMe8YhHvPt5J1HGT2ts8IoWDVqwaPtd/3cuIx7xiEe8p3gFzRq05+9/j23EIx7xiEc84hGPeD8ib6wY97vPmlE4tJLRsn/U9rvH30M84hGPeLetiP2uiCJ8QJt+J1zm/Zl4xCMe8YhHPOIRbwm8r6KMwqCV
ZlmeGoz/5JxGPOIRj3gP8CKa12jP3/+e3YhHPOIRj3jEIx7xfhzeZcV44H2lGRc+niQe8Yi3Zd5IMZ7e/6RBS22L+Rnb78a/JdZMPG/73ZR3E494xCMe8ZbMi7XZhb8f0414xPvevFTQhEQ7HV89G2Vc+HiSeMQj
3rZ57dZ2HmVUFq32zZ3bfnfp6EULaIWjpYqW+blB/S4cfd6IRzziEY94a+H10XXxaLXbvX9hHvt7RDzifT9e20RGe0Qx7ndzRBk3MD4lHvGItyTeRcWI34eptg2akU0wUQXcT0U/U+o2cdvvphKIRzziEY94i+EF
NHyuvojaU0Z+/A2Bvx9T/gKdGfGI9514XTFGtNPx1fQo4yLHk8QjHvG2zbsWZbxHMR6+X+tbbnZeSqCdKMb8lcF448vXHzXiEY94xCPewnlfaMaV6gXibZNXmvXNNrvOu6gZH1GMKxtPEo94xNsy74ZiHPTg+V2z
TTENGU1WNKPQLujGE8UI44ObmnER4xfiEY94xCPe9+LdpRgXoBeI9+PyoD/j+Ea3TTG02Lar35ffUIwYb5weZVzQeJJ4xCPetnmPRhnbFjWakmh9ecdqqoH7qbnw1/7BKOMixi/EIx7xiEe878UDvQi8GaKMq9Ef
xFsfr41lepDRSrQ+BkoarX+P/ok3Ocq4svEk8YhHvC3z7laMcP9rczCCQVMRrS04K3qSu6qaXbnLnivGRY9fiEc84hGPeN+P9+C81A3oD+Ktk6fRgNdyNFmNpjJalGj47TlYL3u3YhznU51jjY2NjE+JRzziLYk3
KMb97rEoo9NoyqMFjtbzol68Pz8dZdzQeIh4xCMe8Yh3zU4UI/z9mCHKuAr9Qbw18fp3GU0rtsGP6mOg/p378IzjuPygGPe7OaKMKxhPEo94xNs274nsN8f5Fk6iyYTW76BDdvRx+ZuKcYHjF+IRj3jEI9734z2d
/Wa1+oN4a+O178WdQpMFzUUHetDFq3kCb0cZJc+nihHX15geZdzI+JR4xCPeknhnivEwP+JGxtQ+pz+jDTnSLdr57FRcX2N6lHH14yHiEY94xCPeNbuiGBekF4hHvDa+Sd3aNvTVa99xnCnGw/jqJMqYn89+s7Dx
JPGIR7xt86assXGYP6RGdl7qAcW4mPEL8YhHPOIR7/vxZlhjY2X6g3jr5I3HOyc99QLvdpRRX1eM+90cUcZVj0+JRzziLYn3hWLc7w6asUzY+j01u+ygfi6ZZm4Og/HGLBziEY94xCPeW3kt52RhaH20/fkvCYyf
Z92IR7xX875SjPvdbc34iGJcxHiSeMQj3rZ51zRjezSx3r0N6zde33r+adfM37ZDPrK5jHiL4/W+0FdCXmL9iEe8r6333daPF1m/dfH6/WC8SvqE7ebfI+Iti/fgdV+Xv22iVb0SZbT3KMbVjCeJRzzibZl3RTG2
ZNGxcLQE979Up1lmY4P6sTmNeGviDT3CobUUAjIVtKXUj3jEu8Ub+nC3Nq3y0n1uO/5+X96tvybT/x4tjNfvf75Z61PDXN2l1O+VvLa1BhiSIiysfpN4/e+b0GjXFeN+N0eUcRHjSeIRj3hb5oFeBN4lzdheLgot
i0cMeA+VJ94PxuPN2vgIe9d+Bz2sjxWXUT/iEe+WtT7cZ1HmvvVevZT6EW9dvN57mkzsT3Me+9Mi6vdKXrv393mcz/wdWLK/h+cRuwa8qhnLI4px0eNJ4hGPeNvmXYsythcHxbglf4n3fl7/e/qhGaGH9fHRUupH
POLd4o01Y08cfXcfXqW/xHsl75piXEr9Xsk7V4zLqt8kXtd9XypGN1aMPZ/qfGtsrL39iEc84i2Kd6IYD/mfv9KMK/eXeO/nXVWMC6kf8Yh3y+5SjBvyl3iv5A2KEXg3NeMm/D3lfakZF1C/CXaqGMfjq5Fm9Lw+
Ny91ef4Sj3jE2zjvwSjj6v0l3vt5E6KMq/SXeFvjQW8F3gxRxpX4S7zX8u6OMm7E37HdqRjX6e8dUcYrihHns06PMq69/YhHPOItindFMe53MqH1/Dfrz6dAvOXwel6AbNGuZb/Zkr/E2x5v6LF3Z79Zu7/EeyVv
6DsBrX8Lsd/dygi2Zn9PfB/W5+xfu/TfllS/abz+jeh59htcX2N6lHGB40niEY942+Z9sS7jvasyLmH9I+KthncYH/StJ1fPoyMPbwv3l3jb4/X+OiwMALzJfXi8LdBf4r2Wl6fcEVfo73hrng4rcd7l9Zr8HdbY
uLgu46AYwy3FuKrxJPGIR7wt867NS/2IMcL9b4Yo4/K+/yPeu3j3RBm35C/xtsd7NMq4dn+J90reeZTxeEdcQv1eyetxxWOMcb+bI8q4FH+vRRmPinG/u60ZVzSeJB7xiLdt3tPPMq7UX+K9mzd6khHX13j2WcbV
+Eu87fGuZL9ZTP2Ity7eE88yrtrfsXVt1bZBaS2rfpN4dzzL+IBiXL6/xCMe8TbNe0AxbsJf4r2f92T2m9X6S7zt8WZYY2NV/hLvlby7FOOG/B3bVcW4kPpN4t2jGAXrivGYT3WeNTa20H7EIx7xFsX7UIz73RxR
xsX7S7z38y4qRuDNEGVcpL/E2x7vpmLcmL/EeyXvcP+bHGVcib+nvAlRxqX7e1SM+91tzfiIYlymv8QjHvE2zntqXuqK/SXe+3mT19hYmb/E2x5vhijjqvwl3it5D85LXb2/Y7tDMa7X30eijEfFiPpyepRxC+1H
POIRb1G8C4qxz4/oLz8fZVyov8R7P++GYnx7/YhHvFv2gGLchL/EeyXvRDHud3NEGRft79iGfDJTo4zL9PeSYuzjq6lRxmX6SzziEW/jvInZb1bnL/Hez5scZVyZv8TbGu9DMcL4foYo4+L9Jd5reU9nv1mpv2N7
aF7q2vx9Lsp4VIxr85d4xCPepnlfKsaPfJbb8Zd47+fdrRg34i/xtsd7al7qiv0l3it5VxTjYur3St5IMe53c0QZl+Tv14qxxxunRhmX5C/xiEe8jfNmW2NjJf4S7928QTECb4Yo4wr8Jd72eBcU434310zCBfpL
vNfyZlhjY1X+ju3J7Dfr8HdqlHFt/hKPeMTbNO9OxbgZf4n3ft4T81JX7S/xtsebmP1mdf4S75W8m4pxY/6O7aJiXFD9JvHuVYzH9TWmRBnf7y/xiEe8TfOaYsT1NaZHGVfhL/HezztTjEN8ZrYIzcL8Jd72eF8q
xgXUj3jr4s0QZVyVv+PfJ6+xsVx/D88jzhFlXIO/xCMe8TbOe3he6sr9Jd77eZOy36zQX+JtjzfbGhsr8Zd4r+Q9oBg34e/YbijGt9dvEu/xeakYb5weZdxK+xGPeMRbFO+TYjzOj+gvT81+szh/ifd+3heKcRH1
Ix7xbtmdinEz/hLvlbwPxQi8GaKMi/f3lDc5yrhcfz8rxuP4ap41NpbmL/GIR7yN865FGRNa4WjDffzM9rtrrzxnxPsxeKmiZYtWJFoqaEupH/GI97X1/gq82qxFh4ZevYj6EW9dvKHvBLT+PcQ9d8T1+nvie/v4
9K9d+s/Lqt80Xv9OVGi0R+el7ndzRBlXPj4lHvGItyTeFcWo1H6nYKttKzNscP+bdSPeanl9fNC32mx85HHeXRvxiDcjr/fYOrILffiN9SPemngX7ojA+7I/Pbotyt/x1nyvoLcqq+zWp+j+bRn+9vGTiGininG/
myPKuLjxJPGIR7xt8yZEGdf9/R/x3sPD79P3uzmijOvwl3jb4w399SPGiPMJp0cZl+sv8V7Ley7KuF5/T3y/O8q4Rn+nRBmPinFF40niEY94W+bdkf1mU/4S7/28B7PfrN5f4m2PNyH7zSr9Jd4reV9mv1lA/V7J
68qqbR96a0n1m8S7J/vNfjdHlHEZ/hKPeMTbNC8C78GMqav2l3jv550oxv3u0Yypq/OXeNvjXVWMC6kf8dbFm22NjZX4O7Yzzbiw+k2ww/OI862xsWx/iUc84m2c99AaGxvwl3jv5z29xsZK/SXe9nizrLGxIn+J
90renYpxM/6O7QvFuIj6TeI9tsbGIZ/qXGtsrL/9iEc84i2KN1KMx/zPU6KMC/eXeO/nXVGMi6kf8Yh3y+5QjJvyl3iv5B3ufzNEGVfh7ylvUpRx2f6OFePp+Gr6GhtL9Jd4xCPexnkPRRk34C/x3s97Osq4Un+J
tzUeju9niDKuxl/ivZb38LzUlfs7trsU41r9vSPKGC8pxv1ujijj+tuPeMQj3qJ4FxUjfh/WX54SZVykv8R7P++mYtyYv8TbHu+heakb8Jd4r+R9Uoz73RxRxgX7O7Yhv+j0KOMS/b2sGHF8dUszPqIYl+Mv8YhH
vI3znowyrtZf4r2fN0OUcVX+Em9rvJFiBN4MUcaF+0u81/ImZL9Zpb9je3Be6rr8fTbKeFSM6/KXeMQj3qZ5NxTjkM9yO/4S7/28BxTjJvwl3vZ4T2a/Wa2/xHsl76piXEj9Xsk7UYz73RxRxuX4e0sxYrxxepRx
Of4Sj3jE2zhvcpRxZf4S7928D8UIvBmijIv3l3jb411UjPvdXDMJF+cv8V7Lm2WNjRX5O7ans9+swd87oozpXsW4Bn+JRzzibZp3t2LciL/Eez/vqXmpK/aXeNvjTV5jY2X+Eu+VvDsU46b8HdsVxbiY+k3i3a8Y
x/lU51hjYxvtRzziEW9RvEEx7ndzRBlX4C/x3s+7oBhbfGbGCM2i/CXe9ng3FOPb60e8NfEO97/Z1thYuL+nvBnW2FiqvwfFiPlPn32WcU3+Eo94xNs474l5qav2l3jv503MfrM6f4m3Pd7kKOPK/CXeK3kPzUvd
gL9ju6kY1+zvM9lvur6cb42NNbcf8YhHvEXxzhTjYX6ETGiFow138qdsv5vybuJtj5cqWrZoRaKlgraU+hGPeLds6LG1WRvpD716IfUj3pp4Q98JaPtd/x5ifE98d/1ey2sfn+Frl/7zsuo35d39G1Gh0U7HV3Ot
sbGw8STxiEe8bfOuRBlV22rbytUN/r7NuhHvh+D18UHfarPxkcd5s23EI95dW++vFXj1w57sw+Ntsf4S77W8J++Iq/V3vDVPK0O75fX6/O0jKFCFYI/PSwXeDFHGVY9PiUc84i2Jd21eapJpv5sjyrjU7/+I9y7e
11HG99ePeMS7xbs/yrgNf4n3St44yniMMe53c0QZl+jvie8fMUbQRzNEGZfl73mU8agY97s5oowLG08Sj3jE2zZvpjU2VuMv8d7Na08yAu/pZxlX5i/xtsc7e5Jxv5tnnZiF+ku81/Imr7GxMn/H1rVV2waltaz6
TeI98yzjJcW4Fn+JRzzibZp3l2LckL/Eez/v4ew3K/eXeNvjTcp+s0J/ifdK3g3F+Pb6vZJ3QTEuqn6TePcpxv1ujijjEvwlHvGIt2ke6EXgzRBlXIm/xHs/75Ni3O/miDIu2F/ibY/3hWJcRP2Ity7e5Cjjyvwd
21NRxnX4e3ge8UvNGB6bl7pkf4lHPOJtnPfgvNTV+0u89/MmrLGxSn+Jtz3eTGtsrMZf4r2Sd7di3Ii/Y/tSMS6gfpN4d0QZTxRjz6c63xoba28/4hGPeIvinSjGQ/7naVHGRftLvPfzrirGhdSPeMS7ZXcpxg35
S7xX8gbFCLwZoowr8PeUNzHKuGR/TxXjeHz1fJRxyf4Sj3jE2zjv6ew3K/WXeO/nTYgyrtJf4m2NB70VeDNEGVfiL/Fey3tiXuqq/R3bnYpxnf4+GmU8Kkaczzo9yrj29iMe8Yi3KN4Vxbjf9ZenRRkX6C/x3s+7
QzFuyl/ibY/34LzU1ftLvFfyzhTj/sfJvzusXzFHlHF5/l5TjLi+xvQo4/L8JR7xiLdx3gxrbKzKX+K9m4fjoRmijKvxl3jb450oRuDNEGVctL/Eey1vUvabFfo7tofnpa7J3+ejjEfFuCZ/iUc84m2ad1MxtnyW
2/GXeO/nPTQvdQP+Em97vKez36zUX+K9kveFYlxE/V7J+6QYgTdDlHEp/t5WjPvdHFHGpfhLPOIRb+O8GaKMq/KXeO/mjRQjfh8xPcq4cH+Jtz3eFcW4mPoRb128mdbYWI2/Y5uQ/Wb5/s4RZVyTv8QjHvE2zXtA
MW7CX+K9n/dk9pvV+ku87fFmWGNjVf4S75W8uxTjhvwd21XFuJD6TeI9ohiP+VTnWWNjC+1HPOIRb1G8D8W4380RZVy8v8R7P++iYtzv5sv1sDB/ibc93k3FuDF/ifdK3uH+NznKuBJ/T3mzrLGxTH+PinG/myPK
uHR/iUc84m2cdy3KmNAKRxvu4yPb786PTTHi/Ui8VNGyRSsSLRW0pdSPeMS7xRt6bG3WRvpDr15I/Yi3Jt7QdwJa/x7i6zvi2v098b19fPrXLv3nZdVvGq9/Jyo02hXFGM8VI+rL6VHGTYxPiUc84i2Jd0Ex9vkR
qm21bWXSdsifPddGvJXz+vigb7XZ+Mj760c84t3aeo+tIzvpw2+vH/HWxDu5IwLvy/706LZAf8dbBh54WhnaHF4vyd8+fgJVCHY6vvpaMz6iGBc1niQe8Yi3bd5TUcYtfP9HvHfxpkcZ1+Uv8bbGO8YYgTdDlHHp
/hLvtbxHo4xr9/fE9zuijOv197ko41Exrm48+b14Kmv4/9JejY8MvNly/m+m/YhHvOd4X2a/+chnuR1/ifd+3t3ZbzbiL/G2x3sq+82K/SXeK3lXst8spn6v5HVlNcTzBqW1pPpN4n2d/abHG6dGGZfk78t5Av7X
KaUIFva75JJOPgWw1I6W9u1Lwq/w2rcuaXhfV5Hr85d4xFsab7Y1NlbiL/HezRsUI/AezJi6Un+Jtz3eBcW4382zTswi/SXea3kzrLGxKn/HNtKMjyjGdfh7R8bUOxXjOvx9Ia+rxRJzEFHbIlm0DgYPQTung9Om
aOa8SaraoKPSVmo8Upy1Nfoo9rtQmpKMbfwx+U69uvYjHvHm4N2pGDfjL/Hez3tijY1V+0u87fEmrrGxOn+J90reTcW4MX/HdlExLqh+k3j3Ksbj+hpToozv9/dlPAX9Aj4PJUambWAmCp1MTMHGYpMo+110RkoR
LahFFrUO0gauqnAmSPg4GaezViEG5StwWKq5Rx7PzlRg2NvWi8bWt8UcDT6dtahxvLKXbeXcUKo/yZXbZzhkkw284otuPNuskeDvhs7yy8gnkOH9nYQlzVDbNuf2o/3OS/lssy74xA8f6qTx3HA0wt+qgGeE0qaV
11D6cD1yI5UjCf4t2V3wDsvI4Wzn9UavoX4lFBzd4XvdqB4mO1ActZXSN8osqf8R72BNMeL6GtOjjKvwl3jv550pxiE+M1uEZmH+Em97vC8V4wLqR7x18WaIMq7K3/HvT0YZ1+Dv4XnEOaKMa/D3hbxBM1YB2pCB
LNKKhaID18HLxKx30jJrs9KsBCM1UyEryX2S2krrLMgkrivIPZHEfpdYzKjnQEeNzxTh8+dFMiYI5sAYPmoL/wumWXRBJx5AzaDKq/AJjdKbGhLzg9638A6vlTYqWQ1y0gcF45x+RSWrwFHwo2HJea25aiOgrhtP
r3Jp86+MEd7EbKwUUoB+gp+hBbDGLPmU2xP0oJK9i9UYyaQooLNiDTqCJoYzOuWg7p5ZDv7CTzIaJ1XxoBlLkoYZAXeaVH0BrQh+G+NT4kaDXGSg4wS8oVofeyscfXMqGrvfSSUt/M0zMZzUv6lFl5NIzW3o1xz+
QHI4e+WCK2zHAEgtvAIfaivDOYf6fS4lbVIV2to98xTqKvrzenkPz0tdub/Eez/viSjjqv0l3vZ4E6OMq/OXeK/kPaAYN+Hv2G4oxrfXbxLvjihjPlWMqD+mRxkX334t9x0oJsxPo/tYoGk4g8cuHEGt5OHToRJ3
seQgpPZZgjYKFoVYCqplpDUR2k84AwKTgZaEY1DKMxO8NtKaBJKzeO60jaBvQHgNtWmxvuhgH53Q3kZQTTZWjApivKy6KksRDHRV9SAfRQogV3PiwJe6Qj0Dq77aarjVxUfrYZDDfcVxDtQugGB0RUVeoMR+Vw0I
o+p8kKAHQaNm1EZYi8NIu8XgBjXoUDGWmksSII5jBHcVk67EwlMyyuPznNKEpitZzikILiJO303W1toy9mYD5+UheB+iBxEKWhcVYylw3wmsJZ0CZQqNK00SFfQguAWaMXGLWTDBOzgLeGfAu2Ic1DpKwRPUEhqx
1dp+tCJ4kAp4bZQwzmHDQ39RuaoKVxQ6vC/oWy49ymtbKeWgQVoZld1Q5izKuPj+/OPwPinG4/yI/vLU7DeL85d47+d9oRgXUT/iEe+W3akYN+Mv8V7J+1CMwJshyrh4f095k6OMy/X3s2I8jq+ua8ZHFOPS/L2L
19RiMGiJo7mE1tIF58TQxkdiRXPOBdfibwlkXa3JGAcqqkDRqhPIMmVaZMuBitTaVMaywuNRKg/Nm0CdMaeUExZOnYzEJL2Ffapfa+12T09tpqTus1NrqKpUrrT33kmZQA0m9AG6rhMR52gG1aJ+eb8z3kcQW0p6
aZtmZKBbvai9FJJBn0VfEtRRaulBtYbEjmfPB8WoUDECL0slQZVVlkCfcmuF1iIwk10MoLVcYMlb0K1SBaQwLlv/CZILLVBIariZKAGqzyoN+tfjZwzkKPOSw8hLBDFoRucx+FjwLQHuPCm3MgzqLQ660kIrJ2eA
KFVTjHGI/9pP1xe0IyhHm5NWVodguDQ8FJ9B6GZUlnEoU1sZY00IGlqDg/5tpfJQah39+UfjTch+s0p/ifd+3qQo4wr9Jd7WeEM+yzmijKvwl3iv5T01L3XF/o7tbsW4Rn8fjzIeFWN/nm5d/t5h7WnA5Jv1lWR6
XxfAEy3HDdpwbHQE+4XLIjqvc3agbWqJ1WAwzDHmrQPF6LkHxVgjTqYMar+zbValhWOcGcuciVqwYA2IFA5arZbTvtZ0TExwFg/vAGmEi93AWy2LLCnQg4JzW0LWIXkFfTbKAJoxNFUlu2Zss0lLU4y6aTguFbMi
FZNqczeUoEHExmxA/0ojGdTDNs2oLmlGq2WU2mqoQDaewz/GBxak51DAmhJEgq4CilEH1G+g1EDgofSDFvYCxlayaOtCStJpmVQJ6LeT4JMoUKfsMV7pi2/aM5osqkigIoEjof+BZsSnFjFe2nWl9zWpphlF14z5
XDF2a09eQhcHbSkN1FlYB/5WwXAWbBJDmUMp8FnC1QnKgg7n9aTM0vvzj8a7qhjh+ubpUcbF+Uu89/PuUowb8pd42+M9PC915f4S75W8C4px/6Pk3x0UI+ijGaKMS/P3umLc7+aIMi7N37t4bbZpZGg9pjjMRb3F
sBh3it67lEyL1xYWi3HeJ22EziEKXmsIgtXqM7M1gQxiLNoKLZoMtL/mIL2EE1Ya32alHuY+6l6/lOGTl5iV2jGfVYBrUKvOsV0J3/LYOFyLt3BXUixaAp6XQVM1xagDqMFoWj4eEQLO06wMz2+sNhbEo7Ia5Krl
IOGSwDme0BZhmJd6sK4YnQ+x6iijUlAQ/FUVBGcwAjRtqFopWRVUyznHjAftWaosIikVnApBSxCLoI3RpJTQvZIK3Mj2JGPEZyr3O56gTgpKSTAlpEzwkrVKKW9xZCYi1BswoHXDoBi5DwlaWkhh29OVmDtnUIwn
1xdnqHq4Wr7PPW7RxMqzElonfA5VtFfTuAzc61wurYzFMqD3ecvlM0Os8cX9+UfjzbLGxor8Jd67eWL4PnFylHEl/hJve7xPihF4M0QZF+wv8V7Lm5j9ZnX+ju2Jeanr8XdKlPGoGNfj7x3W56W2LbblFc8V40We
gDKgrZKJohRrmTUiaOGSKywEUCHaCQe9x3ictaph7z0D/eNsmw9c4R+mnLZMRYzSoU476pF29lQwpw3jUjmRhAXtWVLlNULHjMV7DlKwhohTW/e7hE9bumC8CbzVSoNXqIRF4iljJtegPAjXXCUGBUUwwaK6c9LZ
6Lz1vOUv7WNr/cnfrhnBkSSwP3D4EdPo4N0BlCrH15V0MmFOHXDLoFgMQHOgvh0+K7jfOeFDKNAi0omovHLwVwoFWcJv60FSeheszwFkKZZwEsb/zPmC8UWd8L4DpwDfRPMN8xN2na+SSjWKgFFVC2X7qpcHhdC0
IrQAHMfEOZ5VAULRg7IMxXMvtEwJM9uY/Q7aEtSrBz0/lHIxwL0vcAelMqhpbuX9inFTn4+l8+5QjJvyl3jv5z04L3X1/hJve7wJ2W9W6S/xXsn7UjEuoH6v5J0pxoXVbxLvHsW4380RZVyGv3cYjic/z0y9532H
eYo21xiiMZW7WJXE/J3ZOlZyFahMai4B+MX5qEIULEsL7SyN0yy46rQ20YFmdEM+nfEZWvaWlu9GZJCeqjjJEjNMsoABUV65YRFUI4i+nounqU43vLcz2txW+GsQs/MspaJlWz9FqII5chQcx0imbQ9ptta44Glb
N8OUoJPG/DpcRI9vbjlhgNuvR8T1KSQoRqWKTZoJjANqUISqzXCNrWZtdH9ytl5Pn8NQd4frJbRS7bHR3OfH9lLn3vX4oW3vO699z36D9WPZcq+M5SAbDRNcQvvZYK1VGFus2SQHd7cAZawV0LpYRrQyxhqFtSvD
jFS1+P78o/GG/jLfGhsL95d47+edKEa4P88QZVy0v8TbHu+qYlxI/Yi3Lt5sa2ysxN+xTcp+s2x/D88jTo0yrsXfu3gPzUs944mmaRKoTRnawDWapLVKosQA4qnq7KwpPAgQHpL7qp1iDHQe06BzElyP4IPzycWm
fMKFc7bVGqHtMQfOaFVGGKfoYlqkM9301yIj5FRztlZ7g3pORJOvrWV4ideUI5zTFdNUX/10BtlqaQvcNwq/tk7iG65vV96qrU7Z17bsay36jBNPez0/ygDveqnX1I9403gPzUvdgL/Eez/v6ew3K/WXeNvjzbLG
xor8Jd4reXcqxs34O7YvFOMi6jeJ99i81EM+1bnW2Fhk+zXF2Oel7nc9DHbns4xHwzmqIfsUcK3CmB2LNhadQQ/yZC3LJnkbQZcWY1LxXlWvcFZorN5o34JbhzjhK/1turFF1fpaFGaR14N4xHvERorxmP+5acaE
VjjacCd/0Fp8ekYj3jZ4qaL1JxqKROuzU5ZSP+IR75YN86lq7lkP8BmT3qsXUj/irYnX+w7w2qIC/XuIoYcton6v5bWPz/C1S/95WfWbYv0bUaHRTsdX09fYWOR48h7eecbUZ3liiKuJpjdFlkN+VTXsoW/lBIqy
5hCysfgMn9YptT4m2/zYR3TqUtqPeMR7J+9KlFG1rbatXNh6frP5NuL9QLw+PuhbbTY+8jhvho14xHtgy8DDHltH9nAfHm8L95d4r+U9fEdcub/jrXmKaSUru+71Wv3tIygR0R5RjPvdHFHGRY5PL85LBd409Vbb
ihlNjaJebHoQdaNuejJmfH6wtD3O73xYKy6o/YhHvHfyLipG/D5sepRx2d//Ee9dvGtRxqXUj3jEu1Xinijjlvwl3it5Q9/5iDHiep/To4zL9ffEd/jw7HdzRBmX6O84yng6vpoeZVzkePIe3mhm6nPzUj94/RPT
vmNpTSyGud39eYF2ngX4SzzibYk3eY2NlflLvPfznn6WcaX+Em9rvNGTjPvd888yrsZf4r2WNyH7zSr9HVvXVm0blNay6jeJN32NjXX5e4fdmJd6D69/RnzbpJRCCviwJJ6ahMzKox2+mQaebc8t+k/5Ua9ZaFlP
zzfdMpCe1s+flXUtG2k/n2m+4hZPyphOuuGva++3H/W+NA63Z2V6PlrZzumH86W2V23NCtNe9S1DKr7jNNMrZtk5kHx7FjMD79y78EWdzHD+z173Wuh2PQ5XIjQvj69+lGpt9Jr+R7xpvBuKcchnuR1/ifd+3gOK
cRP+Em97vCez36zWX+K9kndVMS6kfq/knSjGIZ63pPpN4t1SjG39hclRxuX4exfvoYypn9qza8U2XpVOgh6UFmRMACvBBCOrjDJ6g8YkWo9bd8HYGv36eXJbv0J7EW0qJoFVMLwIFnA5xRCcaPMAUOWAxvIlhsxM
BEsGTx8jD96nUEDKpjSst2iNDQ5TgjLLWsVyaqsh4sr1F2vTtGKwMcEZPcrftgJihOPIM8OaGagWdXBQKkEp6VHjmdSz+kTjnQscmxmXg7TCxMxj9C2iC+1nnPQ4AhP7XayNZIOPJeXgvPCy8AzVDzyWrNGrD+8Y
nCnA/9on9D+drhNiml6VUYHs41Zb7pLlVloFLQgtCbXwwEhwDp5xVUvrSlDRQatEKOdsst5i+5QkovC4WqcZ9O+y+/OPxpscZVyZv8R7N+9DMQJvhijj4v0l3vZ4FxUj8GZZJ2aB/hLvtbxZ1thYkb9jezDKuC5/
p0cZ1+XvHXY+L/V8Bqka4mWjY/0ZKVfR+rOhVVWQiLhufEqOOeGEck3peSONBM2irHLaKacU7kAP9gvRVhV0n+qkcKVD+LeIyJMuUFxofLd2ziUXXBCgR5WL1VvLkiu1gL+cC2kSLoKhrGeuuMJAyepqYQ/isf1V
4A6uKIdXpWHWgb5lwgonOehGkIVNO9VP7Ydz1A28oGI2QgQRYITkMCyIM9Ujd6DZcMWPDP94Havh4HqousgkpbGoFZMGEbnfYY08Mw5UK9ZSajgprhEiCvYyKF99atPBs+E+JG6k0MLBX7aQNIczWwPvikpCmwNp
v2NBVqMMNCHXUEsb+zqOdqi3w0hlgAsAXbr1Y8dBnBZoveKlM7Y6kXjkvraILa53wkONRXuQuRw/A1xC6yYdkwF5nlpc9AHFuJHPx9J5dyvGjfhLvPfznpqXumJ/ibc93uQ1NlbmL/FeybtDMW7K37FdUYyLqd8k
3v2KcZxPdY41NhbbfsO81P2uzUxts0eTazZ6jjXZZv1Ie4evaD29TfDBBttii6iAcN4ptB+SeuwSlCICvXfe8SxgSyzWWDnDJEupycqeS+GkZmKoG3CK3e9Ak9W+YmDVlZWkqkuxWCW1CB5XzWDSM/i5JAxzFo8l
QcOpxEAxBgk1BiKTBXQWvBvaDzRysUg00svEHFdcFnzyMnX9eog4NsVolAd9aoAjFehTm0AYausxqY9irOB66jxKY3xOxlSppQrgairKMy9lCinBKzwJ8JUnlji0qUvSe/isSYkCGzRv5oENihH0tC9JgowUUgBJ
piwVeFfBOxcUrg0J9dZQxoBirJI3xZjyWDF2S6gcPVxfeFXLiAtGphyLM3Bfw7GeblHS/ulgMAbUUAcHp3bQTqpEaEu8Ci4/MV/5Lf35R+MNihH6ywxRxhX4S7z38y4oxhafmTFCsyh/ibc93g3F+Pb6EW9NvMP9
b2KUcTX+nvKejjIu39+DYsT8p1c1Y3p8XupS/b2LN56XqtF6xKIFDkVLuig/HwE9KLus7NoP1Ajef1XLnVcxytifioSy0Jw4VTOFYAIP3EWMZiqhkkpwpITCNFOgz9WF9u2aDXRirqA6Cwi3ipW13jqrmeRa+hic
AeXmsy1KRlBeESSR2O+CbHnQMqhB03Sll3qkGTnoTxPcUAbenpTRkkkYYmc9KK9DXUAx4vzTrhmtkAbUYIByCqQfVqIYpmKUnhtrYuDJWTYoRvgsQaMyoZVSTPTUglVICXpaatCxShQoZVKFmgcJvRP0mhk0ow8M
FGOSXMoA4zOokgXtKVBXgh+9TIAy2mhRgCcuRBnHPZ+BLtRQb1E5j9ByAq6zMbZpwa6QFZbITcWCPpdSMyd5O19u1yKspD//aLwn5qWu2l/ivZ83MfvN6vwl3vZ4k6OMK/OXeK/kPTQvdQP+ju2mYlyzv8/MS+36
cr41NhbWfmfzUoHXf+jzU/tzjX3u6PhIL9NUHY84W9MrH0HCeRCDqLeg5zQ1Wfe7qE8MdGdgGJL0DoOBvZWLRRvqpIaapey0dj5yYXGWJGjUatJ+12a96pC8cQX1ZAYxlXJx0jElLGrGIAY1yHA2adN5IiCTcw6k
mkH1mVhTDTXud1zpCjK0aC7QpzRkADqNMuqmGLUCCSeTdQGUnHYCNHBioGiN0gLkXpARroeJUkmHT1mmwLwohhc4ZHxf4UUVDzraey2lBcUIo3poKqwTTjxV1eJjhuA0S8mCjuSgV0PTey3KWMA75sugGa0voHUl
NGj9WjH2eG3heFX3O4/fDlSJ04U5XKXsQ8tvE9oTocqDPC22KUZxj2JcWH/+0XhnivEwP6K//GyUcbH+Eu/9vC8V4wLqRzzi3bK7FeNG/CXeK3kjxbjfzRFlXLi/p7wZooxL9fdcMR7GVyPNWKZkv1mWv3fxbmRM
/dIwH4ppT7jBGKLnR5UOtYhO+LhiTH1A2/Y6YiqclpwmspACPkYXeBgU6JBxZ6hfU2vJwFgE1VSxLGcPcqqEyqosrqlLeA0+lzjnE5PblCKU5UGCBM08mJYfFE4E+ijEYkFYKdCpUEsuEj7GCPLLqMw408waC1cc
3lcO8cXT5yq7YgQpnBjG8wTHZyi5YBX1V5vFqYoWRgdvMQmQRHkYJWpZUJMxgbTzLRrp4FyGQUXgRgLyFIp5X3D+bjES2kEpWbXVAspAOV645ayACPQMNJwo8Dp4l0GF1oBrl4QcLShjcKzIBKITBCTWfr8bxUeb
pQr3LZFBvaYIdzLeFHGCT4GFNsCEPtbgXGJUyhbDxnDVoOWl6RFbnG/ha54YZfyu/flH403KfrNCf4n3ft5sa2ysxF/ibY03KEZcP296lHEF/hLvtbwns9+s1t+xPaAY1+fvHVHGLxQj3F9miDIurP16lLGifc6X
ejevP9LYIpF9QqqRuurqDGZpUdVoEFQc429Rglb0wUuLujK2LQ9S88wwkmlNdCVivhwjCubPAYGnrbRCCpX3Ow1CyCot2h3fFlx3U+Sx6suYt7TNmGVega60GKQTqcI7AugmqF7OteWukS2/z7U5nZj9JifZe4TH
jDMCVVZbB9hl7WTieYiXmiQ9xxqZlv8U9RhqXIGZXdu3Dh/na9lU4SeonS4c9RxY/25CDblkbVubA8uwtl4CP/GuPacIypkPx097Z1unI7KkUgUdHw231mq4LtwYEPlF4vxsl0XC8CiurwFVc3B14EIxhQIbxbp6
ZF7qIvrzj8b7QjHud3NEGRfmL/Hez7tTMW7GX+Jtj/fEvNRV+0u8V/IuKsb9j5F/90Mxwvh0hijjsvz9SjGC/pghyrgsf+/idc0Y0YaMqXevsfFF/VBL4VONMcWg8SlGgelUK7QtCJxo0fon7BYP1BbP0cmgY3XC
VhBgHLOxeu6CA5WUQsRVBfXF+ZjdQo9fupxiUSKBFEptfmfXQrdWh+zKi6Py8tYZD29OOuohnnfIIcowGgkKOUMrmmB9bCtx9IjtXSP2F1zffl7MIgTaPYgoHIf2q8456ThcGh9Mm496aAGMm9qU4K+oDcLrgPOR
ZRLtNb2a/vyj8WZaY2M1/hLv3bymGIE3Q5RxFf4Sb3u8M8W43801k3CR/hLvtbzJa2yszN+xPTUvdS3+TosyHhXjWvy9w+6al/pk/Xr0sQtRNmTEwTP4YbxxPym2JynTyEKjyvYU3r31w9pw6NG8/fRY+zXliAtr
wP/qTKGqoZaxRxUH39QXvEn20PXFPerCg0Zvz2s2D9xFXv+2AMRvPs0c+5r6EW8a7y7FuCF/ifd+3sPzUlfuL/G2x5uU/WaF/hLvlbwbivHt9Xsl74JiXFT9JvHuU4z73RxRxiX4e4eZ/jxin5na89U8F2W8WT81
svf529eXpPXoibcNHuhF4M0QZVyJv8R7P++TYtzv5ogyLthf4m2P94ViXET9iLcu3uQo48r8HdvE7DdL9vfwPOL0KOM6/L2LN86YitNI09eK8YPXxg3DOo4PGmahabG+Nr/pOcY1I957eJRv7k28a1HGtjxOezqW
D/fxZvvd+LfpRrwfjzd84ttKun3poGH2yELqRzzi3eINPbY9P9NH+kOvXkj9iLcm3tB3WlaO/j3EtTviNvw98b19fPrXLuO13JdSv2m8/p270Gj3KMaeT3W+NTbeMj61LSsKzqfEjC3jfcyizVOU2WeX+vqDYfiu
5PB6/Pi5zwFVw3fMbbxQRTN2zfa7s2McDcaxtkQwW/CIqPo64wZvkhFvFl7rBblvP876tcvgnSjGQ/5n3FTb+rou5ckNn2efcyPeJnh9fNC32mw4spD6EY94t7beY+vIxr36/fUj3pp4p/e/q/3p0W2x/p7ymqd9
RDjN6+X528dPbUH6eDq+mmONjZeMJ0e5SK/atahg04rgqs3CBd/mY7rqXTawt1nD3rS9anvZjou2Z3jEVdhjSlHrmUMZqaNNvOV8UYf5rC2ljXxAZRjASpOCy9FY4TivoeaCqpOD/lAr0EfE+2x3KsYF6q0t8B6M
Mm7n+z/ivYs3Jcq4Rn+JtzUe9tb9bo4o4zr8Jd5refdHGbfh74nvX0YZ31+/abxHo4xHxYjzWadHGR8YT/asNHAjS7jsIG7pzNoWIyY7Bd65csS1CYX1DvQhs8IXyZWoxXAuQvGwN7jnte1T27u2F8Xvd5xDtw8g
CWzJPLKYcmTOBtvWfTDdhigjb8oBt1TPNwOqsDb9gRFGhaWLrBG0O5fewjtAyTo4qmsZNEiEn+UFEm+sg57R7cwtiDK87tpPvMUtK1Dsybtz/8JgeDVXD7QI7xAD7+zYyZFLSulQxp2UaXHUD38vl+LQUg48ON8k
HPXwqoWfemtiadD7H62MJNtI8qMF4gWSbUf72S7pQdmOdx/HG54/D+8p8POlWh6uh4LXWx+A/jdDlPGBzwfxul1RjLi+Btpca2wsxl/ivZ93R/abTflLvO3xHsx+s3p/ifdK3tmTjPsfJ//uoLd6VG5QWkuq3yTe
tew3uL7Gh2bM09fYmMHfFj/0Bg3XU8dvcodvxEYGNYJq+4h2TTE6hnFCrqUtTggZixC4XpvLTEQJ5WHPcC8y7JMIWYkgwE/hhYXu74RMFRcMTC4ql0M5UYyqqZYE+qPUxBgowAJCA1f0S9BxamtJnYyPBpWQaToI
dRTqwcSNDsF6ISszqOcKKh9TjQN9nmxf5VBYIBUWhOCJgz5J0aOactVlVUCDcSaryf06BaaD6CpRyeJ0TMyDBQbtB/sKDckZKwXPorIxvkbvlPZdcMIR7XN0J0cMHDFOaN/qfoiBih5/K3jUqWIslNKOaaxXgNNg
pB60aZudEOB9Acp4OJuCMq6hveNRgo7ncEsRzLf6RVlAprGSUgjS+uiKslp62bRh1kByNalqYuBR2aItHAFtKZKOcDHBS1w7BBo3aLvfKahX5HC+3lryRDk2rVgS1NXJYuENTGP7iAgv4tcEyeK54IIYlPRqiMdH
briDBoRSnIv+9UpMEQoqOEd6RDEu5X6wCd4Ma2ysyl/ivZuH46EHM6au2l/ibY93ohiB92DG1NX5S7zX8iZlv1mhv2Pr0bgHFOOa/L0jY2q6pRi/k7/t77FXaKVFpkrGCBSM9EVVfd+eATSDYrQH2+/aCvFoFcbw
IB68yJFzqUtUTDGQFdVaEWEfZGl70Gs29r2Ca2+NCCXEiPolJtQLXikXbAjORXmiGR3WIoIarTFYw6wa4mI9+KcwTiaYjAbUZ5AG43ygV2vwGQQl6FMReILWBZ2OGtCblrQVBFUMOaJkiUOs0Qb41ZggkkR2zM6a
CCrFeInxlCbxQHC1OKLxLiUFKrUFE49bZEHnAjoLVDGcSjTFKLTutW1HQAA5GA/BMT4ck3AM1aBuyssMyqtFDpsa9CoYBWWMrVr1yKiKJnuRuGcmIQfjl1DK+BIjnM9EnUFVaqm0Mljt3OOEOCMG1CVcM5mkxVUr
ixVSSdvEK1w70IcF2G6/A3mZsE4OpGLRoJOVbFHGnHoNmJHaqgiiUuEV8sOTogfF6MGUAV2apRUK+gsPvQaepwTCNuBERrhyPIEkzKFyQHnjMlwsx65FGY+Kcf9jrF+7FN5NxdjyWW7HX+K9n/fQGhsb8Jd42+M9
vcbGSv0l3it5XyjGRdTvlbxPirHN71xS/SbxbivG/W6OKOMM/nbFCEN1bzFHTE4gULSB8XiUtpgQuXUYKosBlBAPKuj26JIEXWcxcoeWaipJqaJT0FzLUEEvypxAp5igYOxvkpaoZ/Df0V4XVGKgxyK0Qq64d1Gp
kC4oxj4vVQ8zHGvXR8etGAwdcmhB4xJIOe37XFGtrYsChSRoWA8n8z7rKDEsF0EbSYxaKW9jgPrBCZKIoCyVsCl4YXoc0ZocXDagirjE+Zvwa0FVV5QFdYbvqEJI1FwS9lwyDaeROL+4Fh2zSiBAVQxOaTfowwja
L7e44+FIaHFH0+KHVxTjfockKFXwfRFkYcUAHPQm56VnrGk4BmV8kEk4AFqQ90WCKmM8SgN1kpKBceXhN3zeNIJGtaCRfRFWSytRz6HKxKggDM5A6wk4m4RCOaZWBoRtawHbIqigRi0LNjIbtIbrgZpRfcyYxZqD
OKxOJUD7ECzT6G2AZsbvJKp0gukAYhE8wNgxaFoJ5y5KgkYFfwM0sMJ3QOfqc2anZL9Z3P1vfbwZooyr8pd47+aNFCN+HzE9yrhwf4m3Pd4VxbiY+hFvXbyZ1thYjb9jezjKuCZ/74gyPqAYX+pv14yo/Q5P9fVZ
nbaN0fvPbQuoGfmQJ6c/j9qfvM1tPAlCy4UsuZUan0lUNmZWA/pag+cKpI8HQdX3KSR8ttELYbxSPGgokAJzQQmfg93vnI7sRDPKphdQCSpfkm+zSYvEGY6FOfjfsOAiqMHQNA1UAJQW/KaEBtmz3yXpWvqbqmSV
VoHyKSIGA9IwR2tlhJdTVU0LgfqCG3ssGEmM1VgF7wtOKNX0Sy0S8yMNsUELLRIsRvESPouYUPkkrbg3Bt5vooMyJugYQQ2y/sSg0kaBFrM2q9CfDFRhv4NjDDQjP4kyspMoY1OMyTpQ5lp6kaWHniSFwBmfooDS
hqasVoSaGLaf9g4UX5FGgY7VoLtySqAzoX7GmQq6Mvpok42tDHAkhkp9xnNjnVB7qphBMWoL/kIpYYXUH7oSn0vM7asE0TSjuqAYc6t3GcpEKJPhIkj8e4lngbo740sAhYvquLehxiy3cLULdEdveUxeaAOv+fZE
qajykmJc/v1gA7wHFOMm/CXe+3kPRRk34C/xtsd7Osq4Un+J90reXYpxQ/6O7apiXEj9JvEeUYzHfKrzrLHxoL/t7zFmLXX18naM5+FEw8AuPsuYPp5ltFLBTTGBYvQsxhYJC5lx2CfYmwD6Ep+GC5UxLj1oy1As
CJcQHGgm0F8pKvgX9Bycw7bVNlAxtlU2cpvXiC0Fp4BKG34ebzxsqnqXQMso1EugIgsHvYSPwymdvY0gMyUIpBRK0kwxzV1xIB2h+aF+1gPb92QsIKgsKKyoBEiZ4JQTVmcRshfRwac2A8+CXErOo0ozoH5AZUWB
mYDhj4NUGK8Fbeek5N5mh9MuJWhWbTXovWAtEEEGCZSpHjVje17PnStGkKXO42OnBvRlFRYKKtS9vkSMzYHclU5i98nYjk5ozCsDMllxy522oL6MsBHQQQMKNK7M0NimRtvWD8XrZB0oWyOhTsIlJaCWAS8atAuP
OPXUCydSm70q2+zVrATOsQUMBw2OilEO+W4+RxlVCMGbqttc3ypS6lFGXkGOpswcXhl8klK151AxuxBOWuX4JKjs81kldCKcj6uqmZr9Zgv3lzfwPhQj9OcZooyL95d47+ddVIw0H514K+LdVIwb85d4r+Qd7n+T
o4wr8feUNyHKuHR/j4pxv5sjyvhSf5smiyLyyEP8sBBSs+PPMZigg/4i+03G5xtBM8rieQRVZ8DJCKJDpYLaMeXIlUmgEz0+Ayh9SdbXkgrogcCTCRz0Iqaj0RlGoH28cKhfbXNTcxw0Y1CgXUCWHjKVNi3pc5Ag
QEWKGGxMCsYZOrPoWgRLNQNeEhnkYYJCobSVOEDNJAb1L6DHig9e4qTTVGNo1CiT1aGAVGQ8QZ05yCbww/esqGq/iyrrChoLNXeQmEwI/iygKsI4rU8iQe1DiQa0V/Xc8wSCErQqzm8NULqC9gTh6mOFBitmyH8q
TzRjatE6Z3mQ2E/gMhk4JWsxyv50YGRJg3bjEV+P3jmNz3rm6qD9bLFVuwTazgMkO0yOy6OAd+eqU8ylxOjh6mMU2YfQ0iEVKKGCRBVXEsZ0S042yqh6/tjiCmZcVTEm1PXgQMwYAfyUMTW0Zxkz9hm4AJqbfrFA
aqOSjPCH1Dce9CFg47cDHs4y5E11PskqoBtYBlq0xBZpvqkYl3k/2ATvqXmpK/aXeO/nPRllXK2/xNseb4Yo46r8Jd4reQ/OS129v2O7QzGu19/n5qWivpweZXzK38NKG2ht5Zf+xOLwc18D5ZC/7vzdI80IilEU
w4PmBfQNjPExN6dse16rgVEAeIcRxFB40zO8TY+0gofWVgH+tyB9rIRTavh/PC/Vol4BBZMKZk2VIAgrg6JMM1zgMWB+Vg66BTQMb2FT33L3mBMdoxsL41l2UDiuKcrQzLd9fxfmz7FVgY4VOTgYKKuWVaeInrlz
4PX5u/3dru15W7+iv2ra+XCtClMD5uPBTKetZj0LbD9nP/Lx9OKH8UExalBYzpaQZEsgirM0o2rra8iWxwfO4XGdHsfgdeFiHWZzYnv1JwDxLG7wTrZX2MfzgXyYC+vb84hu8MUM0U4+5D/irU3MsV4f3vXWvLA2
yLDeImYL8gqfmhSYMZXDlePQN7KJ1mE7ZpDn0OsK5kctyrbcsxiVVfAhUfi8JfoPhrynn2Wc+Pkg3gXF2OdH9JfnWGNjUf4S7/28G4rx7fUjHvFu2QOKcRP+Eu+VvBPFuN/NEWVctL9jG9YznG+NjSX5e0kx9vHV
fGtsvNDf/nSjQxuyo/bnF6+9d7zGBsYYQfJp0DOFM4yToVoUNcOe1WjwOueCM05BQiQFMkIFC2/GmaogJIKUKtYUYs3YBqPsN00vHFSa/pSkdLzxpolurgt/9/rxfeXCvh7hOAL4LO9OG/EO6ySmj8nDvOnQ04je
cYVJ87FO4vep39c2Xi9yvKEOHOnuNp/1fBuXeij7zZLuB5vgTcx+szp/ifd+3uQo48r8Jd7WeB+KEcZDM0QZF+8v8V7Lezr7zUr9HdtD81LX5u/U7Ddv9bev1CjRBsV4i9c0o9UOfsYVAHNlStYcMKFnVRhPwuye
GbSDlinAX/8MTAxFZiMZ8xX1NPdB8RJxVcbast7EYbwwzpg6v54h3np4I8W4/3HWr10K70vF+JHPcjv+Eu/9vLsV40b8Jd72eE/NS12xv8R7Je+KYlxM/V7JGynGHm+cb42N9/v7tWLs8cb51tiY2V8NPJ11Emg3
4ovd+uv97ztLNWM/ZvhzO8r7fNZ2HF/BPapQnWKqKVoZuTXRgFa0bS5qHKhiKAk2PInIuw35VWYz4q2EJ9Een5f6/vvBJnizrbGxEn+J927eoBiBN0OUcQX+Em97vAuKcfi+cxn1I966eDOssbEqf8f2ZPabdfg7
3xobb/C3Rxkt2rUo40VeHzFibhwB/6u2l5/2qu3lUBL/zxkzmuDcV/uJ10cMLdtOsc3047bfPfMu4i2Q1z8ZLeYw9I33fD5+TN6dinEz/hLv/bwn5qWu2l/ibY83MfvN6vwl3it5NxXjxvwd20XFuKD6TeLdqxiP
62tMiTLO7O9oXirwbmrGF9dviF0Oxoc4pWp72eLTvL1+aS+HPR/im7xFP7+wj3j3TEa8F/A+1OKbPh8/Jq8pRlxf40wztjRZhaMtsr8Qb6W8nnut/wUqEm2/G1YCXkT9iEe8Wzb019qsjfSHXr2Q+hFvXbyh9wS0
/j3ElDvi8v0d/9azcPavXYaMnIuq3xTr34jud0KjTYsyvmE8qR+cl/o96ocaAWvC4fOhY4k28RiiSgz2sv18uj8eV7GClSHf6/XzhbYKZG5rTI43DQo6npT0LSaKz9MdN9TZeBy/ETetptilww3SJX9ti9B2kszy
Yuufl+lXKcMZ/XC2BDz0REF93LAqiofz++EaXyP1+udz3/r8sKt1OraNOWnFOPiOtegtk1s9T9svDaXscIap/WXu/ke8K1FG1bY6rGE63va7MutGvB+O18cHfavNxkce503aiEe8J3i9x9aRPdCHv0P9iLcm3gN3
xE34O96apz2vxSWv316/Sbw+ghIR7T7FiPHG6VHGWcaTF+elvnm8y0BtgFgMyZQKGtClqhJ3tYKy9Rz3+13/92Ov2t5HaNAE6tHj9zDy03qS3VATaW9jSNVKMGO11fud1aZYZmVKITvUTLXgmh+gsYKIKXMrwKTl
YCLKkALD1RoDSwrPYrNjXgLJWAsUuL5WpRCKaws3Xnzqq6m3EGKGM6YhW61KsR03sA9Nj4GaDzFC//soBRovpaa1omUuB2UV1IzbYp0VmccceKxZF+6Dcx5ndorEmrIzIcUKwjZ60IPeFZ4dUDW8atCrsXe+wP8h
4Ps0NAjW99QHnEFsvAgGYNbC9YB9cdJWB95bnWw0UA+HUV+brPMcahfAVGsjB2UE1DR43bw9a5+V66318z4pxuP8iClRxjV8/0e8d/HOo4zHb9SXUD/iEe+WfR1lfH/9iLcm3jHGCLwZooxL9/eUNz3KuFx/e5Tx
GGM8jq+mRBm/23iya0aF9ty81Dvrdx7BvHKkXQ+TcwFJYUD8VVXhY4LrNMKeV3Nxr2upIoHSSQ60XGjZd/Sn+jVtElFvZRHgbRycTariY5OOO+2kkyIopkBF+QC6x5dSJJfCmOpA6CjhnAO5A9fXSa+L1SCyom9P
K+C1FRykd9LRcmecE0kEAfo1ZFtbxLGceIp3AgOnUDHvd0ZAWQ/K0oGOaneEKB0oRBg3qQxn8jpCbYUTvioYSQkZQfJKo7WRHs4FZzMSlZpnRuF6ld7D+bKAnic0lK8+tY9dNsz7xOFsWjh4OSTNlcjWg3dagr4F
kgWpXaFjGgEFoZYmxtZ+6lO/aE+depDnMUIzGBdw7UXOQBsabfBwCMGB2lS9r9tghAzQwtYBD3QliPZYQRaHFuWelHtzcXprC7wJ2W9W6S/x3s+baY2N1fhLvK3xhnyWzz/LuDJ/ifda3lPZb1bs79i6tmrboLSW
Vb9JvCnZb+D+MkOUcYK/N+alTmm/4buB1stTaFb68ymnx0ZHPBr85HIFxaiNKrGUistxXDFoP/w3lFplhfcHDpqReZfZUTOeGB9mvPoUMcNOLu3q4dqPrCQF9XP4gpZGoBqEngtiTItYMsgbB+cBgamjF61MkNK3
jLGysCDh/RmUUs/dA+qMxexA/yopS46FpdM5ok0zGuUdqMEglVRwfgMaDnUkiGShGQhOULjaGJ8TqFappQrteqSiAohKjS0WWGszKJFscuCXSwYUIy9SOuZELRLLDIrR+ZKkKVKANIarDXjgMQ01z9kFVTy2hBE+
JTirqJJBLS1o7HPF2Ps9g9GdhhZwgPW4yCZeD2gn0zQyrp7isgG967GFoEoB6gdaGO598MFo81K/mLk7vf8R72neVcW43+HL862xsRB/ifd+3l2KcUP+Em97vIez36zcX+K9kndBMe5/lPy7g2Ls8zu/1ozr8/e6
Ytzv5ogyvtjfhzKm3l2/tr5ie2w3J4XWM+xEhtYV6skRjuYqWoswKlCMoLd0bZqRgVbryvCalaYYUV25ULzJF+eltvr1oxVavdjo25ofVlnlmK02McGNTNE5oRUoLwvKK4LyiqC8RJBttkkGnWdBMSrpYfysm2Zk
TTNy0EEmuKEUvD0pA3pMwhA760F5Ha71SDFaLg2owZgr1E9xDyNziZJKuai9MM5E1MGWNc3YsvyAHGVCA8ZDI+L0WscLiMAKKlaJBGVMqlDvAPWD3pk1aLiuGT0oTGmS5FIGXAklgx72UqCuBD96mQBltNFwUDbF
GPOHYjzrfxgjlKjPi5L6oFCBhK08PKVYOKgPDa0iKueBS1GTBVGJcVBcb8e1UjOt8LeM+8EmeLOssbEif4n3bp4Ynj+fHGVcib/E2x7vk2IE3gxRxgX7S7zX8iausbE6f8d2d5Rxjf7Os8bGm/y9e17qQ/XrirEF
EXs4sI9B+/Ee2Wx6wbUsKR/HhiP4DB3OS1VGtCdgJYYhwdI1q7xqXN8P9CKD/yuo3/MooxpqFrNDCROlUAyuitPOGYMzJW0JznPnis01gX7zMuXipGNauKYZxaAGOc4ntQK0mgzI5FzAFWWgjJLJNVZfA8doHYgp
zQT6nVIe2u80yqibZtRKgHiuNgQdmDaCOR9rztYpK6LJQUZlolQS26biY5TgGtSvgKaE87VNc68TqDctpAPNCKN6VludVPAGxHA1FU7meUo2SMljYKj3pALfUOcx3/++HWKRykiRhijjSDN+Mpzjqzy8XiwqRsnG
ivGjv7TYdVOOxpVQU4F2AyWdeSzwXlTRYcb+PPfn48fk3aEYN+Uv8d7Pe3Be6ur9Jd72eBPW2Filv8R7Je9LxbiA+r2Sd6YYF1a/Sbx7FON+N0eU8QX+DvNS97tHM6Z+aTieBFKfZzrMPL3/3f1JRh+cCW1Fd1Oh
v/TcSZetzUq1oBhj0G1e6smzjB+ewj4ZGIlkfN6UF8tgVKxUBRnDqigO55OCBiqgezTUOHsLilEoyZVU8BeAB90ygkbQVC4W60HnldBW+BBxv2NWGlm0UoFxZpg1nLenAYuIqLbUEE87WFeMwafEJBcg3ZThggs4
qnzCfKUF+pWw2nqpk3ZKgmYMskANY2LRJJ8t9KGqFZ6LaV154OBbAXUJ72eg4RTUG8S21lB5fP4SykEZxRkIteCiB51WgqxQyhWeKupMOHs08FNCheok5jU1g2L81EeH6xvBigNYytIwL9IwDxZbO+RhhQy84RX4
Owp3PgbXFbxSXJcYvDX4XYFHxbil+8EGeDi/eIYo42r8Jd77eSeKEe5/M0QZF+0v8bbHu6oYF1I/4q2LNzHKuDp/x/ZElHEt/h6eR5waZXyTvz3KaNDunZd6R/16lLFNGW2rXtQhingfr2dM9SGYdNCMVw20IihG
hylrQfdkzH6z3/l4NcqoYSwMWsWFKED0WBB0aMUmG1CeaW5ECFZo3u74Fu7+OH7pq34cVF/GvKWozwr3CvSQxTAdnF7kGhJcUVcyZlwtOp9rxcHfwlr+GwAl2XuEl0ZxfP4vFYzuuawd5j4t/VXoJJ7jDFcT8TWb
UeECpQzPw8L51Mf5PHqOmrPdZzj833ta65CtRBrK8ILxv1PfHNQP1HHLiXmuFnsrclxFwzjngoEG8zDga7mCcZTne9bDGGpSmcko035nOM76NVpb6GRaeamEzSyx0PkPrrSx7PvBJngPzUvdgL/Eez/v6ew3K/WX
eNvjTYgyrtJf4r2Sd6di3Iy/Y/tCMS6ifpN4j81LPeRTnWuNjYn+ns1LnaX9RvNS97thZuoXmvGToWKMoBir1aAINehBAf9K2IPtd/1fMFN95ZlFXlkSXlUdrQ1ZgxLJLcvNpXZtI92CK0xEmwPDfKWgGDEhaoB/
QXA6ZXM2yUd8t/5CQbfn+EB8xaJEYoynNr+zzz/VN1VQX2MD9GKqXtjqItwWVGxrVxxWnUgVdeV+h3laoXIyyKbqVcpHTx63Wa5vb0WGc3z3O2gBXpwvrgbW1vToGYZ0xqg1yEpfIwMHnPWOozJPEVfgGNYReU39
iDfNRorxmP95SpRx4f4S7/28K4pxMfUjHvFu2R2KcVP+Eu+VvMP9b4Yo4yr8PeVNijIu29+xYjwdX01fY+M7+HsjY+qT7aeem5c68BjOaywhaofzTWOtTR1G2LvRHtfDlJhFp7osIi8CZWbrWSbfql+31FayTyNr
zx3mq1rxAg/1kYa3xpSa1+KB9rMtnqfaOftTfacRyX4tsE6+rcR4aYXE+67Hk3YXr38P4D8U4OF7gUPtse5D6w73P928+V71I97jvCez36zWX+K9nzfDGhur8pd4W+MN+SznW2Nj4f4S77W8h+elrtzfsd2lGNfq
77PZb/a7OaKME/39Yl7qhPYb5Us9zktt+uiedzNQG77AOz2uyAgqqkZoI/Fpj/lVXA3J4fqFSQWVMJKZvnP7dVOXIqhr7c/E++F5FxUjfh/WX55njY0F+Uu89/NuKsaN+Uu87fEempe6AX+J90reJ8XYno/6UfLv
9nw3M0QZl+jvZcWI46vpUcbv4G/XjG10OGWNjU/1G2vGR+eltifogBcTPg1XUojm6r6mFDHXzYUnBr9T+xGPeNvjTV5jY2X+Eu/9vBmijKvyl3hb440U4343R5Rx4f4S77W8CdlvVunv2B6cl7ouf6evsfFGf++a
l/pw/W7MS72Lx1vt2vNwN/adN9Pafk/5SzzibYl3QzEO+Sy34y/x3s97QDFuwl/ibY/3ZPab1fpLvFfyrirGhdTvlbwTxYjxxulRxuX4e0sxYrxxepTxRf66lh/zwYypd9RvSpSxG8ccMqA42/r2yaaUedIpZpbM
lX1/NaQ05If5Hu1HPOJtkTc5yrgyf4n3bt6HYgTeDFHGxftLvO3xLirG/W6umYSL85d4r+XNssbGivwd29PZb9bg7/Qo4xv9fXBe6p31u1sxXonHg1osImYfCw/Bqlxgb3IN0bq296O9g1e91a2k3u+Siq5lTP0i
7gifvZzdsPLEyGCcXNtYWB3q2uaP97IWrJfDvwl8WIUC8+fgqhoOxji9jP1EUl/421bruLiexfF952Uc/K/7Ght9fZdh/Yy2tkWuH+tn6Atrg+DqGeJAQi+yHfsGvIN3Ynj39byzuNKib+/V4L+H/+WwtiVcgF4G
eV+Wmrs/E28O3jXFmNCwJ0IPOayvy+Y04v2ovFTR+t+ggisEyWF+ykLqRzzi3eINPbY2ayP9oVcvpH7EWxNv6DttGN2/hzi/I27J3xPf28enf+3Sf15W/abx+jeiQqN9rRjH+VTnWGNjhvHkybzU/e7RjKlXbJiX
CvrtwYypzVhTSDEE40sBuelg76EpC+gP/P65XNinEiucMbDkI/d9FflLMU3sgE4qK0JgDq6HYxw7KPzPmWa4urwSbJC6uPp8VMrGqKAcboZZ5gzTVQvrlVEqoMLu1zMxqB9wbCsH421deWyqKOWRBh2s6UDjfIgV
Ln+Qoa24WHJf6UTCnUJk4OEqFsb7mJhJ0ssAfSUkFnmyWWO/0pxFqJuF3lWYisEFLX0GPZlAMnIJOjrVgLoQFIBJ+52vSZgojfQlwGtcBadibXX+8A78w1Ugs8L3mdhrf+ij6uMKeRX3O6t8YooprpgAk/AJ4ExE
4aXBVUTg76ZKVvt8Uka1MtxzY5pu/GiZjeit9fMGxQj95ZNmVG2rbSsPb/D5nXUj3oZ4fXzQt9osA+94bIZtUf4Sb3u83ofryMa9+v31I96aeKf3vwv96dFt4f6e8pqnfe31Z71eqr99/CRg/AxD5Tg1yvjdx5Nf
ZEydMD49jzK2UWg/PkQc21MrxyP73ccxBrXogUVbEvQZhZITPi+p9ZsL+8qrqTzFYJKLzHtUXPvP+VnbaodttcVocRFKCWrTxtTiX7H6Kkvh3jAfvdRCxBAL1IKDVpSmeqyfLzVUWw2r2nlrvcwcEDifSlbmRa2u
qMiLgTKWR+WcDAb0Ga7kUT+tKVFxvUXQjOL/Z++6slPJgei/z/FelMNyFPe/hLm31ODGBozTcxjcMzwbmmqFUqmuKuVYR0jWWMNF0oxnMZEak7OWaNm0HlwuzYZstaX1dbaiqxl+jtRUjLOT+7qR+LJZXNbFZ45z
sYB+gJ2sFTkFKeNxuRMxmmEVX1oFilNoTO4mJzw4zKAj2jTRaoyfLmhnrLQEumd8sayMEXRzAS6dwRaVrcNMAfyypsZwJ/fEoR8ftruC3FW3uz6bn+/0PoPezVbG7z6vu9P7K/TeZ2X8vf290/t79D5uZfxd/b3T
+0p6t1gZ/1J/T/p+wcr4U9r3MXq3Wxmfflhf4+NWxk/QJy/4pX5QP90hxuZ4AW9pXmXyaprXy3eSOHiKjdEBMbqggZrGVKMI7CxPF/BRObnGtMCMMc+WysyxX7IyCm6UWIOGR3nxJg0jAs9kIJmhKzBbT9pWY3Nj
LwC5kqlAXrY42Qe6WP1MdDZbPA/PUbYSMa57xA+zPz6ElkfzEXiTIIq2we35qx2UBAFoMImV0VlWFQEaVAqd8N6ZooCfa8smJPQpPz6AkreukIrSGTwVbbITOFLhf2OB8awuKvagM2UKPgU602iTKXpDjAktsmEQ
nz4+4F3dus24S8ldat0VVfEtBQ9I6QQx1v4SMa5L7IM5cQU8PliPceIYaIyJFfS/vyvjLst7pE06d7mnfDo/3+l9Br0XiPHgH7E+/niNjR/W3zu976d3NfvND2jfnd6d3mvXzdlv/kh/7/S+kt4ukpHxUe+NZfw1
/T2lt7CV/GxI62e17wPffhnJeNCvnmHGkzjHtyDGL+3vTRlT39y+fcZUOStp62edmwjftyrXi3ckXjz1KZhRXcKMz665IcYhiDGcIsaT9kX2sAWgoY5Z0JifrqoyKuG1OaWTNiO0USwwtMY/BUioCKayG2IE3sqh
DsGMfmE4G3HXGJHIC60B8PUl+6ZCtdYq8e+cfe/fuUOMjL8E4vOx19S1n9op2gMTrhCaq2EU01yYQIy+oPVtmAzkZXpsKnXpZYiuuJqSIawtPN8A9LNOMFwkPqM9daSQi24lNDMNaGIUhg1AjGbDeWPDwxNPI2I0
B8Qo/sqvYMa3IEbQexUzfpD/7vQ+Ru9D2W9+YX/v9L6f3qfV2Pgl/b3T+2v0NsS48gF8Xo2NH9vfO72vpffO7De/tr/76w2I8ff198bsNxcQI/OXfGN/X81+867xe+mXuvxPT+m9RKjrneWXmksIEVjQTH8SHfDs
oj8mUKWZcZoGlLk8U89YGeWvNrDumoo2JpODMxoUZoCOwrnIvECPeFUNk2arw1vMlj5gIcGMvmZda+hAXrWw/Uo1zKiLAIZOJ5tc8hqU7awz097oJCvNad3IhRlTzhXdQ8etSYBUrvUSPJT1XmZ00Q6Xw0g1uZBt
sIMenczv41QcxQftvS0p8LLaRl+aztU3+qWOqtBwXdGmhHtM0smY6Fwo1WAaBnBeBihsYu9GA9rEtxZmNLSh+m7QIrQy1Nwv+aV65gXCCIxpBXs6jhLjJfvCjE93xeJxl5G7/C1Wxg/y353ex+hdQYyPD59hZfxh
/b3T+356NyLGP9PfO72/R+8dNTZ+dX/v9L6S3lnE+Pj/yL97RIyMH/y4lfFn9fcaYnx8+Awr45f2992xjFfb95EaGyv7TQYYKo8Pk9ArrCjYC5cWr9S0i2Uskj3mDGIE3uqCGTUAkW6ApJiDimeggWhkzrGWrstM
Oc6mMTIAn6kSXwFtGowNe1Vrb61GwMsKfER0Sv/OYm1ueSYbTfQxV5Na8lzr++cfr4UY6UdryA26hmgK8ZvEPyTZcyTpTtM64g8bph2m4d3U8D+z6kSHhwYASx9dwRQm08U3trLvNTeCQrTPFl14D65U0LrGe5qu
zEc0cFfN1NIMert6N5puo7Scc8E7rFvC9rrj/K7fNPO2AvKGEgBGk63WKTQXep4pRnL95E6KMcQUS9RZ7rHAseueVXOz/IT1e6d3ht4n1dj4Nf290/tueoIYQe8TrIy/or93en+P3gvEKPr9p3gS/sj+3ul9Lb0P
19j4Zf3dX+/yS/0t/f2YlfEJMX5Lf9/gl/qG9u39Ui/mS71Ij5ixATO2qKaZThCjxvUMKeIzxRxS29+OeLAkoDl6i6r+HKUd+su2NWjERVkXI0CZikA7lX6pOmurCpCnjk7qVRbWh8Br3r67aEShMkEjZ93a8DYo
bfwoYk1rgtySaN1rLM71d6yMqfQ5VUy5GqpjjlX5XlsWuso4Sxo5ldMxuGRc75grJYgs0L8dLUtbcPD+eaudhe2Ttuftniq0l3/suuekb1v7Vu+ifO+k/c9nWDyNR6q1kKg21jInyoYG84YvD3e1411O7lJCI5+l
/XH+u9P7GL2bEOMf6u+d3vfTe7Nf6i/v753e36P3Divjr+7vnd5X0nsFMX57+76S3hnE+KPa9yF6NyDGZtTjw1szpv6T/h79UplP/+NWxu0KPaB977cyenwpVxvb9DPOAtSI9uF3d3IVSVTbUpquxjiYzjTMHrHA
XDcvqlrsL7/qiQypS3hSmdFhyoIgntcqBkpMZAEi7p0pQB8fAj0wTeVn5yP/Xl6CG/HUMiIx39idpMj8ii+rpAQyUpdx1Xn8Tn45pbfwN31uw64K5CkOvOWer2rfnd77LuBF0PsEK+Mv6e+d3vfTe4YYHx8+w8r4
g/t7p/f36F1BjD+ifXd6v4veh62Mv6y/++uD2W9+cn8P8YhXMWN9W42Nf9jfd/mlvtq+N/qlPqNHzJhHrSllwYVzZoYcnryu90MrRU3fch7dYWEFrCfgtX84foIcgedUP1eL4r3j93ntu9O703s7vTf6pf76/t7p
fT+9D2S/+ZX9vdP7e/Q+ZGX8hf290/tKejcjxj/S3/11FTH+gPZ9iN4NVsYTxLjyqX5ejY0P9feMX+onjN+JX+rjwyXP1AsXPS/jqC0WBzQYc5kOr/XwCnrrr5TbjM1lWUmSdfVdFrjfzn93end6n0zvBDEe8j9/
zMr4o/t7p/f99C4ixh/Svju9O73XrpsQ4x/q753eV9LbEOPjw2dYGX9Bf0/pfVqNjZ/X31PEuNev3m9l/If9fTVj6hvpiaQckVfNvFZxjVv9Unf0BDk2Zt9MV17p47h8HcX3EX/VvU/pz+OXO707vR9P793Zb35p
f+/0vp/ep9TY+EX9vdP7a/S2fJYftzL+kv7e6X0tvXf4pf7q/u6vGxHj7+zvW62MT4iR/qwftzJ+qL+yQ29+qYIe9zlw3kRPJKQomdk5W2yUbT+IAbMd6pF+5mzs2se2h5hzrSn3ZINjrtNXoxE/Y/zu9O70/h69
C4iR9TV4fVaNjR/T3zu976d3A2L8U/290/t79N7ol/rr+3un95X0XiDGx/9P/l1Biayv8XEr48/r7yXEyPoaH7cyfkF/l9doZ35RXFMuJ5fkNl3wbtvBb6fq0T7aEQuoNeDlGFc/owBRv+XsfPt8MHto3L69z/vp
BCeuezP9UbOro09bVdGsSp8lc6c7Vv5jPp6VK7VJHtT178oy+uTPuvRgZho9ZCJddsun57j+hH/5bxRq6/MkdSporU1veOfc/F686+o9K9epZIM9ti/vsqReyoX6klIRi+1+vJk/lt+73qbDOPFJT2PcJBfRwX69
nlqE3unMlo1H7v7F303vE2ps/Kr+3ul9Nz3qQ59gZfw1/b3T+3v0ThAj6H2ClfFH9/dO72vpfSj7zS/s7/56s1/qb+rv+62MT4jxH/VXstJUW9Gg4uTycgW5/O5yxRYrtRze1D5MsOlTqZCSVIewhsUrSlw66Fvm
Y2ggiBhHsbXEFjOuiqulmFQEdmuuLDw3jvGXY+A52vpYTJ2x2gFEMnoXnOdqAg5WEV/PJhZQymmSFp7jJI6TCJQYOaRSgPfLjIC9MVebU6IGo3vIrZbupC0FlHJshaUck3jHtmJKrqVhdAs9cIE6iz68A3pEawDP
211G7vLHaheHS/M93FOO9wS5JwmuW77DRvD5uqs2XbVU9sCY1NYqxiyhaewjWom2VxmtVmdVDfTR4ppZk4MVFw1xJOjUxwd8d1FKYneOJC09zcni4iyG4ppCm7KcDZzDDMSHEaOkHx9akYKMPePbkXUf0WtBrZhC
3BlTyRa3aLxRk8ZMhDSii/xMVeL8E9z4m+TBH6D3KmKUfJZ/p793et9P701+qX+gv3d6f4/eu7Pf/NL+3ul9Jb0riPFHtO8r6T1DjKD3CVbGn9Lf1xHj48NnWBk/ob/LC9XwWrMx8iijQP+Tf9frqnmYC6+FMTdf
1etVG+WT2UcalvGcISS9tEyTDIDBNKyieFNEY1rVK7oZWnflbHh8iCMpwKVMFBICgId20yVbxaBmpLZgqhlz4ZUxlUXrNRDr8H1WWhyh//qQdY0AmtHmxwdgFJ2ULR7v5By811iPtVXcM7A8jcFjAWKqB3LLNfk8
GppiAVOdFvyaIr4fpwcktsBbbfZavU1eAa1NPAXd5hq3yU18e71j8Y6yUMLxTg3VWbEAHix2MipNrIKPD7hL464GkAYchrY14LVcXYvVVa4m2lN5D+Eg7xG0Zn3Q0YKhvA9o48SYBdc8xq8CBccZfFHN+Wm8SdjT
IlDpwPemrd6lnEfIdChmfKiJJuEmBbAawgTym8rpbCvaXSztg0yFG57mvRNlgE8kkFTb6KydGKMYjS2ue/zug3Fiu/RNEHZq2ZVgLZrauD4ASSdwrgqUDLqe2n7/1fq40zvQu4QZG6+heW1nfzdcIu8/8brT+3v0
lrfLiqbHfmR5bRV9f0T77vTu9F67Nn6dcommv7j6p7TvTu930dtkohQeWOcQ75OIv6W/+2u5na1jl83v8Ue172P01pko9HBc77Uy/iN9cmFGx4u4cGpWJgQvBuzQ/B2YZqoxASXlsHfzYV2+q5u/6vIf2nh3URVM
ORy9Qa3NKgOthZHyQowyEoW40SyPNnOaZedMfwWFNHooejwdEE0qE2og2jRiB+kxrXG0QIaYXANN2ycgVWkxpMcHF7VRw+Xo6kjV01rZsdpWRlVSHoJ3nM+pV4fhD9agw6PZoHKoE4MRrAd61i3I/KoRvfYpVeAu
YCjBMg5zzzytASp0IWLsDiyQUik2WtcEHxqnfTy+g54P7dBfPJcIzrh2BjOybUCTvuBp/F5v9DKd4JgZbHbAwqMn6lO4p6ZRgH9jcCPG4hvQnQWOpi0PYJrtsy01WlfRutZCBmIEBLQK/VXA2F3aPZ3zPc0S8bQR
sL+VhHF0puGuijEw8rxkmyfOQ4cBDPeI0W08gN64gHYAymNCAtgj9FqY37aNaos2poFvwBZyClHAbaqXaEptMwTT8aU4aAflSJQXPPFv1sed3rouIEYnP1LdZm5nTmPFG0wDqdFnhPTo08sr5QjL4Sh+Blnjjq9q
0huBn575OcQvfNbPS3qQenjytKzzKn+rj9H72M/t9NBeS5nNln8Gvdt+tvnlk5WMWViN+Ri9Mz9b4rSNOq/9O2+n986fb5xfS87EGnq67Awzrg+/v32/ip6MF0bP8aQa/7sP0rv4c0JvcezcXTfx8EV6n92+T6PH
Ud14NWy86jZenb9Fnv54ejdJxD/U3/2P9FSsV+q01z+kfR+itzQoQ2fP+hpifMqn+jk1Nt6oTx4Qo8/c9+MwNQKCMWlMiKamhPYFAIymK70VfQkrxrEkXtnyap4XPsUlEX8JeMwOoJCUcrfJmRKgW2q/9dfYBJwV
imiczIWTjJNahnGztV9qq9gaG6MKa6zEWKCD+YgtOIimbIz2BhCmqjhxVx0Oz45R1ZFVMLEU4CHvrQb28z3UkictVzqZwqIcJlN5dczngbY39Bb4ZQ4TdHa1ATMmfE/1XIGU0YJpA/BZwTM1QJ8BVWUSAJ3VDNhM
REKpAnnVx4esgWODV0CIxHXEpU3e0d0TlwsabHlG/Spi7DECXyogX9WKNbrZ6rL1Bni11WJAe2RfMIVAehlzlbC8lNYAkxYc1y3+0UFFXQqNkz3M4lmfJFR8gtHvpakNM3pQUmilAWzDv7jHm8mRAa6swJ7rnpkV
H+PKE2Lc4kPZ8ikt90CfA7iyuyrHQ76CR4ZGezCgbZQStXjZdp4vAH6jY3iaNsXqPrvYQ/vN1S0/fX3c6a3riBjBz69ZGR3r25BD6bFd6QqgwDO58R38L/7QDozb8Ir5Lbql2ssWNb2qqP6z8z/6+qjqWu5gOHAz
Pb118/KZ+ZrzxA9SWKNM/3uXUtFYH7NG+j10Sox/0T7OkMkJMwbJlmrsEn8cdq37lP7urYxPNkbWZ/p4L9/dPi89jBJlzb/N5/X32XMYMYB1QXoxRkZiBHrUYMRT9BJXf2HEP7W/f4PeYc3UHpLJrkzIm5jp+ey+
dvwuWRn/yfitvqUjr9oP0rt0QRqAVye9ruh9lLxwas4TOqT4pIk9SP9QefqL6C379GdYGX9Hf0/pfcTK+NP7+2RjBD76BCvjl+qTCzNqXvPqT1G8Nr/UZRXc51NlXF16fJhh2gkMBQVM0DJwgbLOW/wm/dZ9Z6EQ
qyP9Ra3GLRoCxoS4qY6n/V12Kw+ttAHhjaTtNM7oWCOGK+boAHsadgEP3DN6TLOONi3QqFOQ0gZAjDZArDfrrfX4HeireA9ddsQGNKjQwT40OBIgK9PCZmhtbS2UPJrH9gJq0wyipQlk3bxnkhv6s3oPBVkGqNrh
Z3fTWEsvyl7RJ1+ySsNjQIadanqj0PqYmhtaDZ7SeztcBWwNcTrmp0mSqWb1eo8ZvWDGnPBgQCyVJpodXXYjh+4BtfBUKOA1B1BybgIPD9p/bbXBQoz3Us3AsMzpkm/J1JljmAG4vwF3otMJGlkrqYtlCG0aKWCM
pithQF1JYmPUtK9umLEAMxpBgwxoTC+tjCeIsQJXnkGM1P+AGc3CjININOJ5vuUnzPgWxPhD8dZfoHdL9hvOvwF36B69qo3xjQF4ZpikgC98MdmEWmsqYCadiqng4Wl909m6VMUfvGWwfxWr/ald2W3t87vL7nzj
/YVr3eO3u5786A/1ZnlOEQC5Mi3iquiBfsSqJEZ4+UL7fQs2WvuWrSheeZqclzz3s3/5jQvf3vnoX8tP3cTfOzf8ZpIeJtdZXCySw2rRCmeeIFSP9K4+9XjP83E9jBtwNcS7b8D7WkPG0fHBRdkFxofyejzr74dr
bFzp78t58rsZfkkrLX4p4MqhknUtADdCY1sZ1S5LJ/eC807bt2/Zrk0Yx9q9jUnjQRkdx56XTLJ6WOxbWCsYdHLocDv+cs/G7+XKODxhvw6ec+fund3+e42Hb75nWx8vn3145yXP7efpRX/OrreX1+TsYc+Dmmmj
rjpiM9KpyRrfz7o/O34vo2/8i3Zf7u9bYxmvcuqOn6/xKs/fbeVJ7MSvJXRy6hbZccKpZ/t7gVcvcWrnPu+59Bv0v1BdMVaifIzhSXctQOmWZ+F9hN1YPue5wxNOer2dP9/EqxffOdfft/Lzy3Yf9o/XZcq51f+S
g073t0ttuj37zaX98oaqdpevb9VfFraSnw1pnaN3icP8Ng8vZ+g8V//j/t6Q/aa8RIzAl59gZXxjf1cNxuWXyqOwBswX6Gu0e6UBvGfgrQwkcoan11xMWuVsMdEWpdrqU+JrEOw4pbdRxiOFzd5oBDnKJz4dRoIG
OOzH62RuPUHkHDBPBNDCd+wYQEQJsAbocmBI40giXyiXuNdG4s8c8gzMeMOjibBO27wHOgMSwj+jQZwOYHc3olNJBWWAXrPy0L+cKxI/M8T/s4au7FKQcR9AFsMjCarwnBwzQKHn+9IZW2bWfsguod0IOtFhNDur
ML8YFrrMGm1CSAxh1Cpp5aKpaqB/jMFc2UsP3GyPiLH5CZyp3fTNV+1UG+jvgEBu1NejqtaF4g2Hqajo/crO06IvuoLjdBMHY6tcCsDwkc2ALoJGt2AzMO406K91ZmJ8GVqpbID2DDxZwIzFAsMlWiIFw1WgQYw0
SOmsgAZBbMuc+sQPKx9thx7u0AabvJs2jTp8xx6CSas2a2NmNy2mITPcaJsC+7kcawqWCHU9rW873S/GW7+f3hnEuPwj1sebRk+UB45vpbcwW8TK1NjcgB6hNUCDKdq5MZoLftpWQ50GfJXHbAxGHtDHh5tNpWYz
kGMua95rP3ilq+5aaVh+LbZMG2ajNwF3Dt/oIF1b2F30f8ay4dkFPuGnlF1a7FZBLDT0nfZoX0m6klOTdkb8A+jRjYvx0B7rz8ua1DJ+fCaasu1APCdhewroOvpa0AuiBbm/iA2D9Ftb/vyHnX2tD+YbjvLt3Mby
1Fi9k3WkdnceriUP5GTFYa2nDr3X+ijag2e+a9r/QCtuLUhbbqlI6660vIgXA8cCvZInOhm1leFqrV9i9dgXPYd7vfTs6a5tdTPSu4ekmh02RPpqYAdwTW00PoP/XkGMr9Bb7eQ8gFcwY5s3jFyYfYw6NYTVI8Za
NDm/p4+L4t3PtStGj/cABimNbhzBBtzL8z0jPHVGz176C+ZjioXl+V08GcRMgYNXy2ibL82L/ViiJOTUjTOoheOS9Bczjjt7sNgIM08v69iymZOu3npOJGSF39Pq7+o3eHtKhjOx+YAe+X8c+dlsHHvpHSfvnJsn
6SfjDV6/a6NNv5hlJ1jtlozaEteSD7MEemumIEzWOXUbwuH8NG094qflYvVo4cPmBwSU5fl9i6FNTJ+SE0qzaS60FdsVZ7NHiWK7kXnb1u/2CXvA6H7G47R5Zp3ur1sQ48apor8kkVNuN2vYLTdejYIFJbe9tIyz
2c5wKk9eoehAXwtQeUzIdtWobpz5s7wqf2/95T3j5B5KjUA8KFLDiUSYaNPKlJ43XKSEV5VIuyicOhtG2QeICPafiQq7jKQVDlzrd/mXcZziNvMHXtUir4ysnoOkbiKNn/jy5J11frCTt5e58JZ7Fj+Ppe2KJU9v
LU+SfVBt0jFAvi6O5c4QNuSxzZOMqZW1747+V4uHFm0rPhuH3cGdrL0L3HRAjND/zmPGw8kKVwxXSltjyiyJ2252Nr/9j9I3Xl6bPe8KZlzy5WnE13tpzZ/8RmnRtr27Pj4cd29zlI9VZE2+Fgf1Ff09hxiXfnUd
M74FMX7SfBw4m/tly0kuyXKzbIrye13v11pLLWcQI3WwGUJxAb0tCxma1d8qSKutV0GOTXqf5LVLNpws8NLJpyFjjJqr/uDpdmjlob+zN1t9iSME3CdpdJINE4vAuGKnAzQqPhER0a90IciNwuH7ss/Tv9isM0b6
hvYh404dF6/L4iX5WYFdcm46GuutmWZIdhjKv7UqQQO6Jr8r9TQZexeF/lxPlH2iiFeVWTM7iDUDPufJH/+GVi3vOOHU0/ldOiLxGeAy0OdcnCLQl/GJle0FpWRnynXjpmKhz1TRZlmHEn1Aq5zkjyC2Djxx3Lx/
+d0s3rFe2mWlB2yV4u99VbeUe7jDjnWiHg7zsXonT5n9JW9V7ga5VGBBeifbGieGJ6NbJnigWmuMeOH6OkSedsx7B4QG5DY2GNN0fquV8dPXx53e4brFyiiIMSfsYBDOWARF3KYZvwp9zREnzuh7peEbwCUFU3MO
QTeeOwAzVg02qyW5WG3MRm/6oGT+jbOMzlMlA/UjLXnamJ+J2acyIBElirMKi7QI1BhGGWsi4CdQqU1+Msuxh8AA/4N/9fAulThdMgZrh/JvKKeUDtaCitOMK+gRENfw5AJtjLiLlnVlNVd5LTMpNC5pDbyE9clk
XlbrptF72t+yRUPiGPRUN0RTNXF80H851UKL0iBYxVL0CxxJqDOEbAphYeX4bD5k9yupmV7cdBC4bdaZVwUd5umCTmA8li4kWksxJFfrsNphuQPfQFMOaVSgIl1Up78F2oslCBFqjKX9F53Vg3bi0rDidYZAb+gV
VF4TtTY+W4422n/QZvyQvujq5+MDeodtI0bZm99c//Ys/73PyniIpIY8jabo2vTUxAvWrIP5ypG2Hu8yo/RMkznSBn1dXAp5QsflzgE0ttETeVcZL46htNrT3kh/6mCVM3EUDy5xa1c5jAtfGzX8huHXMRUXrXNb
dSNq2QG3x1bBO1V4FuNHztVBK2b6SqyLNIeN2HNbA+SIpq2224yZj86rqQdP0yrIo+FYY1XyYPOZPDHA+DVr0CxtOHvOrORrE/tYScMlLAu39hXwfB3gzDwTGHwUeac8f+fxQTPnmspT+nfYqagPWCypOpxp8j3o
drlfugdAV+m2/F9KBR9WKB+lhuibIrLi0Ud0TAuOy4LNlNd4m/6VpTnwY8/GYCM09OFiUnPMh8EIMb834ckLbVj2oAQ51HPA7BmpHtVMXzsK7WPBjWzJ0ioo7JMNQoGxGfSn0RZ/OrAB+Ee0CVvF04mKCtZepeuN
rOfLmRuPiFH8cy5hRmLeBAlXm4fUUuCIJgkJZc4ZTCLuTi1izxdOrY7xLjYZ5oWgPBmHXq+TBp6UTFedD0S3OmvAZgxAVr6KZpA3PHJAhVrwarHFF6aI8PhNqooZsSiEHCvoQAmKdi7TFji1aF9niWGIrgSdq05m
CdTWstWQL3T0d5g0iFNINaBHXSJ0XgxY41k+Z6J0oGHWJHOa8hl0nZqbJByY2xlZwTsXzfHrjmfyJoMzVQb7YlzllB46M9/Ru3fA4NBmdd/nQJATMehyWFV6ir3i8l2Fdxl6xiVmpcgNvOgCOpZZGq4wgsrmkJIy
UaSJl/5OF0CZqNkVTBXkBfeT5jP2O6w8BuINkxtpc+fUc0BkBmpPjXk3KjCoKMToesP6yEnmM7/kp1esjNTXIECwxCm5NUZQmcp8gtjaim5A/6Mu34RT2m+Xz5943UDvkpVxyWeikG6y1aFWk6BPOua45PkquHvQ
ztQhg5MCwuDuXVXy1UC2Ks05nCKFh4b6ycoLWclp4nxT+z7U3/dZGZ8Q4z+fj4NvqcQh8gfyBdfmMrze32HFZ/QEM/qE5ZbSmJF4MEnfisQrZlkhXYxwKwNOE4tiXJ/Wpf+tzwNkoIcS44lP6jMvp3A4n8d2q1It
Ovpoo8b/Nro8s448lVUtbudXH7LBiy3CATC3Vmn/AHZeJ6FtG7GvnI/9xV0pQBmjqSRF7CyUtS1sIyK+Ho8PVc6ZE7QTiGkGOI7+slrH17Tv+kWNH/ORY8HuIHPFyhk98ow01bTOwlY7l120QqIB6GZgE+6krpWX
4/3r8Nbvp3cVMR7yfUlNGijBXKHKYnPEvlVM9hOyN2BSC/bPVmsrBfNJ83WEtkE9G9K5BR5JNV9DwX4J3qCVkZhxeb7zZEXxqAQ6+szOQ+uFKM29uRkBnrL3QH9jDmraPPtJ29lb4QkJ6EnGKDuhkfoQI08sBmAS
MA84bgK4zaG81yzF4wZwBPaaNiGlHXGhD3haAvrE840OBvoVfqcDrtJ0vJ5VByfZYABEoFPrCOyqU6XtBKhVZYA2hilrsfxV2uzRboA0O3iIUrF+Af0aRokZvWiVhbov+u9LzRLjX20rHgAc2AWNFyu8F6sfdHOo
mZHnYYzYRm813UdqAS7HbIw4jWnQw0oB9kNP6UWSMMppavp7mMKMYhh2z0BvAOyoOWSO+bPLwEyhYYDlaoRm07LRNsk9nYJi2mpg0u6r+Au8oovcyH83I8Zn9NgGbEc1Neh6YEcA31wDM6XVwYzgcXiAJcwxRLvi
ERZ3Oe4nkPWWhl7x54pHPXJuMda+zeQAnIluHPEjEVktKTN99phUOXjmJpiQqBvzw+FjPoCSY/NL1+uV4zOBFntQ9PClAwbzCAVdoFcGBsYD8YMBi4Z2CyZR4K/EDCJUSJsa4D8wWNXEWaEGIELvLSFZMpKBuuXG
bAIaCqgxs4Er4oot8R4Y0GbmIuuZ6HXYphL1SWjdniH90GeLvFfOvEOosOwXJ2gQO04HGqxyD3SEsuox06tn6Qwrc/a6a6psKjCbr9pU6NNyYpisr4yYx46OpU2fplnAnVhYlTWsuN46doJQwcs1Y80wdISxJNMx
18DIMYCyIPLTk0XxOufXmmb2BFfWHRu/LAsE9vgGOQP9ASAN96sWpNJUyqGk5Uafo1iWuBehX6xXVSI98KVyVtjsv+ev61ZGsdBBjYc8hLZanKshQUZiPqJcwqvAsJAx5MxsJR4T/5aExVgKxJKc6h5qlTVByAGS
B6qkz44SJzfySw7gguKZV54qt5xd+5EEtzWZyepiEPkePGDyyo/H94EDrYdaXVJ0zHYFaMT8ehWywgMRaTkhbNpYG2IAGsTXJS8WIFljQTQLvgDkRT8TtPKGDmJEQ5dzroFxHEND/ws8sZmFHh+LV1nYrDMCyRq8
Cd4LUCOTTeBLkzNPLoAPp2KGCb6Tdu/w/N61IZjrORqEdAYalLuwUiHt+sqjsDhVrPuF6xuPhWigLmKLZX4L68Jgunq6n7BMWWohOAepnQY4kv55gLfkOHy70ZqHvSe1jAe0UvlcieSSXH7Mzw9VGR8BSfNgUrIT
GkgM7GPY+FSn38k6n39eb+0sYjzyn3jPV5GZkC/B0cahQY/SyWEeWzSFznUimy7X0v4B+sbLa4cYj/GD65N1TmJE3ibsb2sVFcneCXECyRN1NU5jcDXYsvF8DWJU0+4yIbIm9l+RwD6wolyAINCcybSdLf2D+hXX
EeOyv33UyvjJ8/F0LXnvebwjtQmvVdFY17K1c0VmiF8NdUJhAWllK5Eh9SEsLOBHR7mwPFZXhcYh+DHKKCSHEdCJZ/qrfrvr53HZ8m+3ItNy3//kTfq9ESu+Mn6CHM/Uuv9X83Ggt/zMipxJ8e9THllRAk2sin7n
2/rv2nf9kloaMktrdntfnjYv74zCf28a8U9o353ea/RusTIujyEeJEOHhbYzlSsVOsaERh6GrdZn5vPAxmZpXpbDZ2AY/F4dbSsN7/PQQ+E12Cr6e+4rqlA8KulDXgx09OD0ypTlmP8Kkj5Or+wQvx7FjMog7MSv
jZmcgRalOmgWa4hR3kITayZZetMPEye1eM/zxkJ/HzTHCo9Cy8yuAn04oK9UsN8r73hXGd0BXBYVLLWvWgWv9VzEP99J4Rqe5NZMfAnRhz2hq7xqpdbEg/g1fF0zH9Wkxzr2MKugOGdFXUR8ZpYmeJBmlAA+Eb8B
00bAwEDNTrxh+zHuhrskAGcjoTgclAaew7TSaAsZXvkIpWukFDb5EUmPph0mKIvUumqwjnWDqM74hbyZ/msMSnMaZTAQgSs3SYVbIkboT6UWBzS+/G37B0/r1rUhxhVvf7uVEf2E5szyRpUIRFvmYW7tWNd14+e0
ycyw9CzxPB3iH9nGiQdxk5pMwTAfWAUPxdjINawGlFNUXvZzRiw0NZkim14gzEfUeHrhHWPXNdD09E7Gq5fMTNmMm3XMSU70QR4vVQHRBtZnUsbxNM0WKDyK2agJoRYSLhntAVUL5JUFMTroN0SM0DHT2qma7ISY
56qaEftgsOQvMCBe8c2cPY8tiBknAzOxRIDqSgAiUdDxX75DNEhDnC52i486xYxe0GAkZiQ/ZibRpj8c/W6JcSz0d+jww58gxiaIEe0DZvS2BJMxJspwHAF2pzghjRW6wrzZqeRcWbDJYOE22gShNAC/ayMxHXbb
M07lX1rR8SlXlUucIchOdBrrJLixr5zfe+1h7bhB8gvkPUcI2lk2oIta93adQYxbfOMmOOU0IgE1+oB+YdwhSeqy5KZd++zmhXTwXVq2avrWPuHfJSsw+6FF1n92dBjqdUBXcjoMsAsHk2OMSbW0iCko1hlcwxz5
jiErOWTGI0LIij8W3X7wmcuGtnXAvazk3KoxMfug/TB68Q7OE/eApRszLAzhwJYHT4HpDyzYC1xQgtWCGQvgp94qaIs1AuxoWleKng0iDZOiPYjgUhGsop/JakGM9CfkMRizCRZ5L4JXHf3i+I4ZchdP6GJ/gRgX
GjQNLYJe1xhDgfnlEcvmmUgfxYa7DFq+w4wbYgTmxhKLsZSmokhvpTXbS06VLB2B9gpmDRRe7GLRjZuUsTtpXmVH23tPLb+1l1x4ys/XrYxyYhDpfRAdEJHJmPtQ6cvV+8Te6YtLzJ/onFrxCbsWvfv6Z/rLVSvj
CWKsafrKmt+js54c2NhxRWT6LIAHMSIOLJOgB0zZvZWsLLAQbfhYXo7+Nt2V2Ne50j/o70etjN8wH0/Xim6UXKgXYwTO0ROMN7HvMv1LKsB/sWJPNYD2ivsoZAgdOsTKKF6oVEE09hTMYk7T5jHFX3Ru3uD/qr93
end6d3qvXbcgxgM96mQRKunI05gRprauYIfD1jpTwCuwzgD+CgGvJviRoADaiT0hpon9MmK7L8GFmrPD/tZFt5hnMKMVzFgjVBDI0qA1PfxM5VEXtlI82wRm1gkOWrYe0CR8ZD1Xrz2zl0Avt5pWRppQeOhoAQl0
prZRWEtmoN1i2EBjtJ0JGBRIRKyM9AytXeOBaB+tQC7kVTfEh4I2RaixOom1VWuAN2eYHwbqB7bzAe2/NexM7ICfPITO27m6TsDT1UtV2Cb61MF/bA3z3srog/KsAnS0MsoIQXOiQ7CuoB3RP+b7Am7NPWTxO08l
dEAf6jlWsbKOcYb2qtYAg0NguyYdyUpS0BurNSkm/DBfM9AXtELgDy+76YqISpuVEbK+QJGK7TYr4438d4uVMWwjM8XHnfgyibfCgJbcCxjKW6slT83yMjq3rzjxvjNA4gMdWHbHuCK4qJ8Wej1BZaSXXY/MNUQr
8TB2uhbnsjJOzah/TDUwEMMMFdEGkKMN3gDreN8N87rJ/lYndD1aEKufPZbAb9NGGTzdRP2EZmCYpLxF+kxR7SnWs1ZBA+ACHAUwtYq5o7Tkk3Y66wRVFm95xkCUuaLKxGbc2wRY5akNfoDQ0oTK3lmJOHcJgSzK
mzDpT47VzfNYNM4yJx29yHPKuvs5xBu7gFoupe+1qIUY6RYeGO1vDDDB0PQNR1dwg6M/HE9gEqljtZ2xMgZaGbEeJxAqfcg9y/VMoE6MKKscO89I1MzCVMwPl3wNWAaKxXoYygdti8jU1dlf5jQ5tTJWV3d2yCd5
9ZXy9KqVUaIOySGpzjhs0tCAhmnpibNf0JM4VU5Dw8AWzKegkbJlvGGMcrTAeJ4Gf2hhnWdYdLi22dHGCP15TjftAFKs0PNM4uoXNAgpFYDEknbVgIughY7GtVQxqxaMSPzG+iR62gjsPoxrutBfmXZk/JmcltWA
u6RikWYuPUiToNAQ+mYViFyr6NCbgqMveJsLWbXhGeHCqhzgPy3zj8VYILUjfZRzyZD0nl6fNk7dCquUYR3Q518btKmBInAevmCZZoK536N4UDs5b1ojtzAjq2M7oOYIdEEOLLJf0Bu2GvBiqdiaDLBGPYsYmc+N
WSVijUn7KLxKfR1v0YYPhVk3ar39xEvhvfLv5fUqYqS8iq1GnpnpjJHQnanxiV6Hm1LvDM3kfvTiRPIz2vfZ/d1fZxGj0HuBGRsWQFAuYF1hb8c+xpM2YHFsINpwH8euqaZ2PokHhxP5q30pPO/EPmiCdmJl5DPe
XQv8Lf29FTE+1df4iJXxU+bj6VqIUfxSJT4+vH3ERurYBspotgwoEjOW5CHUgsh78Cz/wqvGfEK5Yc79Qa/jsjzQ/nF/7/Reu27JLvaX+nun9/ISxMj6Gq9hxr5kLHSXkgCQID14PAQkMp3NjDXv1WXiSUP5wlRO
OTSL19Jy9o4ZcWJ0DJahgZK+55vnUJUqn1NOSquPzjBCuPu9Xyr18Z1napTIXYm0cSXa4kOyPFimz581A2rzkP0Eagh9GLWhpsxysjZbaEn0b/KGGgV9u3Lml4eiQ6KhazUduXJhSqqsm8nYq7LN1Jc1sG1jEAy0
hgH1HWMECEj9gvqaiYY5JDAWgMqEzA5PStbjCug2HYcGyK28p6fnm0QhFrBMcxwYych8LXXmLqiqlNzigAqli1NAIsonqC6YFT10dvQXNhGYB+MwMFrelJklPFRXSF765Ook/nAAFp49g7bu0JpYE/BggrrOjKiM
qNqQorSJlWo78CkwI3TxkmPYRzJ+kP9eIMbNPnPQkGRfqoxIq2SsZIuTKlAYVLQEfzXjk4W+Cs2ciGLp1uKBtiyRjw+isdJXDb04E8vYVzbdAqgBDbEDtynJpZOkytIgYiz4n1EUNBKzHhB+q9A4tGdGFZeSAa5M
HiAvGGiUVlsLxcQHpgYojd6IjC+UA1qTOAdt1Ah4aKjpY79s0Fq83MVAumQx0KBRJRs5czbZaqTiMFgc2Ng4OlfOVrHLMj8S5pqpuk21YHYbmV9PQ8dojbGVQMZ0mi0glITrWX1p2hqSCzo6mpyYEa7RNcBrzTI4
ZsNbT/lUd56pTiusFWjQjoH3YO4usfFhrd0tlpFrrNHfqwALCGJstdBMBETP8w1FD1VZDc7QvZKHHMmuOFETif1YJUvJ+sSKshqrr0J6pDC3jE+n8m/FMkLa9ATAYoycDrSDlPp6eXoVMW7t84kOFs1ynlj5GQMt
p2QHv94hdyU5F3H0zmcs47NIRtqXPPmlZhY/dhAgzG3e6PcBNnGRmBGjlFwWazrGQE7RoIkGSDdmLbctBMCrDC2UHBaJ91kr2nfIa4g4zUgxfA4uZIjwxJJpxYTErBGDhcMgs3BPtQRZmBvNvH/VLBtBoU8z8GU3
dKEYLhkWra5WQcYrQH6fY63AcCx1REnKvLYaAgsLhUcqPQ1Pr3hGCjADvxrMSg/5PGk/h/hn+oVsIGmTs3QzZrz6aRbonV+qtbQyAqSrQm07SwZFL/Fg4jl+EsuIGcuN/Ea/1DxCBCsHPB7IIjYrvGrou6tigbSR
TA91nad9RXzZdcxYqamlCiwISaGK1BZX9O8VKzIanAeDMSwtmY31Ok5G6DPa99n93f99i5WRcRfY7CXnkzGaWa1rS5DDDVCE/tlqmiC7t+axdcua2QTyJoGr+Flj/sS3KZ3N0PEl/T3EI36GlfGfzcfTtTLisN77
oX7Ge+lJrcXe5f9Lr4zY5y7cJJOh74cMKz9Zf/6/0FuZw+bKcyb+wJdrZv6F/t7pXb5utDLKBawk+bQ0o/mK9SWPaaDpQMZP6MdZ4goh3hlry4yqkVmG6QQK9Wg2F4C4srIT2CnRkiKX+Iv2go0vZQfsQwcoxtAU
QYOOQa82S846JV6pK5cddxPm8KM8G5J5cqsPJPlATWfuVWaL4O5jIIXojmnoVVflB9/Ao6B79Z4kq2oVxMhTbF+VeIlDb8I3oKQDLzBMc7KYjOh3VXLhrVyjBa1pQAPAppWn3lqyPAJ5yLdPniba4vn8wCurCnNr
NSa4ZsarlJgikBoBE1RAE/R4xhTdefnpJYyHRNbw/K8xV5AvMTlgxryia6LOGGf8rZV4oTYo6dCYDENyHHqKrTZL7s0sOQz7IbJ04QXsxXEAYgCJMKuWrQstvuPM80x/r1sZBR0U2VB91tYrwMUeU5nJMEmj2BuT
NtiOXa7BmSl7jFmeys7LOYFLjOthHjEl+Wqn8Ijf+hiG7Rg+l2KWfC1QZMV2AI5lpJ5NDHLLIxoXJW7c4UmAPEZ81uihjJFkAkTm+QXiYVwe7UDkud7EfxdAm9knaxXeAS/UJk842Cckq6rcA1TFezC75LgqnCL7
pPxe6Q/HPJp10CzerWSEVeD6Kd8qeG0M2wUliW+TjMHiCyAZezWzEOO7jfVTmXewsv5bxL+D3yY/brk5T32OFmI04pfKyElHDsxRMhp3yTocV75imd9wyD1ZpRoLc6h4es7F2ES+MMOm1HBiazkWVerJtJWlfXnd
JmlrYr4qucsx8ldW1DrFONVWVsZU8TkGZk9RYRZ0lBxBz+s/f5E8vR7LKGexkiGz6eJG5EJ0hnkfGXLGmnvFg6XRUwU8qCTLEi3mkZmimVG0bVV1mEUParDyPo02WaxIvPnJ77SuYEVkk6qvjhZo0zBF4GfDZBFK
a8riSEMgR1+yCysR90Mk50IokXKV8Zv84amMcGp6sjeLPS/IXXrHq104bPlBWMlc3Zcs5nZS6QfaRQZD+h05VY4YZP8YW+2uxasF/ERexTAdeZU5LsHrQo+cyrzDpx6f68riT21zp1MuhoPJleiZSu9pntItXh1y
HrQy/HFnGiJLCR91SNiVpLIOTyGZ34LZgSi262zSdvlO6y+rHL1X/r28riPGJ4/qohrrq3nIlxwCT0ww75oVeiC28gx9i3H67PZ9Jb3riFGLftCxeHyE/NVOM9f/AIvLzpEoBZgeL+rJk+ZSxVt3MHq99U3+jsb9
K8re/Y/7+3a/VNobb7IyrnOnePVym37/vr7tn3BEjF8yfofMdjzqztiwfTH0+2J+o7dGsX07P/81eksXgAQcjpVSuM6wE3FWbsqz9ev6e6d3/XqGGJ/8I9bHzzAjLyc5bbCmox+t+mBLnOAeKNMDuFFOlZuCOjFZ
L+fxIYTpmiRUycnR5Qk6fYa6TrFPjsPGXpkBwWSWqGEewcZT8xJz0Y15P4dTph0u5tOXbHG+DqaZOWYx3ldZfKrTdIgDCtv/fsOp69ODvw81EmANlXQX38y+9TJs3wvH7+7H4bRKZDj6m7mj/AvPnnd9JiReBeLS
0DVNd+PpU8r6sKLB7Z5xlJ5hiw0mdTUKdk7opdlD2CZWzTXYZrsk9pPv8kfq07XIOrR6aDo28i7oGkBHSjJGGybSbokpAzyVNR04uvlSVcZ38d8VxCj02F4LyMyQTZYLsq75GHxhmg8v2vnsjMEMLvqcoTKbCEUR
2NbUYMAbmpbEdvBvCkdOcBIBRdqJ1gZvmL+DNTbq2hEBcIjrg0+2MB8hgCuj0FitCWPK/GtYH3nFL83+VO/LHWf5iQv33PY0c6dX2PILhN21v/c5f4WNu/0Wq3nmW7v99xzXu+0dt6N3sVZlkfi8QXsLxINkkOzi
7YcRwXjENEJ0g87idMFOOYfqiUqZIsWxTq+PYTtbXuO/4gfDSV+ejceZMbusK0yJrwWsB5aGgqibBm/XkE33h8xrb71u5udbamzErZ5mAUC3nuGWGDXwaTXMk1shQvHDPpdVFyJtM7tmSeIbs5d0yxJNOqR+wNFz
XKKLwsxMeEteHZKJtTpPbbOJv5dkKhobVd+fy79Df/cccYVXL/HccRX4E37ey+BL3zvw+UVOFXl6nVeX5y5PvYedDkwo3tMHTo24UlI+Og/MyPxrJmfwKvYo2k8oOwJrWSc/BW3NMy2+kkXjk/bzI2KkPfRixtSy
RYcCVRkHAQmewFxbFj7wQ/Jdvzhd+XH6xjl6lzDjOkkV25OnqwuWj2mW/g3MlMx68TnzNKpG76ZnpC3zRa5zhT2vXebqL+/vc8T4pF99wMooK7lCu2L+iDx4rToY+yu3zDALVp2pt1sIHw/1L0UvbIqXnEq2/anG
m+hJbgHWdmCeAPETWz1j/FHsy0No3S17M+RbHOBsfjxy14wHkn17w6tyzp+3KhhCqzM6aWVvO5wmSb0GqXRBfxhWn4hHPZGap2Yt2a0exqKRu9Tt5lOYzFrs0GH5shzfcc/eGds75/hl3SVVoKSth14bqb3h+/Pq
5FLfB5/ZbZSCtHv5SxXJQ3vgpsPny9cubJ/yaXprU1x56brU86Dxg2f+8hTuR1Jt96TKx8qzJtFRMqp64zxow2NlDgs5NYwPlmqxiqEWZUgOty7+NHOcq/69v9rKeLPVStn7AT3xkdzD8/bdXXHjHSMehqsOyTab
kuncS6/ddn9+9jQztvp5XbJe9HAyE5JkZKsXIlHppH18zhpdqdB9dn4/6fqV9N5iZTxcW/0s7L/Mqg5dphRfWPehNqNGntPEipdcKnc4sJYPWPs1KfFASLaWIHzBzKGyBqVajZV6MfRKXSelzDEQtzo29vklOtUr
p6mvjt/K4u0aM4LoxLyFiT6a8tkZHeGfzAd7FZPNtFzGnJLur+fisAf9b2Wf3cZILQ/fF9JJ+iefjW0ss6yMFU0VGE1VXAqR8qqsGgT9U7ycjv29bmVcs1Lwd2HC+8yc2Z3OjuCmpVXGY38VJeAJX0ifnvr57JJv
FuLJWgv9l2V0wrF9q5eS5+OE8w5jGU93iHfM72eM37+il7Z9Z+v/sxXYid1Z2ri3bGJJK/8pKxa4NArRY6YzY393zNCN/ZV4aKiPitCshDRlns7w6yeO35bP8hXMuK7Vkimazn78pry6fowgfda+sHB7c52ZOWuy
oj2cyqXxQkbqo3Rsv57/br9kvqWeoT5ItVOpQN+AyvqVLTXwKmfL1JZjjkzaV6fk+n6Wt+8f9veWGhvrWpoddcF53C95MvBaHdF/Ox9voXcJMa5r8busHllvkufgac1sOaTY/1Vz9A2y5l/09yPZb6S+37n+rBhD
uTYJVJ5f633ydw5bZYxz7VuIOj1di6OCXFShvZR/jo1Bh75kL/U21v695VO9OB6CFUurkiPVBJZ2BpT1zAQIZcPTZ6fVGnITaVWP/t4GCiOj7pP3VcXqvEQvpMa8XYXxSnmooLROrDOvGJcAWpL9gYYJFnkb2HcM
7fFGWasZo6EL9npPPJSHVtbFWNGayDh95VQpLkSjKwgPVkazHtITsNMxa8WIeMf5RH+L2hgQc3yPtbwol/fIcZ1gUXYP42wIHk9PaC8z1A0r3vz0r2GVDvHfaKIBB2ihmCEW4vFOVX5DRzUVI2cGA0joFsR3mfZZ
rRxdYCJxpWLseh3ZJtY/8hipmpJpEsPFImuMQHJWM0d36oY+7J19jipb1mnTEIcS+8P6axLLYhXz2YZYHx8cRpnolXnHMS9SCcUk5gRjFiPc1TOmR4uHzAs0aPuG3qIGCvAB9Gy2coZZ68Z1XjxeRdOXiKMQGPvA
GPgsPikD2zrrnxXJnBa0Qe89ZiG7WYgH42h2auaq1BhT4ZBeoyuppcCoMB6rzDp8zLoVtVYg+gau8cF7LDLLfJaTJcA08wkaz2yHVe7UKjTHfFui9Y2LfP6t8uUb6F1EjJjffhEz8nLbfIOfamN2EEwJK32l1CxP
TJQqTDWpWy0jR8/8iZ1Zz0aHvGAal0E09Fotvq8fv1XhR+LjN2z1KRm6PtS+Kh6G+xO4f8cvUnFo88Dl3++PX7h03ZT9ZsNvpa96c1nOlG5Bz7e0b2HOtVN99vj93+it9SM5rPqhKtzKO3pVf/vk9m31u/srWcU/
ob/rusXK+Bn9XaMb+4sa5L+WX76P3pLrG6du9su8ZT49n+X9X7XvDGJ8fLjOT/+0fV9Jb0OMwEfnMeN3t+9D9C4jxseHd1sZd4hx6kkDa5uG9UT47+EVnzCYXsrAbrbB5WewsOHklRwvJriLJVle+I0LITnm09Ke
ybULS/s5IB5ttDXMq+dS4sPbMmT6C7hRpHGcLL5WRoQ+Sa80llmaajAhBnDDUIZle5mRyLCoMLGDZ76rqeMGibxhzaxZWch19pFzBm6dgfajxmLU9GzrPjBRHUSlXlEn1vuSJkhlZyGa5xiSOy8ZjaYziX600pA5
R5ksgdaj5ENmfSGGcTMapgNsxFE10DffcWxclZLLx3dGjzXH1lc288PcEDFq4mkMWNbejZFZRHGrT4THD8dqW3p2INLYGq1qUdM1po3INOBoGXrVGKfci0U/NAu4ib98KTmqlVORgcw0y0hcNjSo4jWNgnTE9jEZ
hjr4WBwwluhYltXmhtZKMze+KfnxITCPHnil0tKWldPKhQ4G8JOJNPBYur53OjLgY/p1RSzWavVMYmVkJbeggWHBDDVgPkwXbe3Ug2TlqaM3ADOHF4OpIBoPqeQGcGgZ0FKHaTWUYloOlvfwFJj5UHSyjKn3NYU2
G0eFWRqmyiPlwqp3iTnhlLdKqkZXyQ7QpGpaAqVoAB8HiwxIvV5nJmvxWvSNLS9oA5NaMnF4YdIM8GCIWyWo6lnri7nHSbu1TJnk93vwz5Av30LvPVbG/SUeAeJ/4LZI5hWJNYEhGSuXHf4fw4KvR3GpmbE81bR8
80IM7S8avzu9t15G4ldvqsv4J/p7p/f36D1DjKD3Kmb81f290/taerdbGf9Gf/fXdSvj97fvQ/Q+p8bGs/YtzNgy7Sql2VqqTzpMZiyOvro4A1276P0R6YQNiDPorcAry8Xze17W8OJ/+FF80W6xnZgRHd8JHvhG
FWULzUDaaxdUSNC35RITZLwyfsyyvvwJzfIJnKw5lbJqeIfI0CjajRM9jAew07AqWvoXZzphW9eixe8mMDwb6LHSTKWc8p4Fb5jL0NIT3bQICBAYjkxTHsEG9P/s13ke47tZGUgzE52Hbst08gKRi800qCYbAE4Z
tdwScF5kbSs0UrHGGvAh31HMbhHnegf4KOE93VMFxj6DGZmbmYgx4Z4AXLnu6ZJVMAPN5cowrQAsRiTP/NTMAebtdNGui1XEssUsJ9ZuRtubZDFrGZ9hwrRD7yU1mSkSlZ6Z2gI4CeBRsX6A99rSd5s2GmbAYJ5/
MJyUyhPfOnGvKL1LlKL1rO416Kdag2QiqskSIAdvimO+NDyoJUvbJH1y8RDxcGnJMVYYUxmdZ7xQXfVrDudvW2bzgtmW+dIdzWH9I/aW7oUmqYC2hdTCADdNYjirWSW6Nd1wV5cxCduYcNYiCzgDqmpIiojJzszn
Bh3SsDiVYMZRAjBjZBa2wgj/YgPuopewzmPdE+lN19lua+hpC6zOrPgWAwFAj/mIaEeOzeFPjkf7kDXp98irG65LiJHJY5h9RYs/sHrjZeSV0V/0F1Fc5cw6QL2qDTk/XfdpufODr9K+T6F0p/cv6PE0oZuVJUhi
DZgVZApP/Ij23end6b1Gb+NYHgirlY2zSa33n9K+O73fRE8kopYzevHwGmYvEb+/fV9JT3IwKihyLDYkv/+s9n2M3oqkM/4aYqT/5DusjI1HrqxHNMvUQIiBGQpGnPSXz8Mva8lmZVyXnEK0Q5Aj9D6veTmgKK+c
o0tqyVTLmtj4WlhelMRHBlq1wy1pZQyoMcTA4PHGuhjMy7eesG/lsjTQpy/5mUqZNNjoqTrwQldVNfqEFheTE896oA9TVU9OalHRJtg800sA2xAOMAbRsf6vZ9K6GIaLklu1Sj7GLHnrmFGNWbyHc96nyERjnvGE
QKzV9zQClFlAoBaKC7mxpvXA2EBH9UXhxgrE2rQJrHfs8TTWR6p5mOmNwztAtsCMZXsnamCyHmt9HTES/x4wo0QSBmA/VqFj5mnP6kBtSE0s8L6k2Gb86QA4oyuqAbhjdSDAG6lVK+ftTQHnOeb3ktyFAHbQpDyx
v89hpMhSMhhC1igfks0RY1KZ0I9Z1lnDraJFQ86mpF5v14PYy6EhhTFaQ2JFA91BWeZbbxiuCz5jHm+Tx0hyTymulcAc2brT6lq3+J4D3+4x4wTCN4lZ/yamdmgtle5sVqFIbdlEUMxsJqxw3aqJKlov9Z1zio05
/kaMJTGrnlWOtdJHZ672ZK20CSCf8Z+RuaQV2hQBFpk+M0u7g1gim5zvElfOElvGXdnMwgrTLMhXbOkGZKqMrtSdbrX76xVJ/xQefP2qMn5nMKOTnyV3xht+ln/J1Z95fOVRjhwuXn4Velc+f+vrnd4PoNdZyVB+
5uPDVNjx+M6rvPBr+3unt/7i2bfUoYRs/4ntu/21S2/oKqP4imu981Pad6f3u+ht3LN4CRJRHd/5Ge37Snoi++m1N9148z7ws/s7ub/hZ9WUvmJlPMGT1xCj6H8LM1LfrvPqTxq8tvjGRWFlgBH/CN/oTwiF2EX8
BMcCjNUQRLbOCs9MPm1qp2oI2OaDt1X56EMcrKd4PhPOTj+V+kCAjKZ5saE55iFOjCYkX2eplmalIBmzE3STAAYd63m5sfxmq+TLGBE4k5CyARAnD8BQaijeQMn3NJ6huc636rC1hEqbXWNNHkBa56KhA29IaE3N
xQADEW8lH1wyPsnoAAgnUES3rKkRo+IYMecmy15Z5UsMAEkTlwe0VR6jEF1WbmLGaD9lfOPz2NprVkbmEYSizYTMMTtt5rQjsLRtzEXRvfbxAf2SWbPKFvSr5+ireMOy6k/xmaZDtMsl3Oc5akpi8QCFdceAsAym
9azvRMPgZHwjJjHRo5f1ajC7xs44A0vJWYyNnFcBuKFDqQIqNzNBuaYuFcAjo1HDzLWH6ZSmf6cGuMKg5JQS4BvwZPGdldZ9lvOB06iQhRgHM1EAHAc7TbPNZ/mPEY3AHzO5wkSNwLqdU4N+V0gCdMeppEoOwXsb
j2PSAlmSKfnobVzYJkNTZbSB3tKPD6mY4hjPWEErsEo1c7hznQ3mVUmbJTIVMlDVw/jae2iGhtaAAYzVgxsY1uuNwfqwjIO3dfXnA5VcvwS/fQe9G6yM/Wg9fIe98fnFNaWrY46KYGmf7o4FHj/n9U7vV9CzIbLu
XOJBm2esNt6x39w+CBd5vakdf2w+bn99Nko30/MBOtHQLKnWXXTYbZ1Q+un9vcYvnj0qwfc+83B1vfMP2neFU3/R+H09PRtY/cm8ZUV/W38t1wcUymTnMNDRoHcF94Pa95X0jJ+KfqmMFJLff1j7PkSPJh9iQG3V
yc95v9RDPtVXrIxS9aL4AlW7spSvqVouI9fud/pjEiweM/8+0/tSJJ5KRiIadayxQhUEKhk9QHcfNbYILA9kkOdk0mzofy0TCGl8iygpX4kbX4gx0SPWFqONGcQuVhxieyNaBJ5hIplIS45hpVbgmtEmHrpVGFq5
P1MsTIc9qs6O1sQR8JKyDTPMqKDjA9N0yZUN/MZsbBkbDYCfTxZ4AL2K0TVVag54MhBltLnUwm8H9Iblx4AJWNOHmXVpu1WFlsyS++MD7kEzGpAsR6GUlnl/KBWII8WthfteHxCjl1pTwU2JZEw8BWK8aVZNAYoA
oJncAJalLtSqN5R6wUsBsmVqz45HALAB75DqYNRenizEy8+EMWaUetG5JlWZf8ZKPWQPyEOfU2asS1L0N7VSRsL8Ydg9D6OAT5UHVE0hZqaaqbNUusl09nfEmQt6iKeAdoyTGUxZermbXggTcwEtQDU6sNKXNIFv
cM+h/yeem4/Mz0rMOEEyk7M1EJ/JSkuNsSlxHc1JWXWdsQpqwLAa5lyMtS3raGjoQFhLgfGmcUbmdsJzpE1N2lQTgy+3JZMU5twRTgurOezPITFrU+Y7koVVcjyyfi2gusl+oG8YJdaMqvvxrSo7hpce8vX+QPz2
7+ntEONT/mfBjPLxSSwjow9jY/Vlfcsr69E//YWVTOu9WTZ8cGPuUcrcBf6DV+6ZUX6PMZ17RX/39x5en3/j9J71+/79uKN37hvPaV9q34tvSfsufXv/7OdUw3mqN9K7YeSe9feTXt9NL0RqQwx1LiPUydODqN5I
7/KcHUdDxi9d4ZT16vnpUBESbcRWV2uMevndC/xybU6vzvuOn9OVvpzj4bP8/6J9e656esJVHn42fi/GqU/+PhLGqQIHTh4O3tLuMEhvspicGarOht0L7+kz7TvXu9fWx/nV8Ma19yb+89EoVqTB/rLhRnnn7Pq4
zquX5vfceltzMGQOcmspCK+Wi3x+lVMvjN91fr7CqS/4+W2y+gUnyPjdyKvPqPJ92V6glPVkhFP7C3l6vmW3yPsn+fIOOXxWmlmhN4v2ZjDOSPIMXrj39XH9WfL+NXouNMGM1BLk9yv9vcJBR365zCn/vL+jJmbB
jDrs62tcxow3IcZNG1vxPVCoWau6yCXRitvvfP+1XHHi+czEInRuBf6IjF4DbsvM/1HNHBWYdOYamLGTvzNtDVDCsl3Gq/56btNPGUfH/Cf4tjI6moDNtirm3gRCiJhwxTyXXexTWTKoPc9EVZbPKdeb5MCjPtok
K17f8urz+4R29CXMxCCAqgl4bHpm5t8Sv+5qMNAeRnmwvt23zPuHLD5Fnljl3/UTJWdWlXbs3zmnjx9q/gCp6GIa5piZOvXKmLosza01m7og7mX7PVhq1yisn7T8J7fP7TaWUfKLPv2If/GGUMV7lng1rsyJXfqQ
ZAZylXodQ1ttrFRPK0CDtAmFbcT91oK263U5+tseRqZKmzlPh/FLL1q5v2hl9KERtyonzA5U7P2WKVby5VViDLPWh6O3LkvxMqtq21rWpRfbqIhlez3tTJu2MZF7Nv/Yfc6zp57YrcdJvrnoZck1t//Zj8DPxG/f
Qe+W7Dd6WdVbhBRx3NXoL18sNmKNv/y0+D3iE+fzNPK+272yKqseverEsGqp+ADEWJga6mmPfXyAzm6vaAFrFyDWSLEpj1dIHnmf3/LPd27Qi0wO9WLHeKkfee7XoFfkdaj2jPaBXlHm2fe8fCNv3wNfxy6vLELu
pa2rZYeerB4KBWnfem/pSebYi0W1q7S1I+LJ+YVe9TRWRUl+0Q9oLGdeQe8TtYNn9C5gxhu1Kxl70LMno1+30Y8y+mEb/XAyxofR32unlk+ejO8eOndW+A5baxaNKHxxTjfMF983u/k4PMk8u2vPTe5I7zDjVWV5
R+/6647ze7irqXLs6Tl9/+kJftfisOO/J27z8rqo5o17D5TWOEGDxeouOvbZePJDzLdWo+Qblm+vdRDQu7Ktq8NaAb1hU1Bx6j5YEy8O+8Tz4dkIkN5hDT6h0n2LDzKgSfvckfN3a2w/18J/9sVMrfHVJ/fehBhB
71XMeCJf1jsHCfGCU0/4JZ7IwidedZyDMYvTdpjG3c6LDD2d3718eS759LOxyUcZeY5Td/cc5anb9WVILw68avZzjXfCrr+LU5/m+kn+HZ5kj7P8glefcarbOHW9bk879neNE+dmFK2Z7Y6V3V3o8u2KPhzadGj9
KadelvfXOWz//hkp/Io8Fcz4CmI82QNBb78LBpkbf+UJ3ynvr79eQownYyz6wXlJeljLBw5a65BzrY7jU2UHte9q34f6u8eMb0GMjw+vYsZ1LbQhnqdp8tq8UC/7i768/HYvK8TS3ML0lcCQVVclFksvFxZSU8x1
w7sfH26zuxyrVrFYBGtc2JO6d00q/9ldfauPXUKLlbcEbz3Vnvk6/fn8dajK6FghmtUttl5bqcoYpL7Gu3O1765Vj6zLfFQPhBxpj2EZ05UN+mWbDhUmn6IvP6O/16/B+jhS85Gpc2kRPc3rtWp58RjCdEZYchZf
qZbza/HW76d3FjES76+PN8xoVj2CmoseARKZ+ZmT9a0kbyuN69AjDQAktO3kGLGatWM+W4VXl0DPAilGyE1wqmLuIZDqPH2ATBWD9XSzMoNuzLYfd4H9vkF9VdXkKcp4vhYmY3uZs3kMfl5NWbvsiNlr3sXkyTFZ
KAtZUAGPKFg7Rs26abuOe8gwif4lJNSbmyzUgq0b0kwN15jTV/EuZmQm1mWarAPiIZbgQ1qbrIlq0SLXmMyJ8qCjdYq16TBaeXoG+Y7EGrX0y9MYd/YRzzGpdAxIo15sqJM3HfKEdAXVhLZkjIwR+0xK3hVQClZT
6rCALzRwNyXOnSPn/MnIXXkVf5pP2y3fTO9VxHiB3k53HCWDxTDLGAeZM4aq21bopM8I7hQDpGKQGeJ8JMnKNuemYx/ocbQqW0M6rBkcqx8HfCPvyw+PuRhHTa4ZKtEev/gL01yZA82x/ctSSU6h90wCIpg8YQPC
qjxL3N/DHNqQiClCpdHMP4730iiV2cN9mzP0Cl4c8gzehYWIhaNmBjqJwmcdPZUattjV1aZfeurFaBTWm6+sf8tv04tx1xfwfkbn0Rd6g83c9GDavTHIw+A2OjJBAykpO5knQRQyH2uc/DAZ+xQYUI9RjbWTEX1t
WzdRONYCeGNHyt7VxdXbSotpAjFOie8pGFOV80JBnSHrHIHVu4iZqiO1PJgNBHpMbCZtvfO12gKWIR36zAMBpM54nEnnp8NqsMnYgVnmihqdebpj77JK2Jopc4ApqFhVlRm6winau4Gfr1sZd2dKI2X631eMLDiL
qd662Xg1TXrP5Az0DF6FhjuBf0PBynbCqf0ZvSIzYBk/g07HBIm60A54yK75HRnc1iBQFkYqm4xCVzkzY42AXnZKSFxVMp6fWA98hmYlXwLPanmXO96F/vWYmRpwyjzFDjQ2KcssOLVtnAqezwVrqDNfvdyFnnE2
wc9Rgrtcxc+Gz0QCz9SMq+AeLZyaZH1sPYE4DhBxRHuT9EbBVDmR65TSupFrwevYlRRaRqlwOFvIQsOQbzBKPTYsUstHTDNEwkM+m41XPeQH+K+YELY1YePY1ortJqcct5U7spPR2NakJ0LhvlIb6DnG52bhsATp
/taTu2eIkfjjBDOu+ZdVhF1Qu4FxwLvgKc8yZ5ADXfbA05PFnyLvX0WMMr+XMGMVnls7ZS+UrYfdQmQaNBFWlODYQ8qxolsazK/CUDiseXJKnHRbS52F2vLJqceX9/c8YiS9PWZkpNybrYyn+t+KbgxSNXGrwvjO
y0v+e7f5sgax06xXv2HLN2O7H6Tv/k16qxITI0DrGaz4/e270/tL9G6xMvJ8AspHa9VDwRh0WKArN3Tcnujfzshi3WxkrZmRQWjkqgJ0dar0nfVxdJvRan4DeiZDqovaECMLOirJHgElJ0CFYPskCmXtDEvvCpS8
0BPLaNivlUtdM9aDRX8CtFi65W8afS/Git4OjJChw1D+jeREH4NOw2LfB/2EmXZFU+0MFI4sBDs9d6wVUdGyMRo6jOdzJmO0LQBJEX8k7jozsX29WM8KqdypjUQZVdnZ8wD0YwtymqZMcZnn6Y5jIRnc40WrSsQL
0NAdFMpatA70+WvMNUz9U0lrCkunUhfQrKGjDWOdB7BslDExGOJKTeWAtX+BP9L7rIyLE3xKilWDWMWlFsH7rE8ro1/kBID35myhcstJw/CZiKNk7+OJvrBwTAGrVmq/9JIIUr/nYHksU0diUPASIFgm9qB6CTSl
PfXtZjCnA5qlFRwqPpuTqB7YPYEWtPDmWU99VCd2NbW7y1VHHSYasJyFxsn0CJLnS/TmKtppatgNEto5nejW1A/Jf+su4CJZE3JKhzXRwABKdOWRG09UmJ2YYRxAU0UxopwB/6q6XBeiAPrFn/Rvit6o1n0SzZj+
fIALWGkOoCtvNhvoziozGmVDWBADXPadKnLYOF8F8ddjsmxiG8wSvx0BJrUgogoYaTDdHqsjt8E69qIX18jxY8Zw00SPov8qV+w0WfwJeeCy9Q4Io0CzZERNX/GQC72pFBQEQHEYJB+L3iyYw+GRGryWfVwcRHkl
PouhWEtMUdzBT+F2Tt4hRtbfeoEZl7ezjk3m0dDQVVp5iq8r0mLyYskMuV+catFtLfFCPLnYW0XWKYbPGn2EBARfeAx8W5wKABE0xxWwCPKDNXJNVBr8kuLyB55MqZA75DK+R+tz3yRfyIVrJYGLAX2A6poh3kRP
zPLslHuIBl2GYluttcxH0XhaomX0+3b2xdx0vMviLm35pAS5pKW/U/g5DobMxDQDxDVXzNRdJSvtMz01HvZN2gYVkTUzdDA5o9+sUCrRQqhjMRDknuOXKRcnUzlQqha7oVHWtwdfE0WZyv4W4xlFq7MEQMkJAtqk
yatMpyFrqHFUsWjRMtH0Q2FtKA/efpJXg/Iec57kVKnpDX0MhuYkpqUXPBJ3Fu/b5el1K6MXekP2FUoF9CElSjPKAY7fMBFbXuFBzCV/1u+U969ixquIMRx2yt4grAXPyPrBrq0LTzQkZ1BhPFIMJuMPB15kzfkK
iSQoOzfwQ4P8I/4Puu9n6Gv7e4uV8TpivEn/EzyHtctd5FKdxN+pn97p3end6f0keq8gRtY7GetkybeIjXU0IClmLoZW1qGfR2uhCUDzHamWpBo2MmtaBXqs2IMjtDVgLgP0Fop2Zjw+1Ip7oc6UsGHGnPLBmgP5
76ADAIxBD541MEuR6LYLV65aQ5ZJgDeLIuNhjanUYZoXnTxAA2+xjl6BAKHRAydS29XAitVmni2zOit0OdYzFWtDwx6c58rYBv0eCAwKEV5xo3g3M/Fy5yklpLHhNo29wB+0wqN3XpU9okCjM9j6WI21sybl40MC
uobOiF2DYdb08Y2EtE+YsQEx2kIrSRHzLdQ+6lAMA4eWzyAD7IqCPcOUeHZjr2PGt+xx3+KP9AbEeEJP8AXGCYokNdJlDdGnXoV+59178FJbJw96R2/7xrK0NQuU0QFv9Kb1B/IlTxgC2AiafsQ9AY/D7AMwxeY9
gFWtKU7PfF/M6RQA2i5hRiBGYoZTxMgMXFT7DNDgpBIjrvi0L2i5K8o5hWXW8QR9cvL4HHo6odaGs4rYUNPoGD+XcqJuT522sAoWU/SZMRTrKVGLBwodrIUVobezIDHWpsUqymKFogU7gNvA48Syk2ctPc6jR6XY
WGplrSrGn+ewjdNqR9g8hLHQRbe16H+yY1ITp35eWcdJsFMgYu0taUfMCLDO8+zELOVWTntqZvlcrEfw9KBVbrAZxJUspbUsket7wB3p1F6w5v3gr7yPaTp4iLsX79sjp7ydn69bGddpBJhEMxdwoN1UpOCp/+mB
V92OV8VavFsNOy8L+va7gKcxf93i58B8BWKtK+Rh+pBN0/CdblMQn4SENQbJVfD7AC+D0mASOZE+LxGjZf52ep5Flnw+4ErPzAHQwDW4ajqzYRM5X9nuAcLLFvd4uWc4Res3nkZ+Zl+yrCh6mgSxRfJkh4itMSu+
nIN1BjhVh5U2gxdOZU5dydkOHDAXl02pZ401Q17Nk1LZQnr6I0euXaGWjOViaizrHb1Zl8PmsUiPTsF2El/RreOp0CQXdjtPvBtP/V2ev3/KX3bjl3fHMp5DjBv/OcGmtLMqVmgfHJVMobPOtmq0FbsLfRnYmnoZ
s36j/+lNiBH8fA0z1sLMKGvvlGSYmGsVWHVbzIr0Rpiedl+eCzipF73OboT/3GQuBRcLK5a/J7rx7f19DTFKfboPWxlXFCC9UiFP5xYT+Df00zu9O707vZ9F7xYr4+EbsY8BwBbmwL6r59AR+AWSGjIPegXkFZTp
3qA8d5UKdl8NvbRvNowWlYY2iPdZW9OUujyv9lZGaAsV9CItdlPqLxQnyBHqsngLhZn/Y++6stvYkei/z9FekMNyEPe/hLm3gGaQSIkKtuU3Ys/wWWSzGqFQqItKslsO57AniPWvJejv0GRqYwVPOTFWldqutmmy
RA20IUaDd5shn4OepQJ0dGYbgxovGKRNhX9raObH+XVYmRP4LCp8KlJH4fldVintjIV++UtB3yneU3sZk759nZ5PwNYdHctmIV7oY8YyXxiGj+f/CnraaitPrjtU4FJGL5gP2mHpF9iGZF/0tHZOIlVPG0zM2175
IGL8pv5IJ8T49OsVzBi2Vr3wHjUqwRVAYco6jIBExENrbWf96KJ94fwkelIaYm7lDivjslcq8etl8m4NDBJt2F5+dlsvqJ964MZiiSsj5qBAD5+YaUsLV4z4d6FxvENfzvTac88QY2zMPmdaEgu65Jc63ZWZvwwN
asCMytETedLPUqzVXWwwaerCfHFo7fTNOdqAMm2HkqvTJLX8/2jlRGsqoKcGn1Xo3qOZoTEAUXib3oZU8qv4trL0EjSqpKEp25I0LaydWUL83Pn/OHI1Fd1kPDx4lOMBUFTp21Wd33rzwFILsw86PAKITLc9sw0Q
ksYqxfg5ep9Tzw1cdQxsH8wFaeSTbqVi+ZAxFPtJwZgA28bcFdchHriRFUu6Rr/9d2vBKksp6WVt+HgM1yf4+SZivKC3TjdMVRr4h0CfPhD0y78RpX3mVJ150gZp7Ohn6ITe4T0tdjpJ1hCz9uGwrYpcBNKq1KmT
B1SvDdi+ZQ/O4pxDS44zSHFvyOfYs0i+Ju1bmDEJZnS1gHeANTEfYhM+3cMYAma86PSJBJjHLwYtpVJfjVn+BDPS0JaYVRG9tlIny5EPhNKI63QjM8leaoFFoLWB0twqpGpD34n/AvPXjdzqoIUViwL91RnrHmT1
8guleyvwcQ88dRM+6kyttuyLeVmPZwI7s1g28cfBqw3jZ7ByVaK/f51+86qlw3f3KQT3tsfib5Snr1sZF2KsiXNNm1oTee+WdMTM8TAnsD5dNyLb2g0++3vy/i16j1sZc7GFPhNgsm1/A6YSXwuNNUBuj9ggx/Tg
cPohuO2PMXIS3qnLymjM7fH5Hf39vJXxIf3vQ36pf0Q/ve/F6nZW1LSiniTLRd/vnhFv4h/7PBfOV7fvh94PvR9676H3MGKUeF2e8KlGnzCdHO1mcRpH/yujgSWNr6PUzKKbUF4kF4DhfpcM7XpeExlAXo9YY87i
XzIOzCg7YeaJMnZC8fMTdNQFHXmJQKPlZATaCXODhsMcUHK2SPtNpf8QdFcrtsgyqaEXehVWAyXHMAIGn2BDpY1KYXdhpVvxUCrDQU8DkhxQZaB9h+rphSrxxDy3K+hdXNFn3UxWwmXtLCjaw8aJLjXGrxBLRnfy
Ti3qyITvVk8qUM7TL7R80v7TXQ3Qa2a1UzEiGlqUdsx1w+fY5uiryLKl07Oa7GhSFRhagwn7PF4QI/3DPm9lPL//QX+k162MS4eWYsLoqaZNOifH/GEJapKDBhs1a/uxciwjh3K/zHVzWL7EFiDa7GRI1lUko9v+
awzNbcBqpQaJMN3WiFEyFGCMO0tLe4mwarVgKoDIUuRhACNiwV8TuMdD8wUKG9zf5oqZnbM5YtBYZ24zWHqEjia85WbFnFpWZxJ/1o7prKL1Z4yHxKnxzKGD7cAvTSLEbMKqgK679HdbDT1Ra5KYTWCu6qDSJ3my
ZywmlHhf9NaeJ1YRxqnqvvwx5ZRleOCEmlumnr+sTaoQO1eJRnTNQ//kCYmF/lYwGoZKV1fMYIZVTNyjxB/O1uDyoMvuEKzbT36XqwpE2RlvBA2yglfyosOLdiztA0xmloJUibeASLzhaAH3oC+hDLH+0LfQMrAu
B23FGhQnvRZx18rEnaZ4dvo/ys+vWxmXH2lMVRWgkiYyamX7sQenUv5ty9ji1XEzlnGhhZQKpBZGqmmZg7btmD47vcKwuT4wTlgZuSTrpxwFEF0Qp4dKYVqqZvYBYPreNkZXhfZDQHRw8nAW4015AtzB/HrgFObE
5y5ATIaFuK3S5EkgFVaXxjylQssw5VTELuI2Pgy9Fbmn0mND8MzwdTa9IwB9C56nG0zVLqtyr1Pb7DiwUCYGYGB5NQfqBGwg/3faV3niVll7mnn3bGCIn0+CK/toBzbwKwq+eOsHo1+xZqI2ecvnJaulGsJf9ed/
yy9V/KlHpP/2dCzpQo8HO9cOirE03KvpBSPclB5BjN8mfuEOYnz6dYUZA63DQ+UiUbT0yPAJzDt4qLT2wE7PCRsHDxgCo9w7o1F91ZOykvpGTCmE6yw4v7u/DyDGvBDjZT7Vd1sZb/il/kX91L14X/lM4saIzGjB
eCZqU7q6kmvILZnS0pC6Bia6SvWutVxrKXdxo9u5U8vGl62vugzt6hdB7lvftf3fIrlnzhlWriite55+bUrEtMvP95xd8xW/331n3DGgp3bfGL+XdwWJFm3ynNWOvHN2nrOaxnUiIPTcBSV/RUny1G4adWd7zZJv
NtzG4Ffty0Jv/TKfRjScnibVSC5GtF38tcf1P4KPfug9vzZifPr1gJVRsjDV0gAQe0/W8PBOG+oo0c+RakvQThMgIddvLLTs4J3IsRjJcmYY0egN1MLqAr1FxBtNEKOdXvIVdEfPoSTaLvZ5YDNgiu3fxKwC1Atr
Chocm6DK4pOu9dZCc1z7zdD+lF9PcjAmpY8z5JUXlf6iRgfR3ezW3CCzFNZpwn+AFcPh+7p3X8bNjF4ky15J7FvHM+khFVtmPdKiWL9F9opODAAQURIjvYI3gvSGeM9C5cHIZdpPdDu19ZwpMC28hPZFXeQuekoV
1U/o04qN7Z1+qd/KH+kGYtz+a4eGFMWXaHthNejEGIgKqAZFgL5txGV9pjwUsNnoZ29DJ/6YTeZj1Lj8+fCLqaKMtdljbcVPiWYzns0yC/+R/0SJHVN7YLrG0065k/lzsDraysrBfAqMfZSqW2sOxBZDzZMLI/ad
hdKAI5mJlHwZyFmYyz2j6G/VR67K5dkm2jh4K+oBnJUZoDYJAF0iTF2YmvTU5vwiPLqec/jD8TC9CuZOp0wgUwUZ13J8gns4GlXWjUTTgV/tqX14vtDDsNOrdOEYNASgJR15YsLOSFktsXtininJmEnP7DiC+Bxi
h2pE8xqjvtbb88zG8mysqyIZDTmPTlb3wflQDJPTfeMvFRfKsdVzfWQozvi1l1wj/PV7c55+jp/fyH6z52OdAvHcoTFjEf1sJUOnZO/FBFcD/q1gsdP8DsmCObU7cSp7TX0I6wFzwPjosE9FxBZe6e7P/Z0asxGM
Dp7jWUNjNGuSuO0iMcBK5KzkD336Faqt4qO5V478e3Fskjlom1djbPqci/IsVWWehsY9wHbAM7m4zvT8RxbXLL765KouXD3lOWHzALkwCb/Ufs6FauUTwYPrLnCvExlvTrza5NnkjqN93AHM8iVnIe/OomvtNEoS
rwx+YSAyvf09T57kd0ThTjAmxoTRoYE5k3+//LshEbc/9T3MePC25GFjhoBembh4ewU3SCzu4thgDjn2reT9W/QesTIy6oSZh+K0kPq6bdkEDYRnXoyHJUa0MbtjLVXMbN/7eRI58izH1Z/o74EYn369jRnfgxhf
6H8nz9SP+aV+kT4pmJB1GBl/BLUlpBpUHonJDy0rz1dffMVuDiUKG0SYVaWGm9D0CPGWc0wNylEEeMRGkhtTZhCdBcnvc/mkhfGInyAjsHViH8Gmp9KgAtVDC1UL2mJgSe+KKQlAnPUkVZb8SEyl211zJ0xISiOH
knlPZDX7AEriD8c8BFibViLq0Y7mtz58a/w0sVXxpdXWHPqbd+agtHEd65Jc3mPlnip1CnnAFvFs6C85SH8gkLKOkFYAY9BtGgtQmKKLJi2Jc8LuXoIAZUf0Lc8BCIf+04SCYmQU+1ttySUxOpwRz7umxvOLhFj/
0baKdqhkM+tRYh9qlV5R5KxSanr61TxjYTCWNrnkpU4ntJYoUSYtQRF6M+fpb+C/H3p/gt57/FLXBf4bZihsvEGy4BiojiZaRlLhF1jpkM5DUCLLZErlNUPtlBqujU7PaVM0Ek0lGo74X9Gns55zjqau8bfkuQDZ
2K/rLV1Gq73MrRqu/H1uZZq//Yl/9n76dvuHXWSI37GMouFKlBbkQlaSDdHN5WMIqSUWgaCKxJowD6ST3Jr0Xxv9ugpEfLU1pxgaoZTEe8yMhN3STDeH5J9kxlTq7B+2Mp7ff7s/0utWxuU1miVjEUeTnsUMnGWl
qFP+RChLEs/SopcctT0y5qoNiUAV32GTr+b6GEVGtsS40GifrB2B9WEPLFn4zYD+GIhmWuj7NGLpLa416HKWcOzwYhONHhgyYuxTdn7Ygvldt5h2g2uu+fZy3peNdKGjKOio0q6XVn7M+5QuV8bLKns3Ptn8/PKu
M9Wdc0osO5YpreQEP/cjhostFi2d8YfQhzj62Akli/GkByKrHBWdjoypt6rfpTvt81fr7dzHJicJo0F49JCI0g6b3RtY8bfw8wN1GXfWkkCz2lQ1O2YfAqBbnDoZdRpXf901l17yqpN4a4c5IK86d3CqoNHBxLqF
1Yxj288v238Xug4aFaGFlWOcxCKlwdvQMwhJBpYIk9wka0N/hVP3+D3n1SX/VlRkEe9Vetj7fmFJvc2pF/62t7gwPPDJFaeK/59ly6afg3mto3fpGa9OyeAUtFjqm3CqzETiEECDtRtj/gn5dwMzPlBjY5+cSL7m
LJ4BVnZKCKkysl2ZAb6lvH/9/XXEmBe/QKxbRyuxY5xi9LYdea3pfTFKoy+yh6ZR39jP/3B/H7cynl+sr/FOK+PyS428Xvql/kF9klasmCvRjQciShLMAUWlAT1GB30O2ILLsDDcOOpGt3joL6z2mLC7MlF3C8Uw
HVUBwuuqaeazeG5lxF7DQJ6KzV9C9a2GeAphAqSYwPhu5TKWNajU6kN2tYXgjI0YHpC1yeOuTNDmxqQXhlOxFUUVGDT5ojvMDC6n0DzxGwgPZTlbivczj5ngp8u+C4Js1D4qBHVPJs/QHPZBVo5gNcvqgKVihX4A
rDf6xF0jOdzVHevYZagdKUCTDiEoDz0xSqSBC24CULqkg+bIBm2iyVLrHoATogv7r81eJ0aMVecK1I7uDR7vdUxgfcOhj4SfBIBkqFXHcPHIod3TL5guQ531Pm1wFsKFbDvw74SNrPliIHOYi8BndDEoJk5QUioF
2hsUXEBybMuFiLqUyzn7p/HRD73n1wvEePhHrK9vYEYjeUdiCZHYj/lAVLbQ/SdYEJId7/rynf6iqeEvvit5N3yXTIwn7XRZc67e72RE+Tb+NMe+tlo/jnZLvldp/66YJjFKCbtCZ3qIpfH5/nCsydOvyz2QDpPa
Sv5HKnvEN7pkL35jOj5C9RuM36uI8dRfpuiFfC7FMzcns8tkJsU9aQFL25jPuObQOe7lw1t6uEryBMhPd3X2fOSyV6dWXn2+86lef3NuR114tGrJvz/tnYz3r47fUU2B2oYryVEDH1Y/QukL5zfsUVr+kx27mpVx
0rc0Phk/sYZdzcSdM/0Pt+9iDi51wL/Ez48gxjM/pxNXveTVezO7Ppdcz6xpEZYl3J7ad/DqOQPRLR6+/PzMqWWdCJTigvjrRRce57Cr56zcs7YYW5jNyTbp7xecWz08H8c4LcwFjUrQlr05Z3bL55e8+uEso1+0
3k6Ikfle72DGoxf+Yr11pe7e+TfXx3vo3cOML/nc7bozlxmkVg66U4Xn79Xfl4jx0K++qsbG1v/ekTH1vfok0/C1o7qhFm/Se58sK2NvARjNVZ8N88tXk7HKas4xjOqyx0YO8AYVhikftGQ1zjVm5uQfgGjc/ExL
2PYDo4DadZX4uNpXDcZGm6miK8xaDmJm2EGrYRkAXdYHVQFNPavwBPHvDI059AcQT8u6lmiYAK5IvZ0GFVdNyxDruu10ra8a4qZVNN2z4pqtKpkKxGjKqmF5CzEyv3fu1WkfUoKOHNxoNKlSo4YMz8UPgzFCWz3u
SakWdN2rGAqQVnSW3uYsRq/Fj7TQnx8IkHq6bwM4twEzZmusA3ZLdTTGdUxnfUnA2zxGD0yE5kOwylp8rVm9DU/LQJUuxQx8DmSdBTPGPbJrbAMem51nS5J30zLDME+jVMsD6FyDKztHOshvWRzKMtHC0y8WXR8F
A2v6HFo41n+8xss3w0c/9F7Se7+VkVym1ooCP8+Wwc0T6wLrqtX9ztV+612qiQLqZKn69gIT/lP+NI/pAvG0y1/mbHw/vZeUrjP4xW/R38foPZIx9ejviva6k9vyg+3z2/7wIqblk/625xaf64F/EaW/ws/h3jh9
2/X2p+htxEj/57cw4yfb9+45eKi/1zljH0Z4N9v3IUpfPB9bFp7y5X43fnl7Pt62Mv5L6+M99F5HjH+/fZ+i97nsN0+/3pUxVYqhv+aX+k59UihlwwtAC1eJvLLmxb/pn1gCr/1Z4KeZ2cdHmk2XBuRG39NQVQaC
qg3y0hSVVKMvaaB9innYfE2k655+JTy3MA24E83SXkTQHfoqsFkajaHXQ0UD9AWUuiL5sljdGrCYA14DwadfbpbQbE/amewAYY3RLATE4OhE71fooXYaBcmti6FrhkJnC+bE6Wo0K/cYFqp13eBpwL+scNZDWS27
iRnPiLGqWLyOhm4gVms0wxVrjKK+XJIzYr80gLgFSM8X16IC9wOb0R3Wo62dAU1Ka1eYtgmArRgMZbfesuZ9Ef/shRgrnVHFX4VpqYE+Q7J240pm7uddnikDAZ2Hqy8RYxvSbgfsWTNT2dEOyvO/VJm9zWBMlK+d
wfCr7mNfVW2CeAI6gG+NEWDhoeXj+yX89xE880Pvd9N7BTE+/bqLGdflmLEaHPLYu5X8k6YzBMPWkum1fdOO+Oj7N80H+kPvrfcHa2z8Z/r7Q++/R+9hK+N/pL8/9H4nvZuI8Ru173fSOyFG1jd9CzP+a/19DTE+
/foKK6Nc4osK/HHHM/XD+uTydy28NtUoV96ZVPyOzbv+hL7hFVBLN2OSVy4F2rcyz3NyqjFC+cv0qlR1BCXwIgWTlRuhJOA4XpvuLX0VyAzYVOq/2a6Sod+nLWFjRskb45Q3yVWTlLceaJamClutklQEzF+IAS82
++KBPDFTWpso9v1eh0TM4uVtNkxf56MjDmrDcY5AikiQGdraXPF6x0hfIkZLxPj0q7TEML/hFfCzTdFVBwTeMeHBGu9ySNkB6UUPPF1LB0y1yYaZmWRhxImWuAI0qIHEMuOZggOuzE5py6yNTIgtDq4RzWiJSNu4
FioQY4RA0daK92rbiNEKGmwBuHUhxo0X7mHGRsyI3yempL5CjH7VNztlFcpuRkd7LQB8ME5y5xwI4U/jmR96v5/ePczYeA3Nq6u3L9B74C5WsAO/6eqIE1hld2Wre/ku/io3v/nY+w+9b0PPrnrvEIvNxOFr5ski
c6F/k/b90Puh9zYPS5WWEv1geR3XxN8xfJv2/dD7t+gt3mEAtx6mdEYESZWl79K+30nPEE4BM3rosfLvb9a+T9EbifZvE7T9iJXxjBjf0P/e7Zf6kD55SdWdPBjfpkefMp9i9U07E3JMOVcok5n4I0eVGvO3MD9L
NNlWh1tH8cCNOpVsmBNX8pXexr0XmPF1xAgsVrxiy4c1wG+Odc2yCgoAEf91RUXjErCfxXKzDAvEyCeXcAf+j6YD2EkU4sj0aU0CQLX1Dg+2afkXs41l5eFJV5ixAullF7wPCpjRYWkz+31sBc9LqlkTnLeWhbwM
EKNnPVw8q4eRS81AptkUNRVgWrJeWfx2mOZp3GzWBj1tMcFqFvtWgJv0IpXM7620EHFPCMCDtDL22QOwOdHgcLTlEjMuK2O+yBa73umXaqLOM1XPSLOKFdlKYDZ49pfWT8Zqsgo068CtnKxDxgjoug/lnJH89W1W
Lfe8Uh3ln8FHP/SeX3cQo5PXOm8ZA/z8da9Frw1W6g69sl5zH597Z/7xz9L4J+hNvjM/HL3UmT9jmG/VvkfpBVaoHIw/YD1O8oB/jRO+7Xz80HvsffEt4JXMeH7OtX+9fR+hF3qTGhasnFOxc65Pvk/7fuj9S/QW
N5XhhKfSuOKmb9C+30ePYVFlMhuZXf/+Zu37FD2oT3VCt8dV7iNG6OOfszI+80uVeLrP65HLL1Vn/fQr621NfOR3jdk8YwLoKCkzfyr+HwHXMqtB5VTQ30b8pFuLAJRQP2ucwIzNt9i88TloySB6qw/LL7WJX6oD
thpALIwPMBszZskiE10BRR21i2KIa4OZB6eMaMTA4118K5XQdOKl6fGNZSze9gee+I0X5MPaGngq/uYdBveYdV9/aWVkRtUKeNdZB0BQpSrAb8zVBg3Hkyd6tjkB7q1X8TFbscsyQpBZaaSFlveKDJD6YJJ9dIhb
Kb5hvPNwY7WIfWLFKcksy14JGuROe/xOMCH6OmRMj14/xws0xWLoMUfKFqcsKx/7ZDArwKrRea2njCULAI8agwYHM2sq6+lN3FOBwAezE0t+W7tH9vNcaP9TeOvfp1dZj+BBK6PEOYuXqX/tXfxPX79rVZlR4rP6
5jvP6x699z9MT/O9sT5OKpruCi3WVqbka07foH0Pv7cpcbCU2TxzY31J1gxRUn3yb7XvqBtFmchPwvcdv79Kzz0bp/gGPb3oYX4jq8Ez9zedaLgvdXqwfPf+3uNh9t5Cq1CQjqy6OPYnf6J9xxyMB+fgG47fH6B3
nP0P5m/6yDj9yf5CJpJ7qDd28tSwH5eI33Q+7tJrjLXSQ0DW+vf3at9n3ok6sL8liUyLn7EyvqH/vZox9cP65KVfapDrMXq822dHN6IAeFSyFCJTyZbYQmolQXNpVVXnQ6hJu+IboNDENdzENXYlwVvtEwSE/UP3
klOyWRFZNn3SKX0PORfQbrrMPHcdyN+lP7+kZ6QFDn0s2UUdBcPuqhxBcnk42f1sbJHFn201uV628q/iBVZWTFmXAjBfQgszlcjyJ4a5Xg//59qaVEZKJk0WBghN7mq4K9Zn1Si/uH0/9P4+vUey38jVgFFaBL+4
qmi0rqWmd79X/J/m8VDXGgnP2rd2en9xue5OXhbu6q57/X151xmrHterNF7QO1O8d9/r9xy98IKnL3t0/rV74xOp4ip5tIaZNoRRbQpey3kiT9peUr1sj++XeP0z/PLO6yY9I5ecYW4OW6cR76fnziN7g1+u5+bm
jIv/Cz4vzMs2WUOTKduAAHQ/Zs6ffv9yTl98vuf3JQ++Nb+XnO/2Uz3r571y1+3ZvLdK5Jk35+NyfdzjI8lbVaaMksMoSdx9nft8KL6xZtNQvei2NtIQrMXM671HXrVX6L22Tu/x83mOb83H3fG4MTevXqfxE45l
znE5veX1Og/f4dSb83tPOskcVPZ+JOVVNOTUWveIXM7vbV59TcrcefIzfr6895pXX7/nmKeX/GxvPfUGvaMnzyT5TX5e4yRRVWBMFZ3wanmDU6/n914LbvX0dh+u6b1+Ld6Reti0DkCe3+GmE73LkXh4N/tw+34n
PTmPHvLqR+zKS3qvSdJbs3Kx517O8p/u78J9CwM+ghiXv+O7rYx3/VI/1d8bfqkP+rPizmZba8OXPKsOnmlkWKGR8XZAi5H2uAas8fSLiMNZZ5x22SV3HTl57wnLcraqGa4nXvc372rz8bMxnR8cvyLPZ6hh3+29
pifIUc4aa38lW8xva99b9Fb716tKO10/1zlZo99k9O/d83vb90Pv79G7QoxH/ucXmHHJjkzUCFGQbVD60olVWVwsGhqv3g96Hne4S3lZLctZX0mFtcYp79LaOCFvyIamsTzzOt+4xm/2tCesaqzh2Tf878KltM9Z
oTk3VfK1lvjfI7fYPe3g5b9v7Vj731d4df2XngCRtWQxfvKSzLFDqseWLYeJn046X1+5guSTk7520rka4z2GLc7EWIhwVlVYVsHT0q+0ZeghRfmcJL2ejfWP+s5Z/RA++038dxcxPkRvjWwWjhHbgfBL2zPr2irn
TSns9viZ0zyd/3W6oJ3hfucSOA672rArP1MTzjnGcNe9PeF9dzUvZ53l/JRzpdxrrfxqxje/JOF9sbxuHjHCI4vu4RsT9/rIxz3oaT9WxrrzNH7hdCZ8rI1jdYSLfjlZHzzlH+QeGT9mSx87z8Gaj936QV8h70bG
Sio1FIxToa/PsoasX+85CJsX83FOvDyVspfzSRZPt14N/KbqvvJxL+7mbPpNqe91GuTE3oumf/AzR2l2JfzcxO5uu77S/t3VfFzjofMcvFjX7+DnRxCjO+kvWao3u82rxzjZE6+mF229xalKzu89tLDSWAjWWp6w
D4kcesGrF5x6LSkvRubpnJ//GlHeG6d4mpG4+6A4Dxd49eDV7SUldw3Jld83D9t+gSBf51TQO87et4QXage3TaGaT9kWjtmfHKVgMjgzBz/MpJcW7cCgp2UnOM/BkpuSz/6q5+Y0A9ecYy8+d0+3ziM+gt42YgS9
1zDjPn3hLIg1ziy5t6OS3Muz/W+ob9yi9ypmvBrPy1GO/fAMyfvTY7+Uqugv9ty+99w/2t9rxHipX31FjY2L9j2YMfWd/T15pr7LL/X4rcxHU602RuiVZktuusV+1LbHJfJztsJrr/4L++LXz8cPvR96P/Q+Se8R
K+NCjFCpW7HeWns6D5P0ylKeVSf14uU0LzV5hcxrI8ZAzLgRI7XJQN9o1nM1kJ92GovNchpHXw6r9dCxqRKjcy5q/He6ZC1PNtAe3aiVlDqa6szwVJ2GojKYm4rxvyk07P2rMaYwtNdY0nWF9Fuu9aYsXL4PxHXD
RKY1ri7lp1+e99Y+b9yVWTQNd8XTPZLOOKVqWlRFOxbWBq1oDUaqQn8pT79yYP1oKFRA15bViGtKhd4shfnVTp9Y+STzE+yEM2sz3UgBY6SheBuTTLX4D+ajVJ9TmPSEGLTjQKM0IZhSjWb2Zo/O64Fer6zR4fUT
uN/Ifx+zMi69gFpnBl5mfRelq7Zm78jGCr8EfIY5aCZD72PUuKJXfsjTM79E7oyqu5g/8E1moUsLfvasEqWzaBy9ZGqaK/7E15KKS33QZ6zQ1rt29lxY3UkLYpilYJ44u8oSzzFfeLDahQSWjto53AMkyhq3Q8v8
DqAmFVsm6pKc2lBzPSZSYX6VFKhmQgzdQLIMqfdUjWGIAzjY4kq6aF/Ic4r+JGg77u5FgQexAorNrJe3Kiv1OmTt6YgWjEitmvE4Gryh68AD0AlwZzL4qdFYGWDo0LcOynHCJ+QnZ20J6AnU1ORb0tVwQDRXCeZD
2uVMcsoMBe2g1BzlrJUYHKg4+QpEL6dHoxZwapCTylpZOYvp55yfGAFJK874HuPxaG0wF6zILAi12YaljUUGVUO5ZIZmtWaXpps5NWemCioOrGxoJxO9VtqyuGUclvFCzDleuwNS9YPDG1xoLQHBdkbSvojweOXS
rHf8JmZkz2NyZWKo0FJrpXdmSzaD2zGImI/JxOeMT1HV1WyTsaw+h4kZ6cSrVs6LwL8uOx9mm+DJ1Fk3uhX6GYjXm0HfoiR1J74Ef7FFccnzbD3kwB4B31nVTGuWRI8lMQ190DkDvCeLZ+Aeve9ROnnXKvPhQWzy
HGMaOjhgrjHvmgk+LdgcvIWxLD7Q59hyNl0LzFhv0OcoKf9cZPXHlXehLfxrbODTu7GsQjrYF3pmrr6AcbHd0AOaYjjSm0tyFjZWqTZeMSGjxQCEIDJc8KBgV0klT+eYQWepihmINoc6VdTgU/w6oF2ci2TB1oq1
4kpaqzhBOI7h1v7GwsKSiYYv7GD4h5UsJmZ4rJAs/h3oIdBpDBYgj5xg2hF38R55+oiVkeg4ScVurGMNfGmy7GcYQ1s1zw1Ulbp4H7Os/DX95R5iXPsra/11kymfAzay5NwQaSd+vFzFdoKveEatINlLVanWgK/z
xZ4L3lREkTEvO/P4c/19r5XxjBgZT/e+jKlZrnv2uQ/091W/1AfpiXfU8lTdWPHlPYe/gH9xrvXl8/FD74feD71P0buDGJm/mNdLzEhl0rjkcYXoeIlIWUdRW2AtGjPyUoUX9GdJngx90UMDD9VUJfVVc6VOWdTU
zTPHVXMrPlkPqL0D23VL1JrLyN6rmOm+7r3TjA+gNyaQWsqGYbo2Se6mBD0BeCJN5kZOmYjRA0WYMS3rOdChFiBPJ+k0805BE8ulyfnkea9daIKayLDZ1qhYd5bOoGOCDjXxZd3J+x7oHlED3k2/bPTQT7F7Q8dW
XTvvmHXLT6i1AANeAYtYqGrQfypxkzNRZWeAD6HWF+jYA61Syc79CbNSsR5QVtnSMx/Kl63OxtGgBwXstaQKGOo6gDjUQEZ2Y3zLxL4agCqdyzM1Kj+M/h4LK/5V/nsAMd6kJ/HZqdUMSMYqR7GpzFK5eazMEWkA
MVPlhIbL01ZPDSz5jF8AXxqo2EHm+DjDJLb2GFzoWkkBr9FeM6i98xzDKRpnrSdWTy3MQP5SDUpbqQ3tg7ZmJEAc+z1Rw/AYccA5IDntClZLSsAp3tITk5nbBDF2uUfjHsOsZS2mCrY0mfWZWgDKw1wqqETQukfV
E2pRAl7iXTN4mlU9dMRpJ5RZLBW0yDpgPej44GFXE/Gwm2ALQ36BelsnNKViHBSoTkAHLIYPhq+CLnvBSmwJ6n2ueWW6Cnw2qw1HI2NRVzQ9+AVrr3TgEaZwk7Ng8DFGlum9wWsYbizRaQZL/c6aBxazBl6TLN8Y
2IHR1iWEDKVPRwV9iOn0jF+jUpm1oLRaEyH9zGiGnmmim1g9DUr7DJxSNbKuhDKEKRH4HDNPi1JhPDb6QiRbKWXwCcRJZ0Qq4zIwMjUWnpQnsVTRqpmTTq2AF2spptvn5ydv8vPrVkZmm3fFNqAzaveO/vwWvOLE
DBCFV1m7GeOD0ctpSLVpTCh7UVNRSdp+ZaV1KdIqGyokmxL/CNOU2MizD8zpZ5WBBh2br14yb7SQXQMLEa2yQrOvmqNtiTY7pKcFH/rRCjAr5sOBFVilDCwVBTOywnYcgEgmBwU0iCUBCcyfQqLaiMkpnDno7Z1H
UW7KPdrrOCrah4WZjJuixwMHQp5bY5oDIgAL1Maxi+jJhJgOWMsOnIrV68EBHU2wwHbAn9VhssE7HfMr8UuYbwDixasJEzjBIBgEngUAmQuCzmASSPVgfHb0sAA3YgOKFMvVlwieqcxvgfbXkQkaBwClAl+temuN
1mBsXIClkB8tYp/iiWIC7sccZCA2iBhI5qbkRCVl7FH0zy4dmxPvtbvG+Xv03ReIUfDvmZ+Wpy1jfzNWVXQWe4NKzOoxpzfKlkhINFyR7Pdfgxe+Tt6/fu186/cwI3Zw9Ak7LDilhtQ8cCKzTwYNnk+Uwpp1DKYB
IuxQUFTT0fN8DUPkG/ZcMr/BSo+hscodc4i0ZVN/DI19qr/3ECPra3zeyni6Nt56T8bUh/r7joypF9fZ/+aE/57F99z2Q7/xu3vP/Mb8/EPvh95/m947rYxGYSOrMwgalJem/szTV7nEsEiXdFxrZ39pfZR4RiN5
I0qELtiDa9oa7AMd3+x4psODZOUubsw0ATToiwEwCA7CnxVcxXzYaWDClhmoN0OrKaVtxJiIGN1A+4KpjJ2qWqxUqckJpfXQrgujlIMWa8jYz1x7lZxHGppxsoossIr3qoACoI8TDAboE9D6sG+DDjCjqRVwWq0z
6QIdHapMVlawLC0pjKXJ0FmoCBMlQl/v0GZNpn3QuUEtHLgGWz86qZJT+5O8P8mOsd0Kak4hYqwRI7G0DFWJmCzuqUBQwJetpgBKXtBntIM3Zu7E/p7Pxx/kP+pDH7Ayin0ketGcYwRwAoLrVFOXv+ixt+ZlFZPc
YbLbDNESMJe0w6171i6kqBlDs5zZVcviSOKd1oiPqImr6XKacg4A+MF8YIOJ2pRNYWQXRwQyA7tNY5mnuzATEdD6JWJ0ShAj8AygrjthxrAxY+uqAQF78DX6BK0/1B0YAG4E9qyaJ+qqOSwK41XKuAcId/uv1Ub8
ARUISGwMsDcgJCOEJ6sHA1fpFAGmRubCjlZBB6ZCGSNWtudpCy309DFstFdgUJUq4G8HYOUU1jn+sCffUoDYkLi8GI4cjXyapWqTjCt9/uj1Ld68xkI/iLNaH0AxEBvVmLGyRrFMeT5rxZKneRM9x3oHph88hcGt
BZIGv6m0iKugKlBH0J7nL7SuV1rkLUaleUs7GUCAEw35LCeczGDpl1aeFZVx6ZN2+ItW+e4FWnzoukKM1E+fYcYhpxGZNZU9tFlDz8hSR7cX51JJeNafPevIz8Q8oNeHuXoe40oyIEoptujYJJKUPq30JKgmeDpM
2BS9dQ0L341Asx607FnBB0+/sCTwMs5pImYAJNps4yVm3IgxhAA24UzaE2IsgHSp1MhcFUB0zP8HHhPLOqt+sWoX0WCgvbJGD3Ba8iwB96wMe2AcKscQlTEpzL0ONTdgRhOwKqxiPLbwKuCXnQGrJyv+jd40g/UO
Oc/MC/TdAPb1HoKxgjsYCQEo2LgmKNWL4GpwJOuXJV9Y+g1PYj4ZcHkXjk0rT5FkWKE01lxCFbIb/BaB1Ig6vXBVk/vX7Jzjj3y3O7PhJYdl+SZe+La+X56+bmWUEwPMJU+yugYAYl2AaqRvk/tbdNimkveWqDnv
2IMPo4Y/rL+8amW8QowFOx5WEeglbGkQqR5SG9PavNHBaoyIg1BgLYS591yuLIgtZqC0LALAvJmuxL4yI/2B/j5gZcxvIcYH2rf8UuUY+22/1If7u/xSFa/X/FIv6C2MJ7O4vGTD5LX0y3ULNhxcNZwvqbihV75F
H3wAng7e8do+sWVL9S+Yj6+4fuj90Ps/pvcmYoT+fI0ZI73nduFWmgxVGbwktepY8qXKtdDjc7xIf9aNGVk1pjAmmpXcjVHMP+jaEcly2UrRURdiJL5zwblka+NxIfBg8Sr7WosNyQboFKEqwYzmwIwXiFHsTPSy
68AcFvovMAGtLiePUxm/l1bGIlbGQaQMRS03aDeKno7MbefRFSLVFK31Yok00HGA4rTR6K+bAxIyFNqGpvINO1YMYm2pjqfgdDx0INegFRToYbOrCaTJT2yspfET0xU9ID3rFRWoS84njf4Oq1d28tzREujjgJhx
YGIyKRV8kolGp+vQoKAuQW9/7rn0F/jvEb/UNf9F9PEdCy95srvT0G1DVtA2NdHyPtO/nQeGEXSplKaI7jNtP0f8KgvauorfgpeaIwYBpBE9MYvj7nSTJZ3aGLEOuoxG0mg5YNgLwToUXLCWRX9p2Kw6dJ4KALwt
zBjEyph8SCMHoIbC2jJ0nO5jGgPl3GJvbzNDjQmBqcd9NJP59bHeANmGxV08L2d8o08FqofKmUHEpk3qV5Vp2Ab0JLSH2JfOz0QUdEzFAi2u4UYddac/IXZuD5jAQELlTIB6BfSbC5BoYm0sMJKh5YZ2aD3qdLVJ
yV+OBn1iAZg5QMC4jvZaUU2goQO81a41hEGgy7NRfXkhApiQ1Zktx3WRIRboAHgXIEpjFtF+bQCuqSt4yBfdK+tOZQO93ZkZ2kwdagbT09MlgJYj36zYs7yZRvlMj95EnAnAI/GYFxrSH+LnV62McrqBQUmxQmBY
6ITMUNXypnfLcrB4dQIu0zQMPhMUUrZ3XmPGWcvMgrEbiI6FjCGUxF9Z3K8dK4IpTKWNLlXQiHHSHpUgDxodXCOV50bPdUUjM+DrQoxVEKMPs9ikWV8S2mobQF8N88QgAaM9/Tst1PMQR5nRumgV7mEsJpVCbTlt
GdgTuBJSmun2GA7IqjmMR8xAYgyC1aY6tt+nFJhPsSaIS294Ztg6eNUEfB2cXrkxeCNgLdcfzailk300+M9omhi7GZnuyNhLnMRHZZpp6QOHLQJ97GJPF04dEKJY6UbxXE/TrXxuL/Yh9Q0mnk87vJcsTb9f/t3h
ptuIUegtzMisIZAImjIee5NYHbnAZoxAjACMjjbn1I58SF/Xvq/u7+X1DDE+/bqPGZsDJyiA41KxabpsS3asxOcohuQcuFattPEBO64LkZLy6Rf23FGg5QQLZqZfQ5Kzm3dZGT/a37cRo/gXf9bKeOGX+vTrvRlT
X6cKef94xlT5xfI6C5ZXHLzE0UwtOPn0i1kUsZcu1bPxWr9Y36/fYY/CtTPA3kOMkuGG9U7kzHGNl2MFDZGcR/yQxNFLbY09G1KbgqsjXtglwq6xoQ5/4E1pWRKoOfAZbqzMrPdHd2mvc1XL4GnqTX55cdeprayi
ESnQdys062jsvaDv+FDWMVB9cfBLShKXPuT8UXodx2Y2qX3Ae+ZlW561T6SGnLIXef6u9iEnYsfprDwVLVSMIZAqH1GOB1h3JG578lfUeLnVvh96f5/eR2IZd+6b5WsqcVX2jAfF8icv1eS6Y2WUvA05MwNEMnS5
qtBBUlGiAY6Tf/sQvWlwvXuPvRGi1wMW0sfENCDMmcQ7airGQrkRYpihAjFWVzdihOYE7YVn1VbwB/BnrYw7g2jyNHxAu0pia7haExsxRiLGWrLxg5Haw1TKjgYIkRz1IY1lHoy3dJHEV8ZDnwq2VJdBFdoTnbIA
6qDHaGYFg8KnNGRQnckXPBMgEiNEbOEFf0Af6I5VXp1KXocARRFKFfZL1m1VQDCVgT2WulnFduoh/gDMDaGrywyp6fQ/7fhfrvSXEjtwc8pWgwaibZHOO8V9LOblS/jvAjHyPOIFZpR9qSbOfFYBencJJRVoQg3D
Gk3BzHg69dHCQs+7dcJ/8MsU/1V+wsztgCM3YhmlclGkL2ePtCFKrB1xIuUuNglFUOoEbzGesTOPNPY9DJjBpDNCBkw1YnNmJNMcFkXVdPvTO+Z00EadgsScRkdVzjhejI8q+FRH1uOlXcO2XAOeDFXWxQC9iCqS
xZ3AXdQxCu4IKRc8BQ+nR/Jk6WHcNcFJjf6s2GA8tERwBtDvBK96qPGOwWmM48SWMzFq4BVSgApubfQeC68EVxQwczbANOA9VgfG/oapmRZIEpoZdy4plgzUiGXlnTeM0W3cwSRqONKxm5FhUl2zzaUeLI9y8R6j
viHnMwbdM5mWzbxweSv0AGaNYyDeNmtLDosbYwE+nbjJ0ySGh1cl3oYlJV0A2MHPGpCYxn0gAKxxrLvmKn0IX+RS/638fAcxnugtH+pcI4Zdob1lQE6IDSuJdVCyeYpkS6Ld0LOyvIxkFPlMSh2oZ4TioFfRttfM
8hdOAXMzPECioWUw84wJCjV4Pao4A9nOQm/GfLuYJuOnWXgaooQ1xwI06OwZTZk5cGCzgQn1uvOAn0cW5EN6cOguVkfXNJAXWNEDftpsIamefllAPPAqYwxNp3ekLszK1C34B+pGwX3FGvCUTpCjdqzcUlgcLpVC
b1lmUcIYYtXoQP9s54dJgt3AiY6BmRPooFSOOVPP1KAZ6Wuw8CCbiyAH6noWiqcnjweITsd8vLEt/106pAaID0XrO9AWMWQeUfzZhVflXOPIIfX75d8teq9bGZlVEeMFdJQsFriF2MFYF6nHYSk38sgao11lf2sf
8Iz90/29vB6xMjYiRuAKE+jf7AJ2/FoS7dOJwdkuq2kYkdGrjomVHGTPTXvPzRTNPHlJ9vVzga/v71dYGR9o392MqR+Yj9tUH/FLXfUgMUu8FvZLkgpx2RFd4bUyErVlVBTaCxK6xmsjRhmCDPxxBzNKbGRljIGV
0GJ6HiTFWYfgqVPiVSif8fzqm2RrpHjC/oH7ZMShddSRo/gTNNmDMQdmQiFclCpjehp2Fj9zg3xuLutmGfGuC2WF2/kYz22S0ZFcjcVB9iZ6WjQv+ubOcBfExy1KxqrqVbCZVRmrz4JFa6R/e0JrDZ6kJYtkxu6B
HoJ36TVB3SdFZpe1EjUyJftXh57oswGl4jNEJNpoLcS6V9g/lFNaN+YDwY6OO4vB83amjWdzvdYc9ls7qe3gl5FhDRC3WnKJTNorJPcA8WA3zBsyVBFvj8yN0Eq+BGYgzPUx3PgP4KMfes+vxxEj9qNWWj7nv/no
a2e/WfIlyYqitxl29YhtgYfDjZYNaqaGyIeuVpFZHxrzZywaOfiolw3Di7USeyn2D+jA+3sftKUzHXZd6P7KMK4NWueySWgGBs2Erhg5yZfz//Op486LQn84YEZjY8AySjzhF99CqIK2VsHN0MpHrIoFaNvE/yu0
X2AHKPPQspuS2LgMRbABGTipT+JaraOuiDrczafyzhYqpaivhLpWMuJBStBzEJ9AjQYyrRJlw1wgfBq+o/8p/fX4C9Ks/Da0KZ5SAETQ7asgGOAHbKs818u10GDZbnpQ/TH+e93KKLpbkfq0Pmsjoa89Sv3fBKBF
JD8SNoPsZ9GBNjYZFUGN2JUSNMVmU6Olb/nsYrQ6+pybEpzMMzH6nULfdRjKTvfJuU/xmAOjWImTydEDS0nlXpOYAoPz7Y0pKUTNWr52xEQXQbCWalDzmU8mYPuBzG/rxEPJeSoBZxG+OC4nWRsP1C6YoDECKmF+
8H2OrHJswC9oMDTnOhPzB0A/RM9ydzLjwMq4e+UN1DuHpSe0xehpsTNgBUlbTjMu/t5RduqCT5qUG8aFEUIrSRNPz1L/htxGpz30Sk2P/mMXKOE4c6VFPnnP/D6AytMGJbF7ks9VA2N2nvcDFGTHWa1YC8CNdVyc
ilrJEuprbbLHyhhNOR8nHwdajjgSWA/YWiWLjCvcaSsIWjrq5hQ8HVwrvXt7W55mf5KfX49lXFnmiQ2b9i5HwDifDHmCqIs+tMYT7xvgXdpLiBxpMTcYqcnRkNFavKp7wSoouJcZbIrEkc7lg+l4JuUjNC1wqhN/
ZZNTTdR+tLUpTdclB5IfOWPWwauKiJtn8tS3WpI6ZlZmCDzKAlsYZI4/xnjLK+YzXHpoXD6YjdlfeUdk1GVNDZiY5uVGFpF4YOBjVpD1MouR0ZngVJ6vmbbybrHJkZzJJ4tMjnL8yNyqra1T9YB7vOS5BhJeGbWb
2LU3p4IeeaQzA5qWyPamHVixtZqGV2v1r3yqoWZwChaO0sydGaXehuFYMQN1zM46J/WJZ7ufP/vr5N/L63XEuPLZrnpKhYZk4HwvbgAclaF5LqSaxtI9Mvt/dft+J727iFHsFVbqSnXMkI8RXF2MKjlA6+e+L0kE
6HBqgQMUI1VKkz13HHuucHARKRL3+fgf7e97EOM5n+q7rYw3/VI/Pb+Xfql562vLP3U9apsFt9//8j3BVSKv4Hhhi8SFdcxL8OGaE3qhYf0yhBjXskJ641cSOF4bM75AjDtrMMYFmp7RgVkmvM88IMD+y+xyWAzM
IWcNz+iSinLINRogn93x+rlA4gRjsiGWw+6nAxNaQSZCA51tjkk5QH+fUiwUVCBQ+ncBfjrwHfSXwjb4Z4hoZbRnZAEwF+NnigW6q8xvMLSrgf5IPP+iU5Fh5VVLL3sWNPRgUV2xah29c+uExK+OsfxzllqZRRxa
IJY9fth0iAz/Yo4AjB9zPmM3cIqE6OUGNYD7ZnLTaOsndvBGc4LB0gJXoRMmavo37ZiMs6Rb9dmjH2kybATiRrE85oDyizWVnNU0E0eeuyw/fCzXOLCZ4FsXREseDB+uwhH9S/jvA+vth95vp3dCjNBf3sCM4kVQ
ufLrmLQrNPl/evk+9Zhcv/Q3amFpnsOJfd9RFy0Gq3BsKbNkIhPEaD+4mUOCYlEaxRNygAnmgnOSX3RGnRsT/RtjufOXInVb5QyH3ltczd1MaC9T0jHSOw8aFnPkuSBZCtfZo4aCC/3esY582/nJr+1ta/VTlylQ
4F32+LW3areJaTU7+0aP2s5cEUe9xXW+F0SqXtaMi335mUVZbedc6Oe6B7tK5b5n1UtYn7vzZydMe1mTK+7M9yvSwMn9HA1q58Nn5wKzp2rmB7mwpH5aJ/oE/91EjE+/rs7UbfI0nzGtj3FQHXOIkkXGiw8Gc8gw
04tmMKpk2KySYdf5xuCHPmmfqfNi7N0eP/rlAv3TKCvas9TYqCvnN203ig6UTLrZdFXJrVaCEu09k1AtAm/WhGH0gpyk9oQDaMJHrs6icsq2SI73unXhq3m6nt/LUTlqHWFXZjbh4bEtgG87llxsMqvtih/C5qON
lGQ+XlZLOH/i735yTXVFjVFf84x+Hdj1VDARPMTd62KtjMqISKDr3hpGXzHTKteHKAHMvdIC6wHQhuRv9Pf87KOu3JER93z5fS5LfuaIQ8H3NtZlP8rL/2j0G2jxt/PzmzU2hJ6sRPqHD+dVSMXSw4CB1xwn73j0
zv6XdSabrjhV4hvRRzcYMct8tEwCCvm4ThoEe2FV8ACs5twkEpcj40XDjlAbgMKBJ6fQasxn34tTAQAJHEb/Ypsr5ClrtTjx2I+72skLXn1xHu1klSaJZGQMNdYg8w23UKDRiC41Np89l073ufCc88I/42d3h1fX
JR5zmf2jQTVAm5LoNaG9dbqRJB42RwDvzhmgjyyz+4qXqlFyHkiq9VkE6dfxy5vcJPLv9Yyp1PK8eAYoWiGYXFkDnNeYoDN3+tEs/7azPPjC6zfSu4cZ1y5Ma0jxKQZsxA2z1iUvqhH0Ar7nuWjUjvnMyeXMAXbU
G7m95/7R/p4RI/2938KM70GMz9r3QMbUD/R3UW28ljfpAm9ZXvsTKZCxPxEGjvJiftuLa72WBVGw5P735Sfii3p55+6PPPTUviUX6YcAhKUc1DHIt20LoB2euZIVw1VLS8YrWU/em8iwjklEJlmeeR6moU+AqzBL
zMAN7Q6NGGva6KfglKUemcPMkn3bVpUNdSlbfH+BGOU8lvxKPFahmQSCOMBBBS0U2qJSGtoKttGosB9CRkWolImdY2487A2mMfglaUadZ/ojSYqE6a2DwotxzgmNzaP5UCzjn5gHABuLIEbrS2rraaERIeMejgzv
4Tm45Kd2jAHTdHx1TTDjWhHH3skaWsXpAGRNZzWXJNcII6adxL8kl6GMQylbuoj4/4FYoJ+gC96wOhlj22tfURZfwX+fuH7o/TZ6D1sZF2LMI8dsuN5KKb7MAj3o5Xs1WLwpjThjAOhqOTCzQppQMqbEI54R49G+
wye7ScyaE39zXmq3YJ2eMjyFn5j9yWVP4vbhdks/EJ9tyeosdPSmt3rEqK21M9334Fhe3cxmU7b/5K02fd/5XfrqlB687n//p9v3upVxIQTaP0rWyaQJzTZjOl21RYsWkA75LD795Wpmp7yv/t8aE88IO2hdtcZc
YpM5DKf2LT22i8/0xoTnNsnTmlA5Pj/y60z6XHZWWNdR1gd0dzqOvTdi5qi96eTMGCunByw6I+37YOzNA/Nxb5wi7eTV5RSb9PnWWplr/K7Wx5qJy3xSX9G+hamHyAh3Hb/46f6+v32P1GVc1yFHxub2aykiWPHO
+uUc1AZcXjXAYb+ag8XjfUW/iLS7eBrjYcVD2198c84FRe+FCF71SecqBZkXdru7z9+Px6HVm1lpE9ApsCe9JV+l9OXzIVzx9AuwXPB0dnucjmqJl/eKP7rMgLni1Pi8wsof388fqbGxLmp6XtabWRw03EV80gdP
Tv6q/vJ6Vcbj/ICZlIrs4quf53rOkh1P1tfDMvLP9fdjfqnEl+/LmNpf9Uv9YH8XVfEgXfzYVuhhXPGI15/JJ3H5N/Fa0G99tFAf5MMUHwpe61cLjm56kkNtSJr96eVaSPTKyigSMCuW95WgCXoM2bJOHmlQoKLA
fLQ2QTuNw5sAnbU5P4GhfAsV+qn4w2rx1FDZg/eSqUobgK0aU22B3jqhZccM65bh0k38vaNlImuGhQMCS30dc+bQ47+XiLFa9MMyD10ddJPB5HjvAbt5fh+ZkQw9TCAM1TtkpoMT4yqgbh2FKcJSi55BWLo6NKWG
wmxqrIhseQo2JPbEjeQwv74yt370su3yrmTNxoz0UyeudL4y+AY/qS8RYxvS7n0P8P50TfLbxRqZ34w2HI+WF6byWFnn3oEY/2F89EPv+XUDMS7/iPX13pPWH0tCyKHSQ1dbskH8J49rfSay4T8xfj/03k/vjew3
m95CCMyDWETC5YUWv6R9p0rjX5o/du0dZedafBjh3aD3QUpvtO+91xqllS/oD/tzfXt6jyPGz7Vvz8HlDHxBf5dElySlkj/2TYz3GKV+mV/0y66H6C1pcR6nV7DTN+S/K8TIfM2vYMa/0b7fSW/lu7mPGf92+z5F
7xZiXPrVZ62Mz9r3roypD/f3ZcbUl7UvLj+R+7dZcfmljsh8vkMSJK76pn3pnLuVhxWYl7yS5RUUr0sr435aFX8VmzUAzcKM+QozloUZvUmuMPGLSapA53TTAlmx6E4swUfLGjp075hm0B9TWRt1TpHxwFMKiAer
ALxmQxs8qwv70RgPqUEm8J6STBKfjLbWqD8jRvo/swgdC3DFFiwjCZ1h5oOUsm91ZgwdE8VZT/uJi8FLVErv1voactKRRYx4YqxdYj1hZ2ixSQwvGC1pxl4xMnwERq7HrG21xtHMGKIOFveEoE02RSpclcaY+Wkr
fWVzDgn0rGhU4TR//C8z+hfmxssadwWX5Xw8VEj1wYpwTGWnMRRVtLA2KvQ2Rq7T/qsFM7rPWBm/Zr390PsD9B6xMl7e766vp1/PP3ng+i+N3w+999N7JGPqf6m/P/T+a/ROiFHseW9gxv9Af3/o/V56j1sZ/xv9
vbxetzL+/fZ9it5ns9882L7lQbpscq/6pb6rv4tq5XUvX+ot/1hJcuNWTOKyGT6EGIX7ma/gLcwoVkYixiYRE0Y8RS8Qo51eJ6DImFh/hh4ETF2emdU88YoBA5ubKzMnOWUKcioLmJtcbjSNhlAqkFumHZ+ZZ7g2
s02a8VuglIAYgS4D46VDXWdUYWPGZa1D26U6eTUaD2LqM0lIyKjyPlR0NU3Dqm2K8UKxuiEeTLUyThxPj2h6VGxH7YW5nJl5MTKTIosIJSBHYEXAUtwRQ+IdiRV6Yxu0X+KuUYAks5Fc42w96xPnYirpMc22P9p7
uopUMMup1hCy0zpONIrx8XFU07tDRxRHF9BT/KmmB/pMSSdC39AsITgR4/Ksep+/yheutx96v53ePcRYeVEf4rWsgp+/nn59FaUfev8wPdkcdt0MKc2yc6h9l/b90Puh9xa9xcNTruV11c/+E9+gfT/0/iV6i5uW
ZiznD0sgfpv2/U560vf1z5M/0ndq36foLfwvaV2u9KuFGJe98QtqbGy/VLTvnRlTX6cq/gfvyZh6DzGuiT7q164pf4kcRZpuxLhqbLz0Sy2S52C2Oiz1U8GMutME5iXCO0v2meGZ59vG4PrKmLyrso79/N5XForD
FrviUQRfShw2rySVb/ntkbWtisdTldZIjiX59pihw7+Tz9fBZKXTml96yWffV1YYWhND9NW2dYLQS4xtW/3yjr8d0uIuTwj9XO2V8QtsyWrDXjhyrXrSK7ogyT3pNGbHnOUdK3/u9TVeWDkf2cPCUjQAohhE1Qzr
HijmJA8rv9GRs5HVNT0dYJmOy0wzZfxCLf3LYmi+AT76ofeS3h3M6BKvlWFqlkeup1+P3ffo9UPvP0pPAhoG43GwbbIUIa7v1L4fej/07l9VLlGF1tn5go3fpn0/9P4teouf5BOpbZY+KhH/kf5eXmsnYPHVOpNc
F6PxDdr3FfTkJcBxfMTK+KD+9wG/1Af0yUVVJmajurfoXWJGeSVgt2SnhrxklgHWpjaSJZF1FFkd1g0WiTUjy7cq+RRTJl58+nUTM65LkKPUAeRf58jWneFA4rglB/Vv15+fXytinDH+dbBGdxb8dB3XQVzJrJCV
lkf2/g+27/Vr13RkvgCpt8hYSdauSSuf9NW9kp1RvFclrnPPxMNY8Vv094fe++ndQ4yZ1zy9IP++9PVD7/+d3toRv47e+14/9H7ofYrepbb7FfQ++fqh9+/Tg9aM6+vovfb6PvSWR+rMcn0Bvduvv0vPyPUaYjzX
1/iQlfGFX+qX6JMXfqlPv+55pr78xcnKGEMSN8vafZ5MgpiZ0C2wJsbTr2az9amprH2sLSsfmezcu9iikRobNvi7iPHj+u6D1w+9H3o/9G5eddVjeRsz/j55+kPv/5HeJWL8ju37ofdD75XXq4jxG7Tvh96/RU8s
i9vK+BX0vvT1e+ndxowfp/f519fTe9XKmPR4n1/qzXxpr2ZM/aA+6T/ml/r064QZS8yhABk6umHWxB5X6+npqHxRqnSf8B49+l+yN0pF1neoQQdWIVyRjKse5Cfy+Tzc3x96P/R+6L1F70Er4++Upz/0/h/pvc/K
+Da9j75+6P3Q+wC9T1oZX9D7stcPvX+Q3jsQ43+ivxevtxDj72lfj3wXTadlFZJ1+LN9ZC0/0r73IEbaG99tZVwepI3Xc7/UD+mTK8+AYWFA0Q2DdIBVarrEI644xFd/fYobHEOypYy638PFe5T8YfLf03vDN+YU
o/durPiP6+Ofobeqqq3aGB+OJ/yH+vtD72/Qe4YYz/4Rn7Eyvk+e/tD7f6R3GzF+n/b90Puh98rrQcT4n+nvD73fSe+EGKE/f4GV8fz6pv29ovd5K+M1vUde3fKdeo61qfqim3xcPkrv9dcZMZ71q89YGW/of6sa
xvLj/FiNDbEoSr1PPwILqUnO0CnFFnP0MUYbFf7KMQIQ1rTyNDG67RXr47fTd/+b9AQrFuYbbjH5Gpl72VRamp/hxv9If3/o/U1677YyvpSnxbY6NURNClGKUzdXcbVu8/Tj8hcx5tkd7pheeeWmm7Ulf9xz0Isq
+xZIjN+M3nUDoTm98TqqOouJ68bOaqk9h4pv7Ey9V9N4Ttu9Ci6xv7WMWNdOlEIeTfmKjk7uU013jQbM4MKMqZTkIr+YoxXTsW9774N37AcTR0FWhqdfYeD3Y6jailp4h71AK2qecemOFX+F3mNlD5kho+nV2DQL
y88Orz17olx/+gUhPX3N1rc1Bs8iWWQfy5QFFmNhA/e53t0eddfxxJA4Kj3XyPqrxyjjF9k7XpiL5kaykP41Nh89RmOkCnUX4h6tDyElVjWKdnZpZS0Ye29xDdnPW+09TPQ1hOiTKg47iJK2brwXXWl9FSVf/x8+
cP5bLDattsbr+V2vx62MlfMRwTM9WnmGcBfzZzeT8PflvSlWNSy+xRg7mZ3SY/D68p44i+8uRvBNYzsa5OpqH+vmxlBGJqPyxfpPamB4mPJuMJ2YQ1ucjFxKrdWijy5kqf+E2TXCX2AU8h95L+RYU8YUhSA8Mlw1
A3PJ2fB1cRj4K0UTysrcXWp2U0YZ96TsSsnggD1+Klt0foAjwGFYHblujsAjai/4FAoH2qEkidzwORWZdzLP1bge81GZ4754tjOj9QFtWqVPnEuu1pp68OhCa2ADUJdHoee2GdzCkUAf+yjMlyZaF+iQ20e0q7+r
J1yBlekOqGLMzSnGFTyh5bBXj7nVvq96fSE9QYw8H38NM2Idtl59Qk+Ztz0Frkjja3Ng573S02gY+DUmT7/AtxgXyATvytSt5D1hIWfVAugcchNCKtuw9Nw55C4ombHoDPkjHDmYnx+SDOsaUouc4jBnL3Ti97y+
8Xz86/QesDJiX2GaRw95YYWbsL9hlWP3ZJ3v6HKCILHc30IgT5z2NxsgAZtOLa59NixpB16ETJH9yGBP9OQ/1qULmmXWizoeKz/xKZUsO7vsJ26EwF1+5t7KdAA91QRwJT6hdItL4oPezKVqaBLDO0rEeEOjeAQx
VtfbrOivCsAueA41DJEiOUFeCf6b7fIX0RbIwqtdKXLf6KpA0Pa62ieYsaP5BRjOgl4JjWsUe4ItfpOSnTGMbMrSWxykKkY5BqKorPD8NWfAgylj9yyR0pdP6AuZvs/KeEaMkC+vYcblKXpRi6XJtb9dn1/5qL7u
fwpswVKAHXuFtdFM452ywTSn+Y72O11stdpAUcJjdID8CzmsWoxvRBpKpk4neT7ztlCmXUHVndq38oF6+bbsu6Lct3r7CKXYV2ZSqTIi/b3vS3tUlGWe0npx5ZMF9dq7153yRUpW1t1OtnQ92e1vy+nbwxZ7/jbJ
03YO1k1vZTINp54etXjr7uXxhLDzul4+IezMqKw7wny5rDziyEEDraSGKLl1+PzHZiic6rO4m/zy8q6j1+dRPMaEd/lTr4/58BeU7BWllen1cuSizH+Ue5zcQ9qn2ZL8tsf4PoyC7l//JH778/TuIkboL29ixtAL
uIL3a5Wh62oWbk2jQG+HJsXKpwo7zyglsn4o9PQVAQ7GzpDg0RQokOt5rUCh2vqM0s7mZrKK/DV10Qzkss4ElU7QgXXd+y8gYgReWzQmBFn0mQhHPjG2ApJoAlNKbWCrtKU22qSyxtMPqtgRnn6ZoArUNbRXGYO9
yQdd5StfqwvYMPcINWzQPnTRbuU5DX87vXaYaGocEKg7nh0qIfBvNrhbfm1U5UajINk7oHG0TLdcV5vQ1+vxlvGw6EPVaudr5s5Y7dKstbEm290mn6xXTR1t0ok4wWRWqu0JTQgZQl4oYH1BzCTR79eeVSu/ilP2
UYvdDArqHqfeUq5hLKpZY3h0UoK/OtodUwtqsrqQ1APSITGt+NQZmKhV6MU6yr3jhqb6FmJc+hUYqY2wewQOUU70qpwjNrEijaxEQtklVfG53AmpkjX0mFjziHIPBgH6i7F7B9fVT0D6sftocqgnPyWo5tN5vdqd
LXrR92iAEwM2tLy4hvNhbbE+qq1dWZAp/jRyOrZKfQP3apbidQBmijMHZU7ZnBRYH/+bcZiqPfbfYodZv64hFAcd/2iTMyHhVuEO7AkzBzRdWjVy09gOKkZ98SKLTFmjKA+GHl0rB+Y05eCwdmPEsQ7r7mMCmrE2
SW24nfkcmKgNz3zmQED96B2UK+NbtvsDfNJ8GE3OFtBfLEQMyx6ZAfyeQhuQB5qrJ2N4mU8fbTZU0Tqgjp/7HEK9bN9jrz+MFx6wMg7L9PJex1nSYV/A6vemykorHL+2ZBfYPDnbl/T0GiKt95y74xi3LTWhWBZW
4bKFs7/lC7O3+7ZwBv/20JJNk3GHvupLVbNtCTGLDa9YsP5hvPXv07uBGF/Sg9zh+ZOGmFm7JtPgT20FCLIAYCwnuS37m/hZLoGSgT+s0wuVdYBEiEojEnDGNgq3vjLqaS/B3rF2H0gUT1xJwTR0N5WZEScLFAAv
NHCiqy2Z0nrknouNu6dAbAR5qteOZ1VmeQlK3jbdja5vxIj+3sSMkIJoCYRhiDk0kyjzoBLMih0ULUbDXXDTFtl/R1eQPAQ0kH/Kc1/C12NU2ZVMmS1nLiIzTjsldjHtik6TuTfRXVdTWegOTcMXUL49d5q13qCW
AKFidfLgWJnhvc2HbB2Q8miOVm5/AsVk9eEWYgT+/aiVUeRyCQWLPc/jevqVZ9G89ieSTAkg2VZzN3ONHCq2RpMilP/otCnG6OjQM+hD3kHYWAuE2K21wzpTXLHTeosW6pp8gsInFSv6Xf2SGr6vrUn+HFadz9AO
caWSck7MF+oa2QmYopQaeHDKu+SeWG2JUpUR2pbgpABK+CuFjPnA7xcll6Eb4Dmqxcq4y1ljSYU9Ju3Vz+te470R1cSMjleTQAR4vzFXK1C/SSHRhxaU+sIy6/d8BhP41DLwi4hWaICZ2E0TCx/r8+L3rRRSAT2W
gPQM38RCxGIBHchgMm8PrdZCP1yKeeyBpvqMxS81PMCQrC6J30L3QM+wM6BnkPegwXpODc+1JbEqY/LN4GGedfCgmKSG7QaqqzUF+lAOQbLPYnp5wCH5Y81NvCA4sPrmMHLMXORl5PqulxnkTODlPaz4uLLzFta8
RPv0GpU00WaOiimlkcNmCZn4FdiQp/OkCUoelMBehTVFYutVN7SRRTNBxafA8au1enCFB6/T0xaCKzUo/wrjm/boAoK0XI2sivue0t8Hb/0X6H3IythE6xGJGwnwKU/XF5d3lTQ0NeSWyoB6HTwk+yFf+8Y9Clgr
KasJWviT5hWgGfRnqK7ayu6nqyl+oxYI7eyCNkvz7TYQ6GwZ7VvEYoOUmn1pz83EgAaEtf9a47GSTnuqzZBIW9OuUMaSNVDcaUjR69dU5ZUgieFTH2Y/XwEL0T441lmtjIHn8tmGLKYBcy2a4zkRsA3taHiTTyrE
ylx6poYwiMHZtR9Jh671T/lLzGFBH/vQrB0KJlXsAkAWVZI2tcQj3Dp3K0mvAJDZbbWBsgC5omVcJiBGdqVzblbrqw9JmzV3UEhDPiHrzrTnZWqOnyCfDOHtKehmIT7T3jVMhwfsBJKFLqNKr0CuYA+gNewkN7iC
L7FfvooZx2l0nWPVn7UHjyudA1oOM3djF6E9RTVXACT1MU5tn3UDv9hcMX6Lm2Y1JoTWWJnWSR99hgA/nqYjT7Gffi1PJWy5rKi0tW7o7DX4Og58Ziksp9pz5iywVzmNHLAXSwrzBESjvzb6gSeCFjZzy+c4jLTW
e94BEalPrV/XAi0mj3O0TY1Yj1r6PiI2A9ZLtfrgeuxfNmXsGVqePmrDhrIMiugq8Ls1pzG5saJjLmjf6qPWA1DmmWLXdu9K1eo43Yg84gGoWScW4CQem7RCm4TC6nz65YCY0ULHdTNZ3SkFZWUOALKgZpUJTtH4
d6+sxQz1lp27Z2f4Vvo9X88Q42v0Ai3Ta5zq8Dk7vfXVYcGIXp0k4sUqIb3lWQFJZJzyJ67uZQhE4N+BRzOUm5SyMvfYRIOF2ip3hgBNhOBhyYMO7eIDocM3X99uPv51eg/HMmK/G0O4gWZDKGb+oOd8KBv0Uc4Z
7G+a9mf8GXUoBmLALeZZwgyfqL2PQqFs45A+XeqVB5Xz6URVRQgFq+gSQb2+msqabKb2yQW8zwPL3iN1dWn/Kliv0mpfv92d+ZaVsXc5ZYPArhck2N/Ok8wKLGmTnO2ydhx04wQhFoF/CqUtdE6bE3alcdqVJjRU
3TceVjy7S8zfqZcFlqe7eYpkxeBBfzUQ5EUPt3QMIORw+EQBElNxP61fOlUEIBU1T/t5r9tS+dnsN8/0v5XJNPBCM3AJii6X7+vzLNdLT9UTPcEELbbQaDX2FvyEn9Vo3IRwqkDEAygSIgubmYEaxru0rti3kmTF
0YKj4k39dNX5I64IZgJ+TrFlGygzULJsAtIvWYdmc0sdfOQmhnuGuOzdGICOXdAAshXgdAF3rFgI/QSKFFSO5m3IUWFnnBa8D9QGLAXxqiumDZiWJvlYF+YLL8aPfpzY+YfWRhtMKhjH+sAzbqBlaKo9YnYtJq3X
5gexHc8sgMm9cU3OTxXuhlz2hSfsoYHxsP919NN0LD1RzWwNaF/SztkCpRHKKfDccCxCSuNKI840USvN82LgrKigdAKBGe+BIIPFSE+gcizeNqCiaMuSHFhS3EZB30SaDJwF2q4hqdygkRqdmIMX7XNQKQb6oSJt
xsMkbFc2VUHn42o0BjE513vTfhhn4sAIEa117BkV+DRDH5JIViy0XJr13UCbJVPXCSCYMDHKFZ4Sy5hYz3Mtg8VvMq2kkyfWxoOFZi4SB0v7NJotlPBN52BoTSDso/YaujdGL2roxy5gTzNFh2yAVrO31ljD0QUH
TXJCNDQUYX579zXJbH+BxfEfwm9/nt4DiPHWfpnTgTiUz2Ar0/eG9lLmK7G0GKshb9TCM/L5Fr1cdnECMy6bRGxWDa9LpivlslHWWvKhT2uFpxWzdynIezDMER8wIc6g/15ixgEo5NZOZB0WSzrtqPgQomshrKYr
kFDTYoNiPHbxpfdBDRo7BpRzbU1xOVglY9To6VcvEWP2UM/27mBTSq1udDZGyFgfBuu2Dm13K2eKywMVe1uL3IzVm4jxdJbJ/tJFFcND9Lw0/dGwb27/nAkRZytpFlUAX7ESadxyUc+FMbDbqEvE+PQLEswcDpYQ
9bmY0zihs9irRXeFuCyYaagO6LsfSfE8kloBTV4mJa7kjIlb86EhP5wWjSEP+5IvXkeM1crZsgw3/Zu8N8Qe/VYO+iGeQ6o4dNGk0ziVdaatOxAjtqaFD0cjPtqYsZ/s2G47ULLd9N/1ZmFdC3yWl4YGXWpC5zaX
iLFi11Kn9YE9xZezHVunCtSayfsGmol3RK0yy7ZGUCHizlBFCtpMdQ47ptrro0Zst/EKMwYPCSq9BQPlCcbWm5ta8kxWjs1hIUaobNEs3jHaT/qrvI0ZT4ixQEG4Vu9krV0iRunvC8zYQxytE1+ivwkbT4LuZJfL
pIIC69s6M8HC5pEwfpvN+unTL0zukPaZfoNT3vv6I3jh4ew3oRbVFieXoSFEqD8vjZWuB8MHWun5d7/y4W9bOgliPN+zn0dyIS3EiP2c35B7NDBjs00tw9OE0kf+k3HvEAbhxdnNw/39xOuH3puvVxHjNb3YKzYn
WTkR+101+4DnGWKcBQhv6o0YY57Q/aG4DvGn5uYI0Rywx654iBJbO+HDzqrdKnu2ZX3iO9ClzQrNc9CDTdwnr92nwv1jtQBsJ5IRyGL/Lmff9RsY+CVivDV+Q3ZXdIRHU5A8gfthMfuELmHrVlDBJ3QNCDEHQQuF
E+KVuxL2I2jacRtgoZw6r9bZo/zatpR9Nets1SVo02P5ayhB5HE9GX1KufBslOvNG18Cn1Sgs89DtgK8CmbUp/28HTqBttZe6VeXNTaAVx+qy3i6FmIsvCAjLKa27IvyqEAeEDPyvBJAiNfOR7N+beRa/xbfVuCR
3iA+YokGXwEuZsyzx5MB/ovY33wyWSciuoR2O4Oh1bqv6hf3Mqk2qVnfS20qoPcg6nsFkAsSL8mIDzOS7YoQASiqNCAU8N7Q0P5TZ+adaIF6kitQCnkInyu2kOawt/D3DVhkKFoCIU81y1Hi/wr7ncW2C7Rmg1iv
dH+ZB0YQI1S0MLRhWY8BGAemGqSbGM/ZaTH2jmfzFk+EAtXziK5DEYwMhClVnu3E37OLlbYDL9IPGPi4JUwt+pHxHIYUrXxGzQOldtUMIBK2fEBpsKdyvkbaQNiTgfEGetJQlaEU9lmxKjEKaFPu4Mpk0D0zGO/c
qH83zjewJcBxTFT4itSghPQvFssaDUKbeX7gPSB5wZhALUD7no8J40mIGVOGFhmiVRY8hRGxJkRdmpvYgOIYHRsZNcOWQ+U96LJv1YEP/sfelaZHjsLQ//m+3MXscBzW+x9hniRccaWWVJbuTjLgmeokZT+D2PSQ
EICwqL8wZRLZX5R2k+GWVOiUR1o5glpvmkpDOCPAdHXEG4zCk74WlM4ai3yHrOg0y45eCRYL+g59Ddo5WZoL2WFxL+SrIF/Ub8cfyc+P2kGiFu7e3sX7q/jb38eb/sDvtTKmcrK6+dR81DIv1Nvzpc3R1dOMhrnO
k61854EZ2o2eb9to69a8k+zxGNG3qOvuY0O2io2tdRlTJAblPNcYR4ZiCiW22cG6t87TZ0SBJVmwGxvM7l+SB4iapkNU+1xzTeBOijW5XQds5NdDnmK68QJLteIL2FoOfjQ2Kk7/RC1nLmH6C9lv9F+duaS9gLSl
aevCByrGM6eqeGoyY7TnjPFMfsIZI3FGsZ7RGk/qXmOm8kXT/CDyq9sLYzzlPgxMkDw+k4EwY/KUN6GHY0rBGCv+u8g9VwxmbAxRCsNcnByJ3Bt0yjQCdtYyCs0fOorXJiZC71wmJiDcPuaW8thXEjaMtsFKu7jG
8yZjvNVeyHV0ImE2A99i8tFvLlaj+eRa9/rF8wEto3b2C8VIi/HQbWraXEGPbZkqRAFbNoO8//Z8T2swOFhyitfryiSNvWBm2Ura/b1M1k7aIpkyMRekuOtK1WQ1UEO5k2yLDrTNbJvl7VOTaKQrZcgBs6TT6A+z
1TdaIPf95PkMCij8MEGb21QPsVot7YvGZ5taIj9n8cr1yBQqXmSOPI2kzIsO8yZjJHvtK84oKy5ot5jxdu7psnUY1PccJ4hWqQJqxN5tHX2LdCm7169uPpWwTe2qoZ3kROtLs51hFjUiEz3eSN9Av6d0kzFe4h05
Y6vJ7t3UQp/bfd27y8VNqQeyDjnMnBCvofWSVk++EbWTLxbZ7mfrrdAW6oFFKtE9eyloTiaTtjj/spUc7beR38I7x3vcyniDMRrMoOQ3Pv2ftcNkl3Cn+MxsuRSaYWXFDSO58UPzqEYrbqST13byoskYfeZIK3hO
RYxBsomZHEJjq0PJSGAw+TfZ3U0zCZ2lR+0thUrHqFMuB1qi16e15Cv+tvf3MvJcY5Xvea6oyQpIoS0xsZP9QyIAFOSB+a/StmeDOS1z6UrRic6I33sMbSurYtHnMTy4oMXDiUw4DfpGqzt3HpkMZJJ4dZO4RE/F
1djYcuLQ4zZ/2plgSImZuSTpJk/rdUaRt+A+VM70+lzG43f3GCPrf8IZkYWsQFi2AiU+eKhBPlQfMaMZcvaD3kJMGSkT8ROroI6FrsypQBt5fipV9jJCJwAp8NBenKmq5AKRoz36kekKNRiPwctks0EdsW6wR2q/
mj++yFeyQboxFRsw6jGHw8TIO9w8xSfoWluqLej7LqKBodUEFVXToKMKxCYEB/3UuJ7J+5D29PPhHJAtb9ZH08C/lmcV2jIeKIIFsQy8DfSrDbxNdsD5C/m9cMZAnBHUpobBFiry3qzk/AV9giyFKDK4iW68q0J1
HcknV2ttwOw22n+kChQr6El40tQM1WILVAJQcHISVpXjaWwltj6corXTrkCz2NJiwX59p9iygWViOP4QNFeVHH6G5ljZVxUdrAIdygc4FnFIGgPYI9SQxyv072ahYIBYZVM2so4CLRN/zeQ/FDX5ukJrLJbe5ac1
7sQZD4yxG2U05h+ix9Q7oIa5aAaoofYRTQF8vxY8CJ0i82oDrcRDJhH1kTQlkgpKDcmhf2RD3qsmIk8WbRlaw2SMyGj1lG9az0ZOKed+S7iLeGWfd4Hu1uiRIaOgK23QejZbYtJkX3KqkAG9gnuSURhNMf4AvvUb
8N7ll3oY72fEMbOFikaiWcfOZY8ywvOY8QGDEK21hTnuYvyIaMCYQbiVReIfGJqiOXuTU5gXU1AYDsiSho6HezEGRENxbuQWNHl0T6MwCJqSMCnVPX+FuBBmDKsxgIKsebQwIghkRqeZq9J2IUU2NowW3coyHOWX
NqyLDx5YRLE6achP7YtyVg+iraCEc04XSwENwr6i82JAhMRKojw17TBPQXnnG+f9MfD+wagz+jcFU0m0PgJlW9mwa/RXrYwZOqT4pZIc8MauEtkPpv4nGgFlw80INsqbFqCl426MEpR7cozTnaIDpTm7gcOSYb9a
6zGkoA4wqZE/ZgosJ1BiIOrMjkyQExA0KCIL35bz2jJQTkFNtCWfBly8yudet5eL9Ej0G7LkYWJhxtM7rR+k3WlS9l1iqKbVcehDs1y+JComOCJKgXFc0+nBp9WIeQ+kUGlmtBivgE8nFUPZ0TbwoCa2PBBFbzAZ
YPzWJrsYvaj65E5SQQaL9YG89Z3DvOVsovgAxKfxK9puLRQAZmAcrU6h7UL6rL1sotU4QysQJCu9SfuCdDe0r82bGUuhEK9kf2prNJpOSzRNYgRPFJkAFZk6TV6DVS4pV3IF8wnVuO1cflpPaIoC3c32hfH+/VZG
7hPRQOeojhZCqVWjW8VeaP9+p/Zucxk1JMwbZNfk8jbSr/KZ/uvRzjo6NUptZZbJ0Ans4S0/RL+n9LCVkXeKir5IW126dS/fEV7ArA8lnkaEoClwUTAZNaxp0ozzXrQ1zPM8aiZN/wYKLrXv/RYeYJW1tB8nEEnM
Hn0wJfJH0uTx5BzdW7sb70o/qD5+Nt6DjJHwoqtBdh2qXNEv52rtgGpuoNZDbbWuQENNVPcYgAxtGKJ6V2WOE9JeMHiRf51DG8F4sg2NcUr8FCg606mh8KhnNw8eySO8sRltMHRb2j4Wq+g6j0o0n9thaf1y5okm
OdLsraEdTc5d6Sv3GCPLj0cuXVxOeTvta8lzjELm8ZPtwSTydCh55smRW0Ofs1Imy1npgfxtpyYij5P/ItEydCgFZWhYTaM4aBUt780yQEGmzlWNdRXjNBRUzbOpd7zfj+puK1X8q3xPqiQPHcCQFSVgJugOfY+D
kcWDenWDMe7+Ug9ZGStd91oLyS9tdDVJEuVGvFR5P+T8i5y+yEFSQVYqxX4LFZTHRfxefdsaMcYQOL5PDHG3VNp75z9OxohpA0zWgDGyHRAiZMYoXqG8/qxtBkEMUPittWFUxTtpua1img3gfZjXMkhvbjVbCvAD
CoNmDvpFHjC2Og+iByGHRPEEQf6szSqTJRm8EOQZghbLkz/J7x5j5HwT9yzkH4t6N7YOsiWCTGGm79Cdwmx9jrfXpkz+tnHQVibaDst7WtDUZV5OFnPngFrSaT+n0dAIKOhdjhjvTfJQCsiZma2MFkwQ877BNExb
GzHH8t52tC86fSRvrLQ10hLqoD0gKK9WtCKZIEyDIlOgM2pLWrdQtrDhHo8JZhBnjMZifiFtv57H9hHGSG7ohuJfkZ+nzRFTenKQY42xkAdRtAV6CKhf4bAYhnaX9hqV0rwZsUBVmjIZaPkYG2gTLcVnaKMTQ97I
0Rgv4hB6g/xgUesBlFnRNtrcMLCQCy0zxnayRAqvLGZLpW0sP0KiN0Hrl5EhYgwsFIOJdocey/U9+dbPxzswxpf4z7c543mi+EwYTaEwR1qacOSkStfGB78+P1nyxbuyB+1j6dfoB5TEZzIRO7Yv+5TOZlSOBzDI
vuPT7u/o6pTowOQlO+Vk7TSG3Xxxcxb5XvK7ZIzX8Bo054FB2dGGkkbriQ70zQUVjbMD1E/89UK7oot8r/L+GzxtMRkU87K/80qPJoeTFubSuCdX71d4PD8mzG0tRIpYSFqXq/0S6f35+0z6p3gPMEbMvxB9G2Dt
Y9/HZKExkO9E8jOW8Ds2F/4q+S28Y2LGSOdr3I2Y2qoeG/TWaGbMM7ORLlZG9DMS6Vnvfk/+oqXIa4IKxtjdFW+OPyW/N6yMPM5Q1A2KZGYc1MpEFk7MA9lRxJ1myWKa9/0uX6FpnOfv84n9Uu25fvVRK2Ob0W9o
Pzutdc5X0HhUzj45TcZ49Eu9dZE/pptxOV0KuZQRUqToQSX6NHgnaJ++qO4eV5SL9ve8zRm1V8pmtjKSh2UAu3CadinQLousC/HsQuEUW+P9sI3We1Uhex+FpSXLH8X904aECXZLhqoClqeG8YpWJSFGvINM3rpI
jB6/M0aKx3PyTFVVow80MDNHltVudMWbQqLg8RRuF1LHDJgoWpn21tEWRUyFXnnFMVdzYnseGSvILBu2JP44+LeGgrxspaJTJQ0u62zrxFDBrMB8MTvwimsstpBZsvJMjFkC9UsohiJF2BohCk+SrLSfhTztOA9g
b0GRTbDVLYHbd9o3BPlRmBlLlhzc47Qisy3lL+XIPP/cd1M4Y88U9KFADKgrFVRvjjclWYqEp4uj/SS09Ub7SPuieqLyUt1U1TRZGm2GTNLmLQUCGsS8s0upqR6RJ9qDSDseDR0+gP8LrtpNriEltIeeDepjM6Ch
5GFKfq3EGVMmgk22ZPJ9xdssBdak56fvBAWX10BEzZn6ijF+S771G/A+eMbG2XjKozR5k3eJzeVkFQs61bi96/0O3hek741H4ylHCqEdKGjsJ854RV+ATrpBXWC//RHJV2R+IaH0NxoNOd6c7g/tVHos/Xn5PX7G
hmgSFG+s+9m+yF5LLSxR+JQ/k7+fjSeETpF5tOhT+3qJl3qGpwb6Kp+gTL5d7hUL4vVzY148wzh21Ct71b8u71/Gq8B7kzM2inEZGp2t7fjQEs0R0ftQJ5X8NDx+8/IuvD+L94CVsZtBnjzsWNkt7zfQHGufHt2a
tKRHp9tXiexv1Z84I9l54mfw3iO/x05lnHyQ7+GY/XVGAeXo/hCBvrbL/Svy9xV4d6PfXGWMtN/+JmdkxlZKySWJk5REwjm7yMFGU7DMmmivIe1feENHdBwTM5Zat0rqOUUnrS17E8DnoqFg+C/RUd/WT6eV0VDc
UxTC8z66WLfJGCtasQIz8lbhZbS+RuiFbYJgaFJ2/jcwy6sz/4OcL5AVx+dHBsinkmbUxNOSIorSU+TfaeSgKI7+LXk6szLO6DdgXJZC0wRbRZaGCOEAF6sqY5yuEkGH/MM4+ivyA2Q180cM000WxvmjXUwtUa75
ontoh6QrmgyBzBjJAhhQ3sq6d+fSkqww/5bQcrdk8naKNt1Ghe/S2DjGUOHdoYHLPuXTKH6xm/kLctYGS8XQXsqTFI+5vKwplhmFxq1z3TgW8gdWkd/YkbdEcQrK7iuzeeLACs8FiutNvfFMJurwtlOOuD4oT3re
Jfkn6yBh0F30jW7H3YjyTacneb+sl32uJF1eX2P5ElucveQd9sWH+dHCe31dZYy0HvaIlfFrxtOF93/Eu8cYv0P+Ft7Cu5Me9kt9EO9daeH9MrxXjPHb5e8P4hFf5PN23uCM70nfrbyvGSPvD/24lVEusfSx/ZD5
zPXrVmyay4utiyAJpqbnp0o2yZ5KziX64JGcscUSJ6PrETw+ZY9iMFXo9zlDmVTkCUtHF3PMHcpXijmqBM5P8UDbw9EuP6k/M7OozFeiijXr5yc+57R4Rwc3xOJBcImLsd3KvXmi4Vv5E4bawZHJepghRUe7O7m0
++kkL3miUzXopDhb6XRtPnPwD/MFqSlftzqi8pli05aWA5926GfOyBpEx8P51FGXLsoZGyIZ+434zML783gftDJ+3Xi68P6feO+wMj6E91Vp4S28N9OBMX7L/C28n4X3cPSbB/E+kf423mNWxsfx3pv+yv6Ad1sZ
XxjjX9Mn6fz1EujFRWtFISmzcsomCjwzXHXWZjmF7136qZzPHk7P7fzVnd6Z2hlX/GvllRxUzkE/XIU/6burfP2D+dvI7obpolYq7VbTLo0zvBepSPTPD5wX8cH8ST2BGrY6z2I8x5OctSZ2xTzPQHxsNeIr8rfw
vgveG4zxJ47PC+8n4D3GGH9PeRfer8J7l5XxAbwPpoX3K/BuMsZvkr8/iHfOGL9f/r4C7zZj5PMXPmZl/Gp9kv18Sy10guBWKb6ZC5XP9yteu5R6SinMvYx/Tz/9bXh+t9t9hG39wPIuvN+H92kr42fH04X3f8Sj
2fD56SusjC/pO5d34f0qvKuM8Rvlb+H9LLxPWBmv4n1J+jt477UyvoX38fTn8N5pZSx0zTEmvlx7fKSvuq7ikYmtz315tD9tq7H6avBNOl3vwfvq/C28hbfw/iHeoMNtVLZ0nY1oiq6/M54uvP8lnmyL+Dq8d6aF
t/AW3sJbeAvvT+MZR9d9xngWT9XQpQpf4WPX89NHn8SV+Ir8KbmIFA8F18cxvzJ/C2/hLbx/gxf5UsBTSh3HtI3OZw96o0vV917Ae/czC+9/hSez0vfN38JbeLcv0aPO2vC3yt/C+4l4N9vTN8nfn8HLfEmP+o75
+8Ql+tNm6PyAzTxqZXw7nZ/X8fm08Bbewlt4C2/hLbyFt/AW3sJbeAvv++DdY4zfIX8Lb+EtvIW38Bbewlt4C2/hLbyFt/D+Hd6BM0bV32tlvMT7qrTwFt7CW3gLb+EtvA/j8S5fr+lTfwXeh9PCW3gL71/gqUif
IX4V3tekhfdT8R5jjO/LX82+GNtrTDb0ErXJfURnqqtmkzf8Hvl9LZ52uhmtitlM+Qq8R9OPw9Ob1morW0l9i1t0/u7jhgKlJI7/m83Ee58C9d78LbwfjeesM07VrdRiHYau5yfbtdVKtVqrLir6EL3ZPDRy8zba
1+fvX+LpZKxJytO/X4H3kfTz8DzmWI2JUWetUlJDm+S10ZgiMe/qmBXGI3VTnh/OHyMGHuvUq/OYvzI9jNe37pIeetSmNrX5G3rsz6vfv45ntrSlWGkODG4jYR5mtNd4yivvo666Vt7pjaHtT+fv1+JhJggKc4CL
2ncXDDTdETfTho/dlmZCs8YN41Xe3CN4X52/10mxJhnv1vhfyJ9RAZ/BUivF9IlPR2Pipi2PUWr84/wtvAcT8cXnp6+wMr6k56duo7FxxJJC7j05iykibzZBYffq4dUOzWOgqTfLy33B9pefj0nK5Bp9eo6OoWRM
DYJ3paCcMyt96zB7G37OcZv2rCHK3G5mzI2vqw+Ndxnkz7eCgUc7Vyz1rbvs8e10zJ9mbuUSf3JJp4T4W3sUikijH77lUtt8xJO5xxzHI8bgfM/VbfNGjb9LfnWr0H3AGLPGm1y1pIXgM295toRXeLQzOWIgN2EY
C7V/DGKOqfEsmy/wRT5cs7t8ZnupgnYvc8JcpeXNNsdvkF5lrubv82nhfT1e2mKPVWKGNQueaMooPlMk7dZbU1Xn9Die4j5mLtc1pIVx67hsWdKeaXymf+VhHQ43cO+y/NxZ+B/O2RzHrvS9z8lPN2tt87Ho2tEF
QX0YL7z54MP4s7/dGqOON/PfnXn51vAobQ/6h3aCZ471xbm1gspPn0cRv58+Ij8aDXLoGmqkLdVmb2p0PYxWA8rrtiJB6d6RC6lyx/Urc5O0o62d5U+sjFx2L7Lk9iLS3e6vtM30Jf3Nb94mG2yoNL/h1+ppNK6O
mI97vPVIm+cfz8dnGW91u/ewPbSUKYHLGcAK3pxNDjObCi8Yx5Uimf3UsX1JLvlFFJ/rbonekyiu1wCeZ7Jt0ckNcUZ8tq2Fy7LwJOc3g4RJUlk1Bv0M4oi5U837z/InM7b0q4u+d3+NSOY3N47jlTEvqFO7ONSQ
aCOzPqTnSks46CFGHfHcxajrOE9nc+5d9vHx9uybsSo1542uLXmnXesRWi303VJGdr1Avc3D5uC3UYsJW4aqcWXUPwOlj1nqeJk/UVnNRasW3fhMcgfJyCg4dQ8veFHG08N4Ya+0l0fSO+WXLa+GZXpzrpRlW+j9
plCpdJH5Q0tmLuv3MqljSQ5tdC/VzJ+Mj9wuXkXH2/aWPEdMmS/lnmO/ntxhjgcPjZWPpJ+oDx3Te/1SH8lfw1xo/dBlC677GM0YKXUbvDFKvZL8PTxp+f7GCCC8TZqYkpqughekDcja6mEmmS2E58x0YR2QJhOl
d8qdUfAi51mr10+7D1gYHpGfDXQGZdAtR6V1SFyQG33pfe1F9MggcxkjSn0IjydZveBNzi2jGdeB9KF86H/S8441ZIQrCnaYeO/RhO4mDTzoqYXO3Wv8jhLIylg6cjiqZuY4dW+KqhkTqGXugUI+4TOaODDgG1IQ
KaZmuCI/LqO0AqlxdVgFiwc5zMRDnQjJzvNNRUBaRjb+lLkxfMCy+dPHl5+Dl1yssYIr1liqKr0QYywjtNDofJ9cdfEd+mk3TbfRTOm41/qeakTT0lEbdWMOFjrgL/Stvb1k/l4fehGvws62M1uTaFeH8Vm0BjmR
0p6wCU902CQt75NrgLfk53S0IUIgIQRVfWXG+8Cs+nZ9SKm96Dvh8CkjoEhJ7/cQ3mTH3CtF+8qHkdkeWNP8i4xRsvonffLE1/9U+6MaTQ5Uu2mfvaomFTQYl2pw3mYomulUtofwMJoIgxHZ8F+E904PNBmSRE6y
YnEYyWVuDPmv9DeMtLZZY9EsnXW2KvL5yM1220sH7dmgQd7kjRd43J6jMBv+w7TNctmj9JuLdigtxPs5PrO4ZBQPFys1oiskbn/m0I5Ee5j6xpn9SOa/Y/+duRTd41qxbqb79UEM0GiSXG087xXifiXzuil/nvwP
wSGd1eDnOrRBdl0MUt743k02eRRCujI0iFVayi46wVG6M3/uwmIlshGb8dQoZBVDZCJah/CYQ82R7AlPxjaRqeRJy1v5tilFuWc+yG8bL/e/zLicvwf60aNp8oWkrVK1gX2rpl3Vuhk3VOtgQtFCuJnO6ANv3HpP
waaRi/FujGpDj+jf2pzjHZLYAOX7i3zLSB4OGpc+yFJP/VTqSNY4RO6iaZiDfUMYo9SEwHmxuLyas75wPMiG5zfVKuXMVa4qZotzIebskzKls9TpHd7I8xsXQPq62CzOtNgL1hcO44HcL/qd2vU1kan0HJbWNC7Z
/a5rrPN2/r4yfT+8c8aI+n2HhoGZHCOWxhSAz4KaitAbMqrJh2wtMcbnp+A7OXb1YVK0JlTTVNGJ7gV9TLS4imcqBiN7ObSKb6Y/tOnnpzkqCQeRcUy+l1lR1gXujhgyZkmbeSW/w6wzc1Bf52D+XVYwLua4L6tf
SysnST8/uRJMq9BIc7QaskX9fMgTbs+frEX5+2s5hx507H9zdDu0kOcnkcRRQjKf6A+tYD3sv9t1D5UO5GuWtI1C7Q46vTLK4BNcMTfVqT1DiKCILeqkU9f02QLde9PvV0YUGWMuNA/0D2k9MrowhmgK4e76q4zz
/mKt8PuNB/9HPKPJY4vsh89Po4tlsQ+os2hXJRbXqSltfApsqNDMqsX/qtDJj/hulN6aDdbny5luz585WDdm4l9E8xXdX59msV1ne6u80uRkZf2oVYi+IKuw9q7C+gn5GVIgMdBr78Abk+/ahQL9lHzk+vbg/Hot
yagqtrDb+RMWOXWBg9znut9hjUpWj4Wvn/ibcPEHVrTvp8flR30/mWZj1jZj5jM+d92cqwr6P1RnWsN+1B4lQ/IV87Ho+zL+nslv0seLtjA1y4dtfO9sL2UrLlpvfc1OQ1HQdGBq5mj8udDPz085gU22IoySPEbG
5crKWZIyihZ3IYJTeYXzyC/x5S+Xep/MXObQXqbNeu6fcYeeGES7kH2hB9YkGMe/zFyK/f/L/YHpbCEbHC7Mb3TAkIIeDl5eOv1cI3mhZo6TXzHlgd1EHcAbO41yPdIceWv+f34Soc0R6UYvlm/NQcOOh7X4V3iS
+PvJzmWNVXTOu1rCnDXP9A35V7SO8Gm7z9v1gfk+IJtorLo36Dagi8Ml1ZpyQ4MMkZUR47+rmB1Shn6qeo5ozUOlYtsIuXuw9NTALyPGqcvR+CCNy5V16FcH/wBJs3/f1XFlNjiuqIiWfK28UVrph2R5X346Nsqr
a1zqmu5+zvw1YY7ixXdjJJgal2hTd2eaPX/uYHEUSRzHwiPLnvZwWY27eP/31F/+Nt7Hz9gAHwQRVLGPBJLYFX7rXYdkbEv4OfeSioOeTnf1mjAV9BizaehyxuoR8Bc3PP7SwTf9li7zNznjYUYTNiij9nboC6Lp
i8+ItCWXjv6EooHIPLod1hnO0iVj5FFx76/H/Mk37/CnuZIeq1+v0vAqYNwPYDzgjdTDro60D9kvZQS6Pz7IysyU37FLTn3sKKFLxii2jSsj2te3Z0x+KnQbbWya58zKtkajrIJWTzNrraTuN68VxndPOoy9OcbM
/EnrkDLemFnn+pzYhqTViNWZ5bC3uOkPJxqG2Ijuek29Xd7PPL3w7uDRepVJKemkB7rbcGWUXOLIIw6fSsopBCjWvjFvRDXWSv51YJWqbSVm/FkrtLQb7eWSMcqq/PRjnjYKyZ8MbbImMX0IpT2Jbnu0RIpecPDM
Ed9W8bFQevpzTcXhbfm8la7Kj9zelC95+OKh+PuiLWikPRXkvXjbiTPeHVtnSWVOP/PnkhksHuR05IyS/MEO8v78fSRRz39+gqqpMYxvaSg0iZy1s71UcCpXFHP7h9bZpuVB38qflPQ4zk3GeKEByTy6a0ZfWF70
JuufnzAyh9ppX3D1YC2uODpNNfNZZplPBsxJe20LhlI7qrbOWmiQecvXan/m78gZb8jLHjxdpk4ubeSsxqd+wN8fbS2TEcmILuumwjrF2iV98iDdnTFe+gNfcsb3pLfqQzXVnLLDjmaIf1fe218Gr5smWjetzBub
4tkP8zl984any5Ex3tDYp+/X7v/M9ybRyUXzKi+f05tP1ndExixLGd9kbNpHuWnPO9glxQvfX7QFqZtrcy5/e8W/86NJd2imuUY/qD3X6hxoYnMebJyYI4b97KMdjlcZUyF3Jxct9N2cUHZovcaGPrJCF486nw/C
M39HznhhDZj61YExxoPHyiy7SH3HE8n2F7gjZ7xMsydd0Uw+Ib9C+p+2UFyV0mDXYBjNgU9b75r3xttXn9HHhsZgdOO8sj3SuBv7mSZjzO/In+h00m4veuPOGCfeYUy0n4oY9IP1obvpFWM8qTWP4EVHURBGqyZt
rYZoWsvBGsc/W3xatIEanNHdPj9xT4oxmUrrMGaAaXowRx2rqToqc6mfT8YoOrf408g63/SnEW08HjzkZU1mjopHb6XDWDbHrFe+FVxe7lWzb4k+dsYZDzl7kzF+ob2RBh+059Qx7YrF0YTEng7vtuQJyyFHV/a3
5b+JpSMeduHNEV5my2MZy8udkl4Y48GfVbx437m//nV6XH7kcxoCrVI30l/95I1icYw8c2pej0jmEX+VRxijmf5w0m/E5/ToNyNt7hir8OAfdj19l/Hg/4inIlQqGpxapI2K0OubIf2g5uKKLrTjNe9twSfvvSLe
2G3LTdcAdukw7NH27Rvty5gzfy6xL15aKcRvS/iA2ESO/hPyd3lg9t+5yj4O3x/2t8nfg7TIN0eKT9VHUuhhHizAZ99a8I3OE/aVy/Lu1WvRxmV+fxmhXvYHTK9DWdc6WPslqcPTkq4wRjv9kT65R/yYzuUnK5vi
CxZPOYq9lmhVhGqZdMxWNXBFa7LdciQ7lz/4y0J+0gau6O1zXrwxOskYfnyMcsP+fxdsYbLLD/gu32wvdnNmgAHmToXUY8QYIj5LyGOwlTEyY6ykTYIaJj8oTt7zU0hjJJCzMbxzID5oOcFeziIPMEaz70+ZDnj8
xMFn8pikpsRzXEbvcLRQ8xuE7+9MVKR4nBalJi4tZrJ2fZ2ifdX4R7yR/FQpPletNFKVTj6pdSOiWL0wR5oRL5nXlXRijNxebnFGuUtazcFbQktvlFLLeCQIUz8IRw7PP88RU9a7pJ4OuxHFyukvWqfux/Fv9hCZ
c2We/YD3wK36gIYLtaLFkMHM0V+MYt5IjDEqIo9gR8P2Qa6/mBFGB5O1ukNfg0qbmT826LvDaY/mpS49xEQawoEP3sxz5JP2Z8/80WX3o5RavDIPLVIkJxrrGWN8JZMXPKm7a5zxPelcfipSnlUZtHl561lCAtz9
7J1cDLi8TfBCOFiGjknaVpKWJ2UQmQmbFkEcerqb/s8y2kmb1Mc542hlZCSZM+6Ni99Jf/nbeLc449sJjDEq8teO4DOxO1Kmuk3O2+5Txs8qFkf8sZiOvxine8vO997xWYbJI2xDp0ge92z/v8jfZICHNfrpsy7a
uPQw8Tc+zg7SJoS5aMGb632H3RzxsIKvj7vij57Q4iV2Meg/P821/U/yohe8x+5zNWkHztjKfU/V23gPWRk5HfeRPj/JbCAeTEevr7lLS/5y4NfC0aVfXs7sX9ieFc2JpG+QryoYImbQKr464qXD669lUNSchxSj
Kvm7yRkPO2mOOoI/+KgedQo9/eHmeuknx+U9/aTx5SfgQdXqZZseqeCLzVRTfAn4f8uDbNa75h485kANvug7RrbmK/uxPj9h3ttAObnpXdmRIp6isiZ8MRtJ2zFn8Q79YcVqrjdwnxVfHXVcmT7oTXP34pEd7f33
C6yMx/zd+MKyr6ryYI0t+aZ9KBiH3/RUPcd7xMo4XyejmfQ98WWa/pjHner2sM9qrobJ/s+Dh+H9ee+97Y9syKE08KGS2igqmuqC97EkctJK5fkJdAmUEF+4nHTyoWIeDqWOgCm1BUgtgoZTXq9YqK7t1zh7u6yu
Hv4irUDmQNnbKt+GG2scn+hvESpzJeUvRuJ8gWqf1ouJG2LCR08iz1TaOVBoTS8nF12qNPvHSLGvM2Zv0MXIUV3s5fg7x9P7nFE4gz3OUwcLg4zFYs0KZ+U1h518kmQ/+vyDaJmik4yXv4iO+rK7jPd/iCbyiT0k
x3S3PsAGXZBYqOSFihkPXJEot8K4xtZHT/cc83IH7wEr47QNHr5FeYWxSQuT0U7GuXZAPfgGT6+b9HK/jH/7eDVj6B2kKO1WH1qEPC2r1nOMlPq90Mo+3p6NV2Wj/dqQcTNQYmNTHvquseCMHcpYB390rUTrHDnZ
QdAbrSRi9KvatRacUd2EZIar+poP3/THfNzKOHXV/lLqM3Y+yztXQvg3eeuMviHSEhul6LAPbLV9r/yUJl8z2utBa7E9++H70AFpGHKoxnzJ/54+MdUOa4Lxg/MnITPmiuiFTHYr4yP5k9Kd7VcWu5BAy15P8Vg5
rD7u8UDFfqsPs/DH0k/Th+6ntxnjbbyAGU8FsEGgtBGbKxj0u6stMnusuYQAxhhMwT2YpltPiuJp9ZKS3/pI1ZuWyBtc09x40Z/M0efhmDMZteXH3X/yWKMyJwh3OXqkHr4VNiqtZd4po9GZv4+64WUpnir678Wb
O8Pzmi2OqkVQ7RTNbV/V1+kaY7yfPxnJxUIvs2w6eoHzp4xiMhfs/qxTbxE5fWo1/85+JvBD2iBrQi3GYhR35Klag622NopHEtkfKlSOgVMHR3h/qz6Oexkvkmin55rAxJO1P/k88EdJt/YyXku/a3z5CXhh+OoH
GF9prePfDt0+99ybq7miPWeQvQQdOProhsYdIIv4JtLiV7dN1V7ZdxU9AxrzZezQOceJZrnvVzv4vEzOeNTQuIXZQ0TUYxyOGb1jLqJNPInJKx3ygDR3SL7DH+GT9XH0VK3N+kr7G0Nmje+hWXcyxps+QVf2LwhD
kOckJtAx3oGsHcrP4mE4Xt6zx9fTX6TdH/NHq9peV+9oMSFHZ3OuptqWKeaLw8/RjJyNxs/DJAxb0Rc6C4g8GV98nK+UV0aTG6PqHHmPETOEX81oF9P/7xDJ+XPpgfaiTAsRjBGlNKkEGpOLZr/UStpH7bSrYF8j
eANPWJ1Y5C++FB4jNod95eZsP4n0K/FFnVuBD9kU28wRVrzBz6Q09xscLPyydij+p3MXlPzlIWvXR/sbMUPXKKJNzcYZWkqm2Y/8gbVFt5dvtKNFZp7/Ou3UuLVKMJNwO7HIXomnKuWaq/SX/EbKLuPVwVfruJNx
j98pSbRxeWJGDT2wI/EKC4c9R2d2H2GVMx7yfOvdwj2WXtnLBlgEOlxIjrZfofnV7jeKmBq1812hOUfoYaCMfbRY2/AjjNLAd0xpaOrGPj/hNw0tJaN9XWoAd/cyXu5k3PM3V35Ecse4YJzmXkYRh31BmmY7kai7
Vt7PJ8bT1JcMOCN+7pIx+af3659yz6DYqpoj4cS5++za+Mefl3GrLpOsWFzzB56S0C+A+mAlmIZKkZOs1d7U9f+9/vK38T5uZURrt2gbhvouGNshvkCtYTO9N9oC1FIwJvcQo+keE6iiqJaKZ6swdxffWIE2058h
Ce+40Hqkp0is+ysW/xvlfUf5viuepWhB4I2DeWMFb4zQySK6XXktytd4wuGSWAvFmn/wS32j8md9HL3i9WHfgqS5l/FBe9rH5Ec7NGIw3UDboPhv4IrEG6Om+BulFIMrO599bl0XXarTTUNr47XYRH479lb+xOfh
tFeCy6v337az6P2PpxnJcPsl7e/34Rk6tUU1sn6UXFTRLdVUc85ggnQOYygO/HGAG9JZG41ZYh5p2KGN0v2ltV/Pn2ihsqf/bE+9rLLIPY/Fi/xk+mt4u69qRS8sLfgCBatCzykYu+74ZrD/Lg9D6aD9n/nO39XD
Zfx7sTHy/gWJXHwY3Pwh1t770vvlR5qPh9aO8VrXEoPb8rAQBHijdvH5qVhbQqtgjLpkGsXPVz+vpHtxxNn/6lK7/nD6kvairQ/G+9HoPAzXKhEcW7XNtpQecsgtUtxP98icIexDmMsez1zaiHge3bBMPJp+SH/j
aKg0y1We62rk+Y9jgWMW7LpnJXuL+USNzLNfoKipjWPDhdvrEcLIZf4TKR+le3H+2I38vU6yWnYjZtGttMcz/4if6a30sfqIxgZdu0vGQ+NwTcc+aiud/UsoRVpJHJl9LF3P3TfraWF/Cw7ayebVzWg1skIta+5X
8ne2H+HhJF4Uxv/b9qzRFskngnljGlyIkc4/CU+8Uek3ZRpxCTTdjX65MYKJLJPsktKHTzfbi4jrYaHJPOCPfqkyU1+Lp//J9Bvw3sMYH80fVC9jFZSqAMYYwB5pDyMGHRd1Umf+V4/hPZr+j3iOLLe9JaitJVTM
v4UiDHwsFuCb+ZO+9U/P76aYp97Q8VTdm2Ya5klijonmRonVvu9+p7+EwjurG8+csgqb2YPV0Lr27m/7lfm7nsQv0N1YG3k/3sfSwruXtFddjd76Rg2ktdZ7wf+qby2BQcZSoN9nKAyjdQ6pKnswBgY5G95Zsx/J
34/Ec6Rnkv4KGYIvYIxyUG4N+R6+xYw+lr+5QeGPxmv+CB6pPz7W4l0cNUXvVXHOgitGcEWVMu2neWvU/ob1+xietiFo70bzyqsaXKPtKi66UC2Z5VumDemXjPHHlveP4VEsVJDv6mtLFqlmngMD88bGsVDn7Cz7
NawlF/qWeF1VZj5H/jjNkK/qe9c/P1xeifUlVsbDSPlz6gO5BqvLzUcLTStW75vBf737XKA221YbRFtVrtB3KRpf8oWOB/CoEu3wdPiz+XudxNqu30k1vz5/5M2p0URpj9doNMcOigxt6HMDu6YVhJ7JZtrIftQq
n9fobtgPf057+c14L4yR9OdHzmV8O9Gx6VY9P41SfXJjyz204XIJymX9MeVq+67y++d4pHfpbLPmpUTTmh3O5CurrL+kvGB6ypBXfGU/ePBGmi0z7Xw5jz6y49FZjHFj5tjp57apoqC5bjcOpvpk/hbez8Xr1IrS
wIQPvbZkDF8GTSyS92mnmHhp5KRjiKT/Nt+qK6OSgXJcOwf+B5T3b+H5zW5k9HDF0vmWjc5dyOmNOJI/uLw3E+2+9xYK55ZDC1A+TZYBXH+P/P0hPGKM3qcxYgplRFDFODzvbwyDvL1Vb9c541/K38/Bo1BvEVw7
0vlboCa2V/JCrZ0Y4mUsSPKrVBR5hfxtKDKvbxG321TIq+Ja/NivS78PT6sN7TSjnZrRUjQOvB38kGI+Bpuen8AWldXN+WHBLl3QwziV7/lUfG3+vise+QcqiiIHDksWRz3IrqgbxISRj/xSla4Sf/exrV5fnL+F
9z6883MZH2WM9/OXjR3aY4hK0OaNz/wZTLJBX4kN8Tbe+9P/DI/Oc8gbxq/QcnfOlfLBuN57+gHlLco7hSE50MrrW9GQyRUqFPJLDVcl883Lu/D+Hp7d1EZ7Eh2uhP+hbKWWt97a6Mp0Y4074VEc1S/xmvpF8ruR
FJ98E6CylmLRf91Xhiv9huW9g6dAGZVyRdNs+4f8Qb4TXgTLUcbQGeimmFgr1O6AT/qZlpdd49Mh7sVk+1Hl/Ut4dJ5lMux184a1UGuy9zhDFslUea30Q1b49+Xv1+JFcmUwFWx8C2jRmrYhc+hsu2lrk3bKbv7+
vu0fVd6vwhNv2cAfxKMNx7VWc7/hu2xVP6K8vxTvGmP8TvlbeAtv4S28hbfwFt7CW3gLb+EtvIX37/DOOGN7v1/qTyvvwlt4C2/hLbyFt/AW3sJbeAtv4S28R9N9xvjv87fwFt7CW3gLb+EtvIW38Bbewlt4C+/f
4R04Y/iIlfE13telhbfwFt7CW3gLb+EtvIW38Bbewlt4/xbvUcb4W8q78Bbewlt4C2/hLbyFt/AW3sJbeAvv0SSMUfA+a2V8Sd+3vAtv4S28hbfwFt7CW3gLb+EtvIW38B7HO7MyvjpjQ9EhBi4kvtR+PT+9/PwV
18JbeAtv4S28hbfwFt7CW3gLb+EtvH+Mx7xPOOA9xnjOL5Wmyw++0keu56ePPbfwFt7CW3gLb+EtvIW38Bbewlt4C++v4THre34SDviwlfENxviNy7vwFt7C+zd4GVfy9XDR38q3yd/Cu38VvqTmMv/0vfK38Bbe
wlt4C2/hLbw/h8e87z2MkeyNn7cy/hr5LbyFt/DeusAVXfGbd7bZ6rQduLp3GGOCJy6Sf1l5fxse15IzLriCGsTlqrNOc735b5C/hbfwFt7CW3gLb+H9WbxXjPHF//QzVsZvXN6Ft/AW3t/FY6uUCeAZM57WlmUc
sVY7pXgUEd6R34v9Lcv7m/CYzbvmfUCtqayL1JxuW98s6i27PO/7HeVdeAtv4S28hbfwFt51vHdbGV8YI/C+wMr4w+W38Bbe78ErV3xH32ZylZ+rwKv8c33xWZyoiXlH9n0bqhk/x5GytW3z0VUb2NOxf6C8eebg
7Yvw3ucHW9mX9j14RSRx64kb758en1N+Zz6fN2rl8p568eYy8S5r8FYub7zZDR/CptTzk97MnAOMwZxQgvbNdTzTMA+8YDwo4yv1+9J+6vSCfav2D5I5lfdeLV/KqR7eepRVnvk75umydNd6TH4l75nLmb/L0u2/
PVqzl+V991rLg/Xx+HXpdf66vPdGk4d81mf+Xnp8OXvictx5ow2c5e9+671852U9ncvvWKf3W8flVa60l/2t98p47NdXes9F/m6NAW/13ykNzt+tOvhAi/yB8+XCW3j/N7ybjPH56SusjN+uvAtv4S28axdxgwT9
39puu9um72jyFlwvTX5040nbnAfv6/xkoSdZdzjzWAwGjLDo7LQnxgj+seElbGscJmrtiXe8R8+QezfymcR7G8Yr7Qhy0Of5xWWhkWpz0fewhe2AcAU16LChvN0Zr4A+CH9H4n8NlRT3GsimIN/yWRzb4+h+CiZ2
/v7nJ0usyiEHlfIw30cyEo/PPOVXncN7Sa/0/JmBqX3g7zQ+geWiU4xHWp8DVvPVVpe84nfJPRt5jiKXETXYvWiqnZidy/g9HnNJT0B+G+Tj8cQIao7r5ZwzHhijVn6jvFYpnVOc+4EcVOdJIiS/d9SmI10V+TEn
ORTIROGvkb1iL9sza96uekOywZNa8kDt1Z3XLpcBdarCBillrynPkF8/q1NvG56mNqhZb26EzHnSzrJUO+RTnNRKnHVD3tZ+yk9zHhqeMm7nBpXzQa20UP0xEsmr0Pu4JRa0LefGLHV3wbK+P/Vxqi/rgCj98aU9
USukEiOf0Q3O7925+A+OL50kTG3E91mKV20f/wZui3Sn47Fhz+upFoEXuJ9p9nymdqtmPZbje1A7yeN7lN7vPZvflGydEuWnWH5XezY/XdFOtkNeFbfewG2HcteOT3nLeIXvJ996+negt2tpBad2Rp/o3Z7KQViz
N/Ib+Dl8G9AahK9e6R/clzGOQEr1ULZN+jTaH9oY9896eCONIpS/zDJpsw4iWhX1n4DcHyVAfZtGs+4947ZTTZEEMI5jhGpsD7jWfxvXAeQx6yCc1UGkumOtUPYbtJcn//n8tvAW3sL7CrxPWBlfGOMPKu/CW3gL
7xIvE+/QysTzA1ihh2hjWfc910hFT2LrIJ26o+v0WIz0+fwE3W1yzZNeU6EP0RuSi3Lr7uOowBxJB3LD37AQXS0vaZDJku4jfq5mu5s0UR5ng0ma9HGUdupS+/tkbZ81UhOtsolGOn0TTw1lNvAZcJwA/lGR+4g8
JJHA1RxYlTYL1tCsYasc6cohqC2qCFVW7ukKwiD5gSsU1nDHFvSwZ6hUJ2owC/cmg8UYLv84zyDXH/iRofjZhuJjmwDdrkGtbqpeKRF/Wm0GVEHF2jnbPy8ZI/h+3YhicpbPMNSWNu2KRdapzQR7peaOV5H6hZ5a
gmR4l0QBK92IY3A7et0uSH5Zk4Yq2Z5Zo9KqwXyBWhNruKyBD+NNMlRqf/uMYdRQVwp5dmB0A1mhO+1W9/0aVuuonO/cdogbVB2tdmmKj1dAvLJDU+7AX3AXuOXWUX9nUtrxdADJrC+yRzEC2gjqHPXl0baV4zpV
7WaOveoblRfZmrb6L/D7eXB8YT5MefQeZfTmZstHea3kVmuVPS2KENNqzF/Ia31DPZ49AY6MRs73bLMWLa3fKKOG0VfPB+NaNdGAVuEJixaVeFSTkYrWMbpBPTiqiazStfpQZSubp1UL4yezlTJiHAz6rJ66RqZP
trXEIwe4nI66msF4ZrvSx6j8ikbVamnVoZ7WjmiELTaBhXVUe9Jnz57yx6+3aHOa1goC91Baa+HVhS0pa2Y7Q6vqPKpuzBtlBQ8SsJu1zjDe9TEgbzRGBdsggcrreMe6DsT4lcdIYKU45/mTWjbGYHRE7zDoRq+Y
45e2v4W38Bbe38Z7gDE+P32FlfGblHfhLbyFd3kJY/SmOtG9pwZOmpqJkzFOf6eT/yRpIvwd6VpmKlOatVtmjLJKPf2ciNkFhVT1K/1X9A3vWE8THfGRcgljtGRhYZjyWr+6l6BauS0xoxkv5WcJdHc2Elr7/KSh
5bnqyPJVXXPgCQZcZUpoI93WaOi88hxxtKSIQSqPAkGr27aE7/Ouk83yRgceiLtysGpTfdcRwQXj1gOYJL53rgd7zI1xxB6CJYsZKIIBvTIU79pMtqh5HHeJbBrIa3GZbQUg/UA6L5fSeavIHXKpnVVuEsZdfk6Z
rCPbW+IlZ9SJuCEkkixppYOYjQq6H98QPFmsuf3d0xqldbD2TFz2JAfiScQ6PdvQDp6bjCftsVA1stwt6fqcbxAN4gzciiyku5H+bXbtWOzaxSRtpC5dBF8driL30c7iBXB59AQFCUdijGr+HTXdFTNFsgIxY+yo
I2l5CQyB1j7AZyA7YugbODrVg0hl379bjdvoveC6aGvWtfm0lLpSYZB7H6LqhmnQbC8WWrxGjqldkeVI06rF7uOt+V+0Z33qdX9+fBG2Z6m8k7ff5IzHBLYGiQQD5hg8MYtuDFnQOLlDeYMm3kY1Sasj1MK66feQ
92QT6qnNemqyPkQjG7cUpW4vA0n+hPl38hcQ/wGUr0zGeOoflmSeeNRo7DVQNb50+ZH86bGNjVZlGlpBlfbsyB5ITw+d3nhc2nlC96dcAoF9HQY4IPjynj8NLW1TzBkN5ZD4Mhgcry3dXjOZEuCy4llly+xvVEbt
+4YP+8bTktBXokqcPztH2K9ufwtv4S28v4039yN+3Rkb37y8C2/hLbzL68QYof+dc8bCnDGQxkD+W8RG2PsuQxsD7yFt4h5jnPoGaffkPyj68W4NK9Cjd01aqUF6GlnDHizvDc4I5om8hBxaVPiMUK+TVwGqE/Ry
uWfmFUwK+r1O7NNHvmqVyvJiWrSFjHwhxy3UoHERR6N/G1Ad9H3oUWAbUImcZp9e6H2QX2B7A/2N/D6TAxkG10p213ajvNsZ4yjvwR8Zox5QPGk1P7Itlvjq/EaNqcdZp5g7dfKRDKRlRz0VbtN1UYl2GPo4bQQR
v0E/Vc2e4puhIhsjeRdZZwfjA8OxqLZ6qkfF9ySiX6jnFMyZX6pRfqv0Htq/QDq9J36b2Od4U5M52Ix8NbYl3a7RV4zxpbyTM3YfIGPWOzlSq8Zv4GHMmdstxohvtS/WEB9kLXlTU0JgIloNMPIaCtelkTpFHZeA
fyDbSPZx1CkxRv+aMYKfv8kZmTEyKjhOdmecPyRaY2ANXFEreX4iLgLOP98xOWPB88EOm5wK5LNLPpo+bNymlMsuOrQaWrmYsFV6HfUPKz6x93a8kZ8u3c0+2tcuf7IN3R1f2Ppnydvbot2ijdEZz94ENN9ACVWH
2jdgv263s077G9WUM01rflu1itiMQhtTQ7F+AT65QQTcsgDow1GImymqbAr9sJA9njwpQ948WuiUouKejtdX9H0Daaota232mmg0AuBbZTzqvYdMjhRiz31Zb7IDfQFMFTlEg+K1B3JSzsgdcmozKljzikolj2X0
MQ3ONvUkjCC0soMWRHwarTGGimGl2jNPCNrDrTEsckspprlzTwJ2i0fueogWXTVM/42dl0/vjM7rdmSN79pp9HLOHwYXMDYaAdAHvGcLftHW7GyUR10MTND/jAqDZRDBD8/aKvpvJW5PvcQUl17VgSNLLfUazBEY
QUPaovI0ns46sJRTvD9YNT29/938tvAW3sL7Grx3+aWe/CO+6IyNXyC/hbfwfgPeDSsj9DFvoiV9VRSGycugbTXt2d4I7Zc548nPVJ47WBnpHl4Bf7G08Stonw+jqm2P14zxBHfN/NwvzS3G6EnPIdtEcHt5A2tW
lvxA6S6v8knrcmA+llb7LXkv8oindtYEnWtrUA+hUOpBF/Sh8XKZjT4d7eOD1kt6lbW0o3BLL5FFLxO0SfG3hDiIbzEbO3BGsYNBgH3b+QCPvs5Yo/O0apTpJUaaoIc2HPfx2RSdlPedGX2Zu+3ACXFX2m2AKFdg
Nmid7FUszCv7ltWwe2SigRxQfUAbZY34NWfUFP0GtVXcjHrhNK0g4Emz6+0mgmsJG58t4Wr7u2tlDGRn0iqd2uXOjuiNaM/gjMqL9+g5Z0Rt+GIU6kOkmPd8a4+WuKFWzbEu9/pFnXby+XO8q+4aZ3wPY0R7Ucj5
2Xor+kWxm5doT5ntxNs2TnIt1BHYQmlRK2SnbOSfSveoett+DsbZ2MqoZOfn1X260mrAub3TRWdTZnvuZ1JI+K6CTyV7sR/t6iWtkdYctmfZ71x4HaLOFRZD3BFyslNOUVo486Uo9ivBYAa/8admztt5PAASGFA6
SZHrH/VTjfUSd4nWJGh80fs9Ul/Uw4iHUV3h16btLj9IK6NtqUCykNZrySJNoteTNZmhPK1YBPIUoDZK+SOWL/nj/cjTv72A027MOO3ut2oj+mEhvin+oL5iFBXfW9Bi8edES8VgQIyaR9Bh+km/4nKQfwDvmKZe
38gfgiz5u51Vi985+Y0HiWTD/LrN/NFqgOL1OrqDdpBS6fq+toRR2m5cOxy9KlNvovU/lsC+/lSQU4taxDcY3zv1t1k8ZoUuY6wd3A+a+A+rbuLOe0USGFcr+/i2a2sYP3i+XHgL7/+Jd2CM5/PR58/Y+JblXXgL
b+FdXpeMUU3/sOKaqbxwfbYGbqySvTLQBGjnzG4lOWOMHH/PkcZQpn1rt9+xXcw5suiwEjXtji6bqgZ7Hb4VO6WzPvQGZ5z3ipeeIl1WWW3MvFOlbUBvIt9Sjl8yd9Nt6nw5/W4iW6HSliKcUMmDuuMfCy3ZafI/
ox1BjXW5TrzgyBjBZimOrNvGbotVDRpwIHuUj3yKJUlHeNYFZ3zFGFGvjq1ZxBjNbgFJzBjJ38y5OjmjY400K7srvahduusWYyTftnrOGIEnnFHvnBH8Sm/58iSOs+sWYyR/W7Iyknsi51yf+fz5Yis0VEuxdrZb
jNHbIbYjkuUj/soTu9mmKbaJD+mMMfoDY5T4PlUPG5zkOU/OqF4443sYo+RvckayaBPlqdOr9dpeRn6UdfLIknQz3s7t8YB7pCnOTT/SmzskvUcPdede4g+NL7wDEGw02QZpZLVxO0YvYxs/J/R1to4BDxXr71tE
2f+YXadnztB2DbNBb4VXNrapF/L3Ju/rM9lUGgvABj1zxrgviuOv4IzMNPNcV2kUQYbs46dTZCLqI4Ax0Z7ieLP18vqNoZUieoPikm5sISzazp7KUXtof6Pz3JLzrk1ZDBwqkK2ZjKhgg/u7A/c99Kx9rSVwjCvq
Uac9zW2Oz9kre3vHoOxA9GSjZwns469C/3bsayrRezLHH2LOqF7WlizNA2SHdxkjfDwwclQsrZUZiZHKnN0XzePgTG76txvTeFfz+2KbXbm+1Xy58Bbe/xXvg9FvaP/M562Mv0B+C2/h/Qa8S84oug+0IdOgBnvo
D3pqYxWXrHHTOr4jLfD5afd5OnJGWu320Bhs9GcjiA/QJApFfgkOWlrad8eoCFiKDKM4fud9bfIBK+OpbFJe0i07mRZ29yuMa5lzA+IKnXGwj6DfeZEjRzkXkalQo4lbGBZ07OQfNsvrrR0GPAX5lQf3PY4FvEOF
EXW0oYcWmi2eFN5kNk2emsoVtjFqYowHf8wMjqhMc1AEZbSdf6+0O4m1fjX5JkeXAVMqu55rhq4qoDhiXxhsdeIYI8qCXe1eexyplrxSobA64ibsjYlsbWmfBMCN8vRdpd1zkfwnz/YykldcIr9DVxmD/HRlp5Q+
WVoy2EHn919Yvg7t7xZn9ABKxpDUJmDeonCBzaLEYwsmU7zGTfTTfsYZySswE2MkFgvW10+1UnVHrWyhRYe62bS3eb5htsIA5gP+EdkzNZxxRqOLiiRfT9GcKAyool2sIlbkz1F7oByIreeFMb7w1TesjOKX2mkv
oybPZakQsiFatvkXkyn3z09RhxQKWpWG7MBIdFJs+7ozI/P6AMpVvMEcztZmXOw4ifk8yLUNheaHPqGN9L/H4t5K3dI6RaO9o8TftotEUVtURr4DS/DtSD07YzTk3zlbb2I+ZdB6ncR1IVZHEXRoxNhfxNWZyS5/
YIwTgSyAqA/hw2XGPNVooxVdfpzWvsiv0lIrcuGlnb66OFYy7VdF/tin/cQZA2rEiyV6+u+S92bBHX2PvEMRdJTjccrT2HdijEn4IFvmhLGXwPGylANv25uK+JZm163h3F2rp50xsr8Fbk/6pSVb5oxqxvSlNSbc
v6HXmT3+FPcI2jeNQbCa5HYPBLuxvZZ2SZouvH3uayVn2r0Odktq1e5txvjj5suFt/D+n3hXGSONB5+3Mn7L8i68hbfwLq9rjFFToASj9YzXAr02EY+w6hSzY1jDMQY32uwyFQVhjOAi4EOOWZhSaddCDO8pe5b4
9+R5BUZhNrACeXq6hLphy/Rmuu0Vd2CMM3/3rIxyHn304DAUcXGOYxmjHpiip8j1nSMqFmIZEy/N+H8WogB1MRQIEPk/2dDIHqh5rx30OIqgSebSfSePBr0E41F4SNF+IboIU2VormXuScwvnPEQ/SZstKPTe62h
RbrdX1U0MCjziuqX2DZ4k+k2b+TntlskC0qEt5K3Ibip0xyHls50EHsu2M+ul1KwDnASlMvR+h/Sbh+VwKXKNsMexXJ+gkS/0eOUG5RGV+i8YHVgzHrL4OLmNH9MfdaTHeJ+FM8bjFEn6LQUAxINku09VHpydaQ9
WeA9UmLcNdgmks4Z4+nECdrhBYa2RzSSBob6QFWSUx7VKrWcffel6YoOxNC0fxCMUUNm7oUxbpXegVJ7TZ/D0O7PodxL/FP8TnwejZ9jgQ5w7IesjLtcTVFsD2XG6cnnlTfxmZ1lgOV1xfJGHSfdZeepkr2l0ubN
m+NBfe0Fennd54p3xheO2WopLm82kWLUQkqOC5nVXKhxnmPTNH7LW3hlMqUXK6P4bNJmvXZmZUyQVju1P27LYFPJUPQX8Uw9hX+yGvWdTj6nmffiiZUx7LZsTZ7ZZNsbrs78PWJl7JMxki+7mvFQO/uu9pON8eQf
a8mJmWJwBfbUCGZ/t/jVVvYW5becrIx1tzJO39vinRX5XffkF87oXlsZDXku2IMEiDOLjTHqk38sZEHdBC3RdXDGsC+1SS8i320jnsV1WhkVxfOaQo5S13bj+NR8BtG7ZqQ71zeYLxfewvu/4n36jI0fVt6Ft/AW
3iXejb2MYE127q6jaDFBW7JphMR2R3W6y+8WGj39paDjBDf4/Icz7zfocBRlX3a2cNRVtnCJ5rvr7aTbeb7D+l0fusz5LStj1Bx5AvQiShRU1oGHob1pM57gzgEoZsdWAse89/s5DqRB0sljllf+r0QHBGsDL4OG
FelkCN6/Jd6dBU9BB1PZhKtBBfdIh8ihRP+89Etlf0zijIrjIGbS6sHVwmmTlNzVDfvygobejiApuvWM3zmj3LBOr8g2duU5igBJTxCXnRrefi6kZ69V3qE54zF6aMdW0U7PMy9ekSx7S7aH/Ivn/sZLzsjtbsag
VWRTUSFRBFbjXDyJl9Y1OAomrskYwQc92zWGfzkJJrF3ocT1vHpuiqV5jtcWnOysqxTDkxoinx+61w50bgWh2+TOolrOGJvVeys8pqD+aA9eOViFOAXav5omj+b1Atqhtp38IU1g6+7gvYwSbZiCoDgUzJor+2Mp
3gjvjSV/gO0dVsGvG19ExoMjwXBkTt5T12UnI9Uv+mJQRsc9aq3i0YWs5Hc8KvliKRblD5FI4/R3rMQGOVaPxDDaVDKnWkGvVmzvJcpfPI9B6EX7Pr6K1kSuBco13o84OIJOYF5Zd3JqDXqYZzvcsZyvxyCyrWUK
VEMNgD5mPFVL8UJ592MQ460ptDd2Y6fQuf5jwagVualTF9LuFBuHWRftgrSZ/Xc7I3j2gei7hwRZCedexvMzGs96l5dTVYUPG1rPmv030HE0kIF2vPMUv1Krp1Gh7afcmIG2SPdAMqpaszPy2dPopI9C8pPYwFwH
A8x49/oXXjnwmjwtkX+m/S28hbfw/h7eG4yR9x992sr4jcq78Bbewru8XjPGs8h5HMVzm+cbsD7rodnb4M94zLz3uJeR/SfZb5HiArrA1p9j/EzOH6+EB8snRzi+i2I36JmvWzm+yhhpvAJjIJcqqKMuO0fn2ZO2
7c7zKjp+cE433rGlz7DFDmPZv3NIno4Xx8Aw5zvH+OL1ejkr+/IpkgH0KzfPDRBtrrP97owzEmPkE9ybnGPCZzP2FwzSdTnO5BbALwP56Z3OLWHPP/JX9EH2w4UzFsEcnfVYwbNn+RM8N8+zOG8dyacZ/UPuVZwT
xecfHJHonW7GNHms/d2wMp7NRuD7ijxcJT7SmJFA0isOdbQyHk8Rzac6LSxB9VJmKu9smRwvxB/Pf9zbJe1K3OudIrFKbJej5Ph7evL56VwzFuZ41naOPoQiV0eYp5avTrbxXX4co4gjCV9pi8yX3KNc8UvHlyJ4
jsrBsV+0p3gz2jrlDB29SPFdOSLUxqR+ZxyyG7G6ZLV/67z3efKjd8EfxyXFfrokMPJHsJ7tX2FfNdKex6vM6yXGUzxVpbrR56dDWKWrihgjKLJOobHvrM0VS27o1FfNnfyd/BeC2qrKp/MxuKzI29AD5UeDpJMt
ds4qPu10OiXZu+dpLMEOf7a6YNiiitwljGCOVrzOvi0Up0fWxB6oXzA2vRlnz1Y6kLus7JTA0Ols0Ke4Z132H9HIQP69vFJzOm1SsRcGCqGtN+TvTI+nfZhVvBebTxKS1bi34+9+4Fp4C2/h/WW8T1sZf1h5F97C
W3ivL2aMz0/MGffdU7Ozs+7TTYJiwF6KU4sjPYxVDHWmtx8Z4x1/rq8or3BGQycb8qtvxig9S3GWx9B+phn/QSTwd+vjAcZ4R37CsxyfsXE4FcSQ12zn6DfmslTfsv3tjJHtFWB9rzkj123wnmzEyZ9OdtfdpmnP
eLF0b+eM8VuW9zfh7XVHjNGh5m5G05H0Eq8UfEKxz+aVVnp5MZdvytLpjdfwLhPY6Kbr3EEnOzjJu5r4UlDj1lMH/2LyHB/skX1cQ7h10dpYNuCt8yiQV/HlL5MlMs22WD6liCRIkXgqctfNzVMZT3hy2g65VYtd
+fZ+b7lEAs3LXs+8jxa380fRgZiPBie5k9ivVdHpllf2qF7Dc8FUHeac8TPa88JbeAvvrethxngcD77ijI1fIr+Ft/B+A55YGZWJ5x6VdHwEncfgso0Sa2LeP+g8NI5MYc91CIndyZzxtr/UV5SXPSct+VMJYzxb
ob+mD5mgKE6ioYiWMyaFlPxf1If4s5J9gg4vaarse6go4g6fXlHflJ+n3DvUjRsu0HmQdCIknUrPZYqfy+Ffa3/CO+KMVuv1mZ8rmYg3xycH7JE75+4s4Cm2L3d9VvOOJCgxd98lgR/ef/8tXra0PuTmqZzXOA9/
Y6vpmkaRwJFA757fcZY/6aM8AtHZhnNP3VkEZ9FfoLU063iUehVx6VnOm3DkOc4Rnu1FHjeK1qyIxQYX59kW78kfn4Vh29zpXV/5jIsEsslafO5lBWQfTzOPBxl9OvhIAXftNc9xOdHV0pmVb42rV+v3IAE6KfaK
BLLKG/WcXQLH/O0Y1dApllQetZ2v7zCXpZNojUTLvh036Hu354W38Bbe9WsyRvI/+LyV8QeUd+EtvIV34+LTC+v017MHvzfrb5zEzD6Y5z56FGHP8rcHTeEPlpeZ3/TZvPTau+ZN+trr8s/m79YlWuYGraprqymy
kFYUqnLorDmehxsv993F289WLH63CHxF/r66vPcvzjP7gG4nf1GptUY+sFee2L1GtTxx8i+tbA/57uX9fXhysqL4LF/zyRav9M51k5m/vTcX4sW7j1H22N+5vYh3cDl56F4/mVJy+drHd/dNVnLqxPPTm5a723Ko
N/yfdxlI+8xX88d/Zd/na57tMrZe8X9+x1V2n/ujBA79bewyuCqBfd9qu6yDUw1U8le5UwcfuH5B/1h4C+934H3AL1X45dedsfGj5bfwFt7CW3gfuyYfnPFCJFZlO3Ge5c+18Bbewlt4C2/hLbzvgXfBGHd/rq86
Y+OblXfhLbyFt/AW3sJbeAtv4S28hbfwFt7jeJ+KfvP89BVWxh8tv4W38Bbewlt4C2/hLbyFt/AW3sL7vXh3GOPz01dYGb9ZeRfewlt4C2/hLbyFt/AW3sJbeAtv4T2O9xEro6HrtPOmSXx+OZv6q66Ft/AW3sJb
eAtv4S28hbfwFt7CW3j/EI+5nvA+4YC3GePz0zln3OiU1uE42fb+6/npI08tvIW38Bbewlt4C2/hLbyFt/AW3sL7m3jE+Z6fnBMO+KiV8X66fT7sx9LCW3gLb+EtvIW38Bbewlt4C2/hLbzvhXdgjE7VFwvkd8nf
wlt4C2/hLbyFt/AW3sJbeAtv4S28f4fnKl30k+7EGk00yWTj33M9P73v/oW38Bbewlt4C2/hLbyFt/AW3sJbeN8cT9PlHV3MHZ2tVo+L9Px0+bfPpIW38Bbewlt4C2/hLbyFt/AW3sJbeD8FL1a6iDPaYb2pn8X7
mnwtvIW38Bbewlt4C2/hLbyFt/AW3sL793jR0/UYY/wN5V14C2/hLbyFt/AW3sJbeAtv4S28hfdoemGMz09fYWV8Sd+zvAtv4S28hbfwFt7CW3gLb+EtvIW38B7He4+V8RG8j6WFt/AW3sJbeAtv4S28hbfwFt7C
W3jfD+8aY/xO+XsEr+cRRi25pBpH6aOVz+F9Nn0aj/PfXNu6ww/p+amnz+fqJX278i68hbfwFt7CW3gLb+EtvIW38L4t3sesjLfxPpvej9dcRzEsipF8Tt6a/jm8++lv4HVPn3ooH1Afraftc3ifSQtv4S28hbfw
Ft7CW3gLb+EtvP8z3n3GeB+vxYqUdQwxZBfBbHJMOtky8iiqtFxzrxt+0i3gxt7y81MdeEUYeNl7c3otXeZPBz9KQN5CbF+B97n0MTyxKRqUJYI79p7V5/Bup4W38Bbewlt4C2/hLbyFt/AW3sK7j/dxK2OOcaRt
lLF1MoXp56fmwHB0c93XUGovNZeBn1MZTRdfVNMVVwqgmPEWajf0qfVmnp/I2NZL8p3thqaAnBKbytl2Zpzabi4o4ljJydM6h1h6jl4rd628nd+7dVWjVmrL26bKVtWWUlCW39KnjTL6WkbZLARTNhRT2VSc37R3
OfWgtq09P23WKPqeaHBuLoetpBaS9jGaWno3UXUdRu6h4D5donNd122DtEYttsVW69aBAHSKP7TlAX4dqmTBGuPSZgrqhd7itpG6M1rKdVZPsbetx6B1tU1kmG0D3jChOuvYz7XntDXTG+7K865oIQ7kIALdAx+Z
rCYp472OusZCCwHzPa6E+PyEOixAbJI/lfD8hqwh76bbpELcTLStmK6HRZmcgig2vfVqU/cXltK323OxPeM9WllD9dC2GodTWtYCjIuhlFy07872MCrh6WJr5ENGcbuN1vkpIQOguFG9WVuMVtRkaykpoSV5vylj
ud21YRuaLp0541EfW0QZtcivoP1C9ooKZ9BmLNU7mmRsXCMab2S59qKiK0DbElpYtMFs/DaSX+h+4GfUU49OcllLaO4dVuT3yG/hLbyFt/AW3sJbeAvv/4VXFF0bJxX4shdXpEvuaZquv5e/jyXt6cojAy/fvCtH
XIHp1sOWs0fz9yhjvIaXQ9qSJiW5VUKCbt0TeAjoiSWGAObmieD5xJ/yUBGmeTt/0P6RTFA5UGlDtqlWM7rqNrutuaDNEM4CRlYiadsqK8ivd+QCJCXZaJrfErT2rvKZNi6M0TTV+bmepzxtjA58FpTQeuGsz0/g
dt3T/fXqRkKuri07HYlQaefdiAX6v8dPCZXqmQf45psSPKc25/j9zRXhwA1ciyWOlsr5NElXz+UHpTW6JjxbQ5gWWT2MgfDYU/Vcfik130tUZjjhvQD0oTQfLJgxniilpg6q56KneypLFsxns9xHmjrH8yVaVOoW
gy+nvyDXNcbiOyQN6uZRyV7snyrU6sh4bJph/tTdjmdd7BWU3rOg6Ktb9X6Zuu2z9nra8cBnfQXLqzZEFKoj0cpECRYZw199F+6HO7PVybetoSF5UFibJWdpK3VYtBcguNrK8MNVn7eisyH7Lli6VrMzOhVMbZCe
8sPn0NGI8XQsjduNqxbdcrhRagNejqMU8Ec3Ng9ybqWuR7JVoRXnUNwIYKnd1c0HM1ueMchlZav4j/enXngLb+EtvIW38Bbewvu3eLnTFR1db+F5Q1ftdP2t/H0Oz1RcORu6jn9PjS4zTP9T+/OEMZI95V1Wxgh6
EIpN7DMJ4uXI/hShDZcQCuWvVLIH5uoyMUuy34Ez2oEHuk0DtRhuQU/GmFSZjLGH+vwUNyjsvg4yKjmQBbqnBtw1IhG6mgEYUefQ7rdoEorRbVOxxzNr5mSM4B/CGXtOU66dEZ0zW1AUc6Yl1bX1QSXV1IbLKtAy
V7ZCvHCAF6KqatsKsQipDxQz5qpJkrqCGVszeUfjEtkCfsm/V9AHyG+EtnXD9d0nf9iCz7kSXu/ZWeKMwointFSNntCK92flmowxWu26UFD8vNkGlpdqqMSntwAKBQYGyVvlRtXgbmxD1UFVrZXbOkrpUG3ebsEm
MK2aUM2zPfqOcocaIjKQwbe6HTo0kydD9VmT8Q00t3rF5TU66egClTVEPN76Wb/F+yGdDZVgtc7S/hro6M1mAfbPEgjaOYeGlcLZEgs4/0C9GEgm7f3Dp0yG3hiMbSmRhZdvzaVTbcfsq+G2M/YygniiKraIh+Qv
4IZg6xn81xfVfYw1g2G3TBZLfgLiQBPUNaaZm8yxl5JG55A/uKp5JQP5tdai9eBryK/YvaheI5ep5eTsyf/4venfj88Lb+EtvIW38Bbewlt43wFPOCN5NN72aZTkEl23GeP3K2/nyxSwkEj6fVWVqAkuu4EvNui0
Zpi3cT6Sv/f7pbJ/Z+hb38rIrRDzMlWl2iy0Y1MG7b8DsSNdOznNvJFsjR7s0faEO1J2OZzjHdPkjANscKOtkgkswI+o5DuwQXC6RGwmgaKU0FuFDp/oHuJRHfy3bs2Sf6kFBWG/1WnVe+GMrxmjxCjdksnEeMeW
i/MOJK/lAj4T0aCKRSlxv1fgXuAFYEIgpagpV8XLM/scasnN5h6VKi7nDXf5oLNpuXujNmN1VxV8IWbxqwX/8cE3lUawvpat9pB1MNtIlGdldEkbuF9SW/JVV5BQfvnotRx2gpL8UmbOOBwAzeYD2VZbiFYspsFa
UJusmy89WruhbkiaymljousoAeUgddQpSBL4Ecoee9Mua7XRXtRRLRoghNDBt0JNrZMRE9lxYlM04KwVHLIb68hvl5hpc1XhuVrJX7m3Nj564KdVYOLVbkTGBxro81Pyl3eZAUJnQfJKmNw0mLJ1H6qPpqcSgxdj
MXoYMXSQvWBICqjfMbmaJ+Ga5pKxs30mQ/wXhNwotGgQQ8i9NUifc+DBySNZOe3uF51zI/tqA2esTt5nq6O2mJAB06yOBtWUStotx1TvvTYdh7kxrn2/8WrhLbyFt/AW3sJbeL8JT85n3zZl7l2boytVuv5u/t6D
9yhjJLy3OOOfyN/X4W2gCZtHzbBH4efx7qfXjPExvDaab74SI/A91VCMKx40qeuciHOBV2jyJfbsP1kAjE8wmeF7ByvxWeebDFgYo/XaRRt8bPjPksFqL2/b6A6vYg3gCVtzuvWWUwOzIY9DIuCbxNZhX+ZMm8/q
5BiXjHEvr5zLYbpqju1FVYlVzCvvYozO0xbCSJ6P+HsldhFK3lyji/Y/FpCTgE+K7wO+sDXmC9FEcD6fwTU07VbUOlHoH8qNar0a4i5kEQ8Fn4p3+4FTDn5zrilVT/ZakK/shqOAPr6YePC23lNWYKUVrA68Jilb
rXqRJFnPUuwl1GgM+Ew0NgqrQmkUsRlHPJiY+eaE/VZwRNC/XIuvHc0DbBik3PE+0gL2t0HCpfSEOp3y0432s6a6pV622bDIIzORmyYIoy5bfOjkkzv+yowbNJFSwm9ncnBg1U13UHY3xwfXcmhozylE5RVyP+xu
ZYwkmdiARa2w7KsxwdLKQgXT1vtfRq3UcoPXHbWISkX+aoNAppUR7TLp4eopQlGxtNEzjrDbDF1p1OpSCR3kEWy0QkQ5O7uX15HDK20F/ZKAUN95Plp4C2/hLbyFt/AW3sL7s3jCGJ+fvsLK+Cfy9xV4ectbgoqJ
K/OVnp+grLt8xRP36/L3keg3zZCPYgvEj6C5KzIFgtXF5MjZ0YN3lEQWv+LJ+65k2g+Hn/sIffR0mzFK/uSECQuFPjoLfsO742zZGQdzMZvilvEqyjd+hTr/WHlP+yQje72WPLcpqmRjbgV0ZLtjzb1Zvyw1r4Mv
oGux+jOfycbloX2LjllOPeX1q9pf1q31rhStD5leVbbujE9VsaGSx2yO2Xb5sr/Rj/59/6izzpuuRXx3nVIpaMjb/tfeufQ2bgMBuGcD/g/EXgoUm1RPSuptu+2hQNNDH1gU8IWkqERYWXItOVmjyH/vDCU7UmJb
tJPNoxhyMYkl6uPM8IHMkqJxc2ifl+Drg0pgSK/bNWMfQsWI45ZoGfHE99p5I3UiJXztiCQKu4HV9XnltTwIMb2g7RdpEASJgOBexbEbpTEeaeQJCMCV6SXc8R0T58tN/NrunuUCanNb/ZSMMpHoAOLOkOPbkr7W
Igp4CEPHaOm5Zi836D4aMr50exCPeMQjHvGIRzzivW5et8qYYj7MCRVmhes9T7DKaKvf43i4iCMS885iim8Jdt9CEfgJ5Fh6mL+OfvsjxkM8leCuWaUl/nHum1W9NMP9dxC54MkgGiJK884XSgjH4Ak+ncRJxvFo
HBkmmdi7gtqdbMNDD9+Pgz+2d0TMUuH+U1yL9Lk51cST+1+C6yezUhUI7orEvLvnO5ETO2BHBPb6p+79NV6LeQIdL3UFj83n5xwfuE4FznD8JHAzrWO14yilMEriNBAuT9tzWfB9yefS72Se0dD1A5G4Dp696qgw
CcO9/4cSiJhLvz3/Sne7ozFJnvnIwzNMXcWTgOMZphDG79jhGilck24ZEFf6m4GX6u6s04wrz3cDiM8TPHV119lIMsYlQzxV1XN5GARuamrr+leQxlKKTkuISNu13bc9PxOPeMQjHvGIRzzivTyvjRgDhRlXuCAe
jKS6n83m2sT3MB+3L/XF9tsGmH3Hd7y9ukLolEwnXiwk5qfWrxczattVRvjjWZpzKiErTzq4P1EFErLCRdIIrvkQUUKcCKG7m4pUZXhsptc+JwXabKvf0yTiEY94xCMe8YhHPOIRj3j/b15qMk8sssCsTXo+/U5L
7aqpHa9dfLRJx+hnEzGO8JTJEb60lrkmUA9TDTlSmNpA14VQXif4bp+P8T5uvrXXcSy93vYlHvGIRzziEY94xCMe8YhHvLfMw+/XOH6V8VB63fYSj3jEIx7xiEc84hGPeMQjHvHsecftS3379hKPeMQjHvGIRzzi
EY94xCMe8WxTP2KcTp5ilfEuvUZ7iUc84hGPeMQjHvGIRzziEY949rxTTr85xDs1EY94xCMe8YhHPOIRj3jEIx7xXhvvLmIM/UB23z7+ivQjHvGIRzziEY94xCMe8YhHPOK9HC8WkCXGjL7rcVdB5CgCL9BB6Cs7
OZ1YleW2st0fO7hmvjEydE6TLW/nfdAsdIPISG4rO57bIx3x9AjPXu6t+UTeqfoNPRpt/dq73rbfRnbtm1nJcFx2/S+z77FH9GcrDUb1s7fXQu7k3a/1oV3H8Y6SduNt7Lkn6S8WWj5texycX06S93gnzVEj43ff
3GE1m33l+eXhDPLQAztnmU1J4D3CWw99coS9zl5LejZsefussJdj9p5Uw1fuz8Q7nmc/B7RlwkNltv1vnPoc80F0Xx7Fu/+015N3vAd1HJTeYdnxRkpZSL+VHc8fkTHIwEYCb3gtHciwJ0/jPVICLzGf7svQSH6s
7HhHPzfKEwcllokGT+8pCbxDpOig3JSU5oqRwOt9erzc8u7XGvUsxRbSoQ5FGHHNU56aLxXvvgEd03RyO1uI5XQyneDPdFYLz3FmdeEFKOeronHbAjPJ/qr1kv2k689NtWAXulzVM+mwH9rr5jMTS83EtcgLIQvN
qrJYs6ZizZVmKyzUXImG3YiaFdXlpU6hALu50iUWWLMbDQ+rpRaNTs/7UCVKJre3WLVkOs3xN7lmoly3aMNZrsoyLy9ZXrJfKyUKdlGl+rwzYGPGH+u60fNdhnR3dpkCVoiiMFXVrRlGgB1gQ2dibR4/H2JQeeOH
ngUbm40dYE7eMP1FqxXeA+eIzqK8uWIinedlXjdL0eTXmi3zy6umRvtkBXdbI0WZst/1vGq0sbceGPygYSO+bVjZ81KvKZG3y0nGJRsbvt80QlX2jB9YVW/boyrPt+7vaTrwun1Vy5bQ1VgvtMqz/O62quZzNKHI
S41dBK99rOYLcO/yNzHXDDSBH/DpfOCif2eLstFfmlnmzr79MZo1Qt7+O/sOrsK/4rqQRQO/wM0F2JTqsnHME18aicVvb2dZfuZzZ1bkkefs8jf7Gcw4u1h3lqKh7Gyg2bvWOXgNLr0bbUH2ZwWmlaVWDfQZ9LQo
4MFSzBvjPtQyr8oaO5Txw4f680e4XL8dH7Czrc7v/ta1hU8+7Bwy2KGW+p9VDqj32FXMAEKfFNtBNOhY73GUVcsUp60Ke/Kgb5f9ftz5sLvS9ufttIUz1CdwVnVTs2qhUStop+1wgUmkXi0W1RJ07OrHOsyoybru
fonWrNl1Ltini1+62j7hJFLrAtreNHzJcgVmDTVj62rF5qu66UqC4bqtFG98LqsbmHmAbqYUM4yxCdAj2G92DrjhdNqTt9PJN/8BPZ/H401mEAA=
"@
#endregion

#region ******** $DesktopMenurtf Compressed Text ********
$DesktopMenurtf = @"
H4sIAAAAAAAEAOy9y5LrOpKuOZeZ3mGPz6CM94udYZ1JD86krYd7QoJkZVpl7p2dubPrtJXVk/WgH6lfoR0OkASIO0gpqAgEbPlSSOQvkFJAn/wHnP/f//P//uevf/9jyX8dfvvHnzGQv/1bXtTFr9O8LNmvv/3+
zz+T3//6t+EPesdfht/+Lc/K8j9/XX7/7Y8/xr/AjezX5bc//+XXhfxp+Ps/5j+yX/6P4U+//3X47//1X8/Hf/763379t/m3+e/DH7///Zf//c/kT/NUZL/k2b9k/5J3ZVP816//15/n//j3P/82Vb/+k+S/PB+/
/m34+/TrP4Yiy379x1+KtoH413/+5Y/81/+T/Dri0/2j6n6lPel/+R/zP/79j9//9sv/nH/75z9+HeljRUUVng+bEm4g7fvL8Pf5l/+N/P7bP375/bdf/u/f//n3Xyb++B9/Gv6g9/xCht9++fuf/+1Pf/xC/vJn
8u90wz9+/+X3v82//TL88q9wPub/9Qeq/QLH+j9+/+f4l/mXfxW2nP/XTP75xwyCM4gvA3SFbf6vv//1r8Nv078YOl5lwin4z1//9mfyBz2v8P/f/v773/7r1//46/zHsPz5L3NH7/uPPKuzit76U5uV7K5/+334
S93XNd5Lfyn7PoNzneVZlvUZ/Sm7rBmzAm9nzbDfBjX2s9+z30eyop3zMeuKvhmeD7ZXVWYL3ZQQvtWQ5d2Ez4U/6x7r70XH/t+2Gdj/rH95tz0rdHVqsgqUq2zGp+f/H3+KIS/UCHqGRw5xzMssd0faP8dWJK+y
wrFNeP88+2ron48G6/eh9x7HGxQFPfH5fOIEMTtGPH/aRyASeJ6Q6NKLeB7U29SjtdntOa/x/MH/EE17sEc9o6DnHeHFM0aqp3kkz5ugSPfKuF62/2aJntrYv9DexPavCI+oF7GfVa/EPrMoPi7eb96mhVjREZlG
1KvzHrZicXtk2zYo8v6F7Sc+ZwW9oD0aWOT9G66K3no+5wH6inqHPr+lfz6x5f1rsX+XREXv9cfLzq56jsVedEAjGFGvx9/EOOQE3tsEbusjUI4Up3xiEfXmfIat5nzB2zRSNsoD4rYv11uuiu/Ri2AaTiXPx3Ws
QWPSe5FeBFvRCHoxFGSMGr2A3njpnYkz6OlJaoFP2kITHfyl0VvoMxmYTENHwvYQUU9PUi3ebvH+xjeCXrPtFxINtIV6ukcK2K840hiccenoVBbjxxvHUxpe4v0z0VOAklFPjoGEBXrBTBaoZ6ExdwS9y1hN0PM7
om6L7+6fz7YdxNxFWKAXz2dfebzs6NbIaSzTsRiLI+5FQO9IYxt7HeJKYUcWkyLoXcZC99STCev5uCbPtEbQuzA7lPSiokA2oHeKf44R9M7wj/LM2v6deIag/pmoSuAv0DORmUdEHpHi8yH8pmSPnFFhMdALoDE3
i2H/vGnMHbF/BxrTMJk3c4HeGZ7y0zPTlpPFQO8ytrpAT2Ex0LswGxal53u8HjT2kv756XnRmDuCXgCNvel4BRYDPR8aM2XGFAoDvQAac0fQuzB79X690JyY4A+aPv2v9i+D4gm9QRdRT/tIXPwCvRGZxjNyf7C6
KnromXoTqxfbvylnLuYxzjwP5hVBz/g40kzJY8bJ6xCBTRin8Ij9W39r1gjbttpYuCL387y2fYFezgmQHYOGLlEv579dEA16Bacxxon6vcVttoh+rfYRJbrPRqzfGOtfRmTGXu5f+ju1lY7FvsxfNeWOXH7jyczY
W4+3QYYKyoyhnjeNaVlM4rLP9BvjM2PPx0Vzr/g2Rr1IwnqRn8dIpYeenYx4vJcovUQv7vW1RDx/3nTnjPb3S0SM7l+F75FjJOiX0Rl4Z+PMItczZeLM+TtKZDMSmRSZ38h+C3Ydzf5laI7N5YdmnCXrQ5x5XnKP
iz1yf9qxlS2WkkfM/WTj46GR6QWcIcamhYlELvMvOYWBXpRPaYqn/DLNnDGHv/re/vnpybwSmCXz8i/fe7yMwjiLoZ4fjZnmjE1wf7HyF+gF0Fj2gX5jrJ7f5/PBv3TQmJvkvtTPEymsyXOINV38UFR7BL3qeN+Z
+KV6NRxjZo+g57GVf4zSy4T4Ff1j7wU1tvBOKTRR2Ab0THuLscPnsUd8X4Iee3/Kj5TaOCBFDDzLqI3496F/fOAaQRHHg4j9tqiOLz0/xpg4HCP2T/vIFgs+XnlFPv4F7OF5/sadtjmZGZnsAv/SOzP2Rv9S7tMx
S6Y++o7+iSziExUWQz/vEudy8y9f/3r4Hd2RxZC/QI9xmEhjK4GJ0TMzhn6em8YsM/jl+Cn+pR+NuSkscH3jV/qXIocV2ZLl8LpPEKeQSPXC9rhIb/aLqLffl52N9PW9RummeksGf/17xPOHv8HbddHF4x72iO+/
jD7TFmdtzPEZ9DHbI/69FciuYixjI+pF723VK7DP/jHH83OIqKd9BPebDXFZ/8alWOL50z2i3dZnS62e60grPD8djoiMyFiW7FX+5akZ/HK8yC+T15uq7GWgsZf2T0sl6E9705g7VxboX77+9TAfr4nGRP4So47C
CJ2/EeNTmigM++dNY5/hX9qoSfKPXNmm49799g00Ru+V/iVjMcyGcVoZMngP4Xgw0v+vii/S6yNipouop30kLn64HnsXBETQC9tjhJiZI+qx3/ItTnjPMRJDnMQIesp9Z2KknqZnkt7af3Iq5jje4/8eUfx2Y9wG
++fayhyVV+hwvOs3gJXJRiE/9pr1lw4W+6L1iMdKH0YKQz8vf0P/IjNjBz/Pi8lsUfIvX/96hGbG6Od5AI25WQz0AmjMzWJe/mBA9Yzn4xzvHaPav3OZrM0fNNGYhsm89E7EIdvb8yH+dr4lvaSX9JLeNXqMyHiW
jPuXZ9xKp395au5VbvK3zvpl3jTmZrFL+ieQCOhF+ZSmGO1fvv71MB+vf2ZsBLaS+AvXS9o4LDAztvmDXjTm5Q9G1zIz6J3gM5WUFL8xjouu1gvwL9lItxR+7fnw3TLpJb2kl/Su0DPRmJvFTviXWr5Bv0esR8ti
A8NoEfO5fsIvE+uOblGo93rJmoOXrEd8Zb3XuMzYdq68j1fmr525DhH11lljlMD6jcYyHkckLDWu/DWLMcoftPCS4l9+gd9o7KtDLyYn5uUPXq0XkBlj31c/bXxOekkv6f0MPZnFYHwOoDF3NPqX5myTKfr4W9f5
ZVoay5ws9oX1Xll8Zb1XDYu96Hg9aSxzshhfL6mjsVkbg/28czmsN6+X9O7Zykjaeq8niMhSPzZWL9Cn/LTxOeklvaT3U/RCM2OX1I8VKAz0/JjM8xP9pF+mMBf2z5vGXt4/l94r672+S8/kRmI81HuNzYxt/IX+
pTeNuflm8xsvIqwL10vK/fOiMTcvBa5vdLLY69ZLhvmUdxmfk17SS3o/Q2+dbxbjU5qih3/pmo0lRe5fXuvn+WTDxHr7Fha7Rb1XC4u9yb+Mix0er22GW3BmDPtnZ7KgzJjBz4ue0RWld8X1Lz37SvWunNEl+Y0X
ZMbi/Eszi915fE56SS/p/RQ9v8yYY72kz6x3KW71Xn1nyzvyUhf4ZRKF8f6VSozMjL3Nv4zkogv8yxA973UGK3Ph9SXNNHacwe9kMVwvGeFTmsiGr288M0PMpXcqeunJmbHL/EGfzNg76r2eyYx9n/E+6SW9pHdX
PU5jWOWD12MbeaWxVmAQZzz4jaejohfmFYb4jWoezBRlvVf6jaczYzfwG63kta3n9KIxN4tJ9V4DfEoTix38wVD+UVSdfmPgM0SsvwzQe9n6xi+r93pksU8Zn5Ne0kt6P0OPs9iMVYUrrD9N8CpKBdYTZDkp28x6
tuKRcpszop/iue0hmtc3etOYm8W4v+pJYy/1G2P1vs5vNOuF5MGkyP1Lkzd5vPqRk8Wwf3Ez+P3WS0oRn0eIFf0rM8cc/cGc/n9VjNd72frGL6z3Gp4Zu8P4nPSSXtL7KXoaGpvwavIlfJKymhIFry+hieiXFZGE
pYncD/WkMTeLcb/Mk8bcLCbpvdJvjMyMvcFvjGarzFaPllJVwaNPZoyzGPcvPWnMzWLG9YjB2SZGYXw9pw+TeZES9u9CYjPpvWN943v11nqMnzY+J72kl/R+hp7AYhmyGJ2/Qfh8McYdkfPG13iJX2auf3pmbpjs
X/rQmH1O/9evv3yl37iymM/6xhNx8y9XPttn59uyYToWw3piuF5Sre56Zn2jz0x478zY83FlNoz+fZzXeM/6xvfq+WbG7jU+J72kl/R+ip5KY24WU/yyU9kS53q6ITPXnA/38yIyYwb/MtQJ9fNXz/mXr/QbDTTm
jkJ9Vr/oYLFtvaQXjblZLLCeqt/6Rn+f8oV+Y6zeO9Y3vlvvmtoWnz7eJ72kl/TuqbeyGIzPATTmZjGv6yNe4W+d898apKrmHFtlYX7oK+vHxq5v9I+yP9hfFQ96A1IVpTGRs3wyYwQpjOD1Kr1pzB0l//KCzBhb
zxniUL7Tv3zP+sb36tlZ7K7js1uPfo2es7yjLRN/6JqsiTS06fTYI2wrcbd6pI2pFg1tooZpr+eD7ce2YrdFPfve4jaf/nokvaQXq+efGbP4ZVGE5b2ezhav89/C118Gxrf4lyfOgOf58yYs0IvlMy2LHfQcNCZE
A4tF11M1r0eM8ilf6TfG6r1jfeO79c5mxu453u/UBHwqcZNIacNIm3p/19CmV30+ZBrz3U/HcKuefe/v8HokvaQXrxfjU5oI4AvqiwYRm1UvYvaZcr3KU9mwC9Zfhp+/8NfjsmwY9xu9aczIYgQda4J6ATTmjoH1
WZ0sRvVi5+6/1798x/rG9+rpWOwTxmdXM/EPa+we9ijjoTmT76PNR1W3l9o/e0bN/pzf4/VIekkvVs/FYl5+Wbg/eBUhhPuhDhb7wutLes2Ic+jF+rXBPqWn33g6M4Z+ozeNHVhM41Ly9Y0nZvBb6qlekBl713rJ
2MzY1/uNsXpxmbGvHp/denYam3vaqpE2kapUr1D2G000ZtrPtNd6vD57f4/XI+klvVi985mxL60ves4PFZVMawSUeFjPeTpeqBd+/sJfj9M5MQ//MigzBnoyje0xas5YdH1WA4vR9Zfnq1q81788kxm7p3+5s9hn
jc+u5mYx4LW+nGljbqVpD/Yo8xDVbcx+qH0/ey/pns/Huvd3eD2SXtKL3VPPYujPnJrBL0eP9ZJB+SzBf7tk3hlf72dbtxkU8XjDSYoAfYgxXO86/zcoM3axf8neLxE+pYnFsH8X1baw1Hs10Ngn1XvdWEyqj38n
v9GpR/IqK9QYkhm7z/js1vPJjIksxu6XM1XseqRsRhfT85/Bz/YiC23rOgKm5zODX3zO7/F6JL2kF6sXmxmT/LILcjCO+qJ9aOT+pc+29vqiftdHDI6bnyde5XpC+jhGub6DPu56Yeep42daifz1UB8ZAuOI75CR
v19GIZoYyjQ3X9xX1puQXde4M5fiFZrdQ2l94wWrHE/5jQVFIB51euvj8NcaGXP0V+F/IQqPh1/H+/7+5XW1Le403puoSfYHXbO13Kp+/bOT4R3PX9JLenfRE1kMxr+TM/jleLq+6IHF0N+KIjN9POhdU680bD8r
i+H1Fr1pzM1iqMeyTXsMPXMCEYGexEdn46ZnypmZSM7AYqs/6EdjbhZ74/pGDY25WQz0AmjMzWI0v3Hd1Yq+2r90s9gdx2e3nt0ZZJkn/ZwsW//8qUrWi9nva89f0kt6d9ELy4wZ1vtFM5ejvmhwZgz9ozg+u6Ze
qSMqeiczY/x43TSmUtgIe5XH+0Gv0GwrRlM+SxuxfyYCM+XSLPzF10uqz7TP2p+F6OSvm65v3FiMvh7+NOaOeLzeNOZmsU/yL6/IjN1vvJfrjIn+IPuJm421MhWdH3aequ58/pJe0ruLHr1e23W1LbIr10vK9V4v
y4kZ9c75jXF7a1gM1/tF+JRctT8Q2YD9kwnsTJxwfWNxyEbZokhNGi7jfqOdxuzUN+KWnMV4vVcDjSFt5SFz6b9kfWNAZgw+L6N8ShOLMb1wn/Lu/qWJxe49Pie9pJf0foqeT2bMeX3E16yX9M6MXeJfvvp6ixE+
pYnF8HhNPuUxyrOuJiSyPRJ45Utcjwj/e0UP/sLrQbrJzERpyvaG9ZLHemLESWH79SAvzIa9xL/0oTGVpwyR9u+Y+zqTGbvnekmXXnxm7DuN90kv6SW9u+pdU/X1JfVFT83gD/YvX3u9RQeL8fWDJ2bwy/zF9Wwc
JtCYO4JeAI25I/qhpsdn6FnJo5nqpHpiwnrJC7Jh3G+0E9Er/UsnizH/0pfG3Cwm+JeRM/jv7l/KLPY543PSS3pJ72fomVlsu97iRVVfg/3L2OtVxl//8hXrJWX2CstbjZzICPcbzdfGzjV6Dm3uh/rnxFYW09fu
WuupGh/XVPsCRjJHXN9oeXyPAm2ZmetwPUhvajHlkXTrEU9FSc87h2WODv8yODN2F7/RqXdBbYv7jM9JL+klvZ+idyYztvmXF+XEDv7lacIKvP7lK9ZLWlkM1zd605ibxXA9ol4jKmr0QmhLiehfetOYIS75An3B
iOslF549EqOFyWwspvXzjDQW4A/GZa+UZz70rywKOFL/qKiajzcuM+bhN/qobgRF839ez23gryOL0fmxnzY+J72kl/R+ht6RxXA9+0W1LQ7+pf+1icTte5x5fkX9WKZk1nvt9RZt0cJZit9o5zbGS5aI/XNuZYkr
F9mv3+hTsV4b8XiNBLZv6+f5cf+NEUdpjRWSiCkW9EhoRD27UlA8oaftK+pVnNWilXYWez6s3CSylVfkehetDtj8S08ac7PY3cbnpJf0kt5P0QvPjGmujxjnPbr8Sy2NefmNATTmZrFLrrdo1/PJfRlZjPuNnjTm
jtxvNNNYYMV66fqNPtHBYkzPl8bcLMb9QTuN+XNbxf3By4iN98+fHy/QOzCSlbBAL5jJDDHWv7RSGOhF+ZT3GJ+TXtJLej9Dj41QOJ/motoWXuslAzNjl6yXFKplGfSiCcvjeotBmbGDf+mfGfPzB895hT7XbwyM
Zj2/tY5H5no+rskzrRH0xPtqdP3sMUTvdNz0LiJAzI+fyoDJUagf2+MIw6KVyYL8UJHAvGbwf8r4nPSSXtL7KXq+mTFDvde4OWOrP3hRbQvP9ZKuyvPn/cZY/zI0M7b6l9405mYxgz9ooDF39PAvPaLv9Rt9MmBy
VPxBH/JRmaspSvizgdvYP28ac0fBb/SPl/mhbhbT+I0+0chikt6ZzJhx/eW5zNh3Ge+TXtJLenfVu6a2RRa2XtIrMyb5jRdkxqT6pxdkxi7zL/3WS/rkx1bOmjO2vnHefzPEADrCeqWXZcPMen71JwT+ktcjXjYD
i/uNPkzmFUEvaj9T7s3Yv2Dnkp0BUe+KzFiEfxm7/jIqM/YZ43PSS3pJ72fo2Vns+biutoXkX4bO4L+i3qtHZuyk3xjrX3rz1+ZfmubuSzTmju/zG4OzYXJ9Vi8a8/HfImfwG1gM9K5iq+v0LvBDTYyk+INX+Jfn
a1t4rb+MyYx9/fic9JJe0vspemczY0J91tB5/H7rL600FuRfBvmUpnjCv9RepRH1gq74mB2vjS1dIZvXP/WksXf5jSF65syYjr8uWt8Y4g/6EBHzLyFifdbtt/NR0YuitMPxKtvGr3h01GcNqm1Bycqr3mtAZuzT
xuekl/SS3s/Q07EYjH9hPqWjXoXGv/SpcGFkscjrVRpZbNN73XpJE4158RfquWmMHH1KU+T+5cv9xtjMmFSf1Uljbtry8i8DcmKS32jiogDCAr3LWE3QO5FdU/zG89krP78xVu+y2hZ3G5+TXtJLej9FLy4zdrhe
ZWjNL7/1l+H1xMZsr896ek1j0PrGwPgyvXO17y/1G3nEihS0PmsRVuHCWk/MUk81cv2gB4cFRO43huxHSSq36LHHxdgJUbzf/gwY8XgrzJbRWMJ9mRhPr288GQP1nCxG84lX1ba473hPGtqyKaP58SkTfsqZtrnH
ltFWNLSxPfQaogLNn9YjbUyD6XFt/Kly2kQ9tj3bht3en+H5UJ9D3kr6jBppE7fMO9rYkdD2fOiOyHSkmmPE2/s29PWwnyfT0bG9WP/k88eOwnREVUeb+mz657nn+y/pnWs7i+H8jbgZ/Fo6stZnjbgekle9143G
IvzGk0RkqM/6Xj0LhQnXbzy5UjIL8y9D6r1605ibxQL9SyeLbX7eRVHR8yYpPYvhek5/DSeLnVrfGO5fntO7IDN2z/HZV0/8dBc/9Vljn+5jRdvKGM+Hnl0YR3QNbabnEdmOKdDxKic5Yb+ZOMbnGfyOl+3Nmv3Z
1vsp/609Yz0QzxPbj227M55NVXP+BE41HZ24jUxnzwe+ggIV2mnw3PslvCW91+uFZMY09V5PZcYc6y/PXV/ygsxY8PpGR3yD3qnM2LvWS/rTm8xfqHdqBr/Fv7wgM4b+5YXEptE7lRlD/3LdSiGw8MzYbfxLR73X
q6q+3nG8Fz/d2ef5oMktSXtY80Uij+j6p6EW7AGC3minCMZD8t6hx8soZ803seP1o7G9mZ7/+WC5p1DVkPPnr6rec8f3X9K7Uu+62hZe9V4DZ/lHX18yfH3jvfzGuOhX7/VEZuwt6y9PZMYi6r1aWWzzLy8irAj/
0spioOdPY2I0UBievwif0sRIuL7RY379Sf8yOjN2//HZtUUY39j8N71DqfMQ9zwcze+qTl/8M1AeMh0j20/NOdn45uhf2s+Wm8Xc58/+Shz3pXxqOoqYzNjnv59/sp6bxaz1XiOqvgrrJYN8SlOU/MsLMmO38Btj
9SIyY1K917eslwzLjJnqvcZmxgz+ZXRm7OX+5cnMmEHPlBkr6KM2Fgte3+hgsQv8S+l5QO/kDP47jc+utvpvLDPFslT2PUxeodl/Y3RidN4cFMH6Z9rW5xnYoysNqudPPCLRQWX7HeeXHV1Kpre6rUev1XyeTC4l
/X5p8SmDM2Pq63Gu3fv9/LP1LsiMma8HGTlnjPuXJ2bwe65vjMyM3da/5MzFry95Ygb/JX5jrF5wZoz7jSdm8DvrvV7tN57Kj3G/MdSnNLFYwftX7PFcZsyyvvE1/mVgZuyTxmdX88nHyHri536NTeQVNXslPrrq
ifPKxcyZfv66OoNffgYYD5TnkHqsrBpgP2oOqx9pw/ULm7rKRaYMnejyiqpwvHie1GyeenQ+fWV8ZaYxBp72s3iX91/Su07PxGLA9ydn8Mvx4DeezowZ/MvozNjN/MZYPe/MGPqDp2bwy/FV6y/jZ/DL0elfBmbG
TvqN5/Q8MmNOvcIWVRa7aH2jy2+8zg89mRm7y/js1jPNCf+6/un8weuOV/987/PzzP7llc29nvO685f07qIXnxkT/MvTtS20/uXJzFhgfdZ7+Y2xehfVtrjEb7xg/aWNxdB/O1/bwq/e69V+4zk9O4355McKrmem
sWDCCl3fGLRe8oLMGJsf+2njs18Tcz2y/yY+ztZTvr5/fhRx1fl7t58Xy0ihx+t6nju9/5LeFXoyi8H4d3IGv7Pea9z1kPb1kpfVtsiO/uWd/MZYPQeFYT3Vlb0WoJriXGbM6Deeu/7lJbUtsivrvcr+pQ89eZGc
w7807W1kMWm9pMpk4v2G2WIyi23+YChVea1vvHD95UVVX+83PofpmTwycSbVdzpeftTedPQ9jjfpfVe90MzYod5rxAx+mcUs6y81NOZmMfQvL6pt8YV+Y6yef2bMwGIX+o2x17+0shit93puBn929C9Dr9/o5zee
mWsmr+c0bWXPjBlYbNPzojG/eqpxuaqg9ZLRmbHdv7ym6uunj/dJL+klvXvq0fGJ5u+vqm3huV4yKDNGx9OraltY/Mt7+Y1xe7vqvV5S9fXl/uXJzNil9V51/uV1fqNPXs30nBuLCfVe/X1KC4uxegWn1kh6rW+M
zYlp/MtTmbE7j89JL+klvZ+i55cZM9Z7jcyMcb/xktoWmehfxszgv6PfGKtHIGZS9JoztvmX71kvGZwZk+u9ns+MBdR79cqMXbZeMmQ9p/+cMZ2/asiJ+a2mPPiDpzNjJ+vHuvzQ05mx7zPeJ72kl/TuqndFbQvL
+sboChcRelYW09Z7va/fGBcFCgM9E42Zyew96yVdelGZse16lVfXe71kNr/H+sZADgS9VmAyI4cZ+q1QGOiZacxEZhYWc69vDGMuq38ZkRn7lPE56SW9pPcz9Gwshv7RRbUtlPqsUTP4HXo+mbGv9BtPzmPz6N+I
+9kzY2b/Upx3b4qv9y+l61VeVdsiut6rhYguXS/pWs+p8lQrRLMfalIKqW3BKczoD0Zmxi67XqXLD43MjN1hfE56SS/p/RS9c5kx7l+G57AMLCatv4yawS+zmKbe69f5ja71nOczdyPXE5nMRGO6RxX+Qv8ykMls
0cu/DMiMSfVeL8iMafzBU5kxL/8ygAMlPTuNhawPNdOYDwVFrm8MWi95QW0LNj/208bnpJf0kt7P0FNZDOdbRPiUgfVZ3fkxA4tZ9WyZsa/3G6MyY0H9G90stvmXujg5o8xia/3Y7bfzt9d6r1dVfT1Z71XnX16V
DVv9xrj5agYWO6zn9InWzBjNr3l5llf4jS/U882M3Wt8TnpJL+n9FL2YzJhyvcrQGfwNvc7DpfVeJRaz1nu9wm88E1+7nlPVG4GhCikaZpntEftnJjaR8YhQH2PKSv1t0DM8or0tsJg+qv6lgcxM0bVe0k1EuS1i
/0yPh7qi4f27QM/CXxoWu8xvfKneNbUtPn28T3pJL+ndU29lMRifL6ttkdnqvWppzM1inte/9J4z9oXrJb0oMbJ/RhbD61V605g1jrDXhP0rNhpjJHUiYv+8aczNYhr/0kJj3n6eJ425WczLD43t3+mI+fEAGrvM
b3yhnp3F7jo+J72kl/R+ip5/Zkxb7/VEZsxZ7zUwbvVeo2fwy/Fl/uVFOTtt/05kxqz+pa1ihqFumeH6l+5o4C+bfxmTGYuo92plMe4PetKYlx96YTYsTM8nM4b+5ev9Rp/ZZ9qZaEe9s5kxOp72+XXt+bhSLekl
vaT39XrnxpcLaluE1HsNyoxp1kueyoxh/y4krCj/0sJip/1Qs16QT2mKgn/pV0XWEbF/3jTmZjHD9SqjM2MGPy86M4b+5Vv9xlg9T5/SEZ+P0xqX+Zc6Fvse36eTXtJLet9Bz8VijnqvwZkx7l8G+5SmePAvT2fG
3uBfnsqMOfpn0jOyGOqF+ZTHlZfX1XtVVlOWC/qNET6lKXL/8gy1SISF6xsjfMpgv1FdeVDg/Y64rZcMimY68vQvvaNT7zL/Mi4z9tXjc9JLeknvp+idz4w9H5ytQuOV9V4tLHao93qd33g+eyX37zz76fTsPqXH
1SxBT66JYaWxU/VevWNF37E8bvVeo2fwB/p5gTmxg38Zyn7m9aGBhGWKWO/Vm8Y8/csLiS1Qz8linzU+J72kl/R+hp6exdCP8vcpneSFet40FlE/9mRm7K3Xl3xlPVrPOWOCns+1xZ0s9vLrVVppzM1fin95MjNm
XS8ZkRmz+o2mmhwWwkK9E3z2Ar/xfXoXZMbuMz4nvaSX9H6KXmxmTPIvL8iMaeq9nsqM3areq4aaXtS/0Bn8RvLC9Y16JouqAHuBfymxGKtH60tjbhYLWI/oRV5G/zIyMyZdT/OCzJjdvwzPPG1+Y49jCIuv9C+D
+3ddbYtPHu+TXtJLevfUE1kMxr/LaltwvzF0naWVxTz8S3dm7B3+pco/KgW9xg+1zhkDPbVPPtkwwxUsPf1G7+srhfiXUmZMJYqc+3lRPqWJvzzXS7Joryh7hX/p8htDCVWIVn/QNGfrLv5ldGbsjuNz0kt6Se+n
6IVlxpR6r3G1LVzrL6MzY6jnTWNv8y91/uBr/FCfGfwWFtNcrzLoeuJavzH6apcGPW8ac7OY93rEkPWS3jR20r+05778/ForjblZx2t943v9S2P/rsiMff54n/SSXtK7px69Xtt1tS0yd73X4MyYZ71X78yY5A+e
chqZwhfWj/XKjHE9Txpzs1iw3+hgsTj/0sxi3H8L9ilNkeuFzg0zsphRLzIzZvQbIzNjzA8N9wE1dcFk//KiGLv+0sRi9x6fk17SS3o/Rc8nM2ap9xqVGXP6lzH1Xi+qbRHgD3o/wxdd/9I7M3ZYL3k6M3bwG09n
xnT+5ZnM2FvqqZ7IjHn2zzszFr7e1M461utBqhVYz/mXl9WPjc+MfafxPuklvaR3V70Lqr6G12d1slhwvVcbi73KH7zf9S/N9W1PZsYM9Vl9olZV8EN1+wVnxpT1gyczY6frqR5YTNE7mRnz6J/9+uiHiHrCfWfp
SPIvL3Adz1+vUmaxzxmfk17SS3o/Q8/MYtxv9KQxNylJfuMFmTGtf7nT2Ov9QQd5fYl/GZAZ49erDJ/Bb4i4vtGbxtwsZvcvwzNj0vUqL8iJOdZfBmfGLr5epW79pXe0+oNn5oZ51WeNiy690MzYPcbnMD3S0JZN
2ISfcqZt7mnj4/5Im7jN81F1tBUNbUyJbVuPtLGt2O27HG/SS3rfSe9MZmzzL0NzWC7/8nxtixB/0HutY7TfaHiGF/iXPjTGru+9Rp96rzIrhV0FXHg21COHHsh7BGXG4PNjpTH65l1jdGbsQv9yrc8a5VNe0j8P
5trqx3rRmJvF0G+017a4wG+Mz4zR+bGfNj77NZGt2G1Zj7HVWNHGmIzx2b7tpoEkx7anHwpzttPZ87Hy2Vcfb9JLet9Pj7PYksEnXNHw8XRGGqv4lYvYrDBblP3BnYv6zW/UPIJMxvbuBaVeURow4yPWe9U+YskL
mehoRL8ssvKExW+8qLZFhH+przOWSccr/Laxl/22hcVAL5jJbCzG/dBQn9LIYob1g/5MUwhkk0t+Xi4QjOl2oSitpCSuvywFJjPt4Xlb8C99+me47e0PBruORr3glZKh/qVfZuxu47Nbz8RWpiYTFuWrlbCO7KXS
mJvFPu/8Jb2kdxc9NkaxUo9FB6MWzYm1nIXopzHBOO6Rr0ccldjz20PYbV4/tsM4bJmx4x79Rl7ibQKRUs4Ikd0mqEc/60dkAFvkewgaa4zzG00UxmLPeGmrzxofRfrt+Oux3kfwnE3aOOCceTGO6m1WT1XzyMhn
3AfOGbPUjzU5lzYWM16vUhNNJMe4I9vqxy77b8eISuvtWbjfeJvr4XPwvX1uM6rKdo5at2F+o2MPn9t8X9GvNSl55rD81jd65tU81kue8i+vqvp6r/GeMRLjJcZOLj0TYZlYDM5fAI192vlLeknvLnpshNrqvY55
hTkxWiGf4Kf7jJ+PizUqXIb1RfXExqJ6BWrr9qi38xmjMfE27Wu+sZXzNuiZtgr1Hs31VE2ZMZWtBv7oFtG/FPgtIGopDPWOHLZy1uIZCeeOGf3QkzP4M70f6kNj88ZIRgoDvQAaM1DY/jwx19NcdtZRI++fYytT
ZNR0nZ6qjflxbxoLWi95yYyzGP/SxmL3HZ/deoyR0IAcxVlhpsb4KoTG3Cz2yecv6SW9u+jxzBhlMbouvYZPsAZzTvRzMcfPpRweXNBPydff5OhgNSVSdwn9FHSZNFvNyGfmOOLnrHSb1wPVPHK4PSHDTUh6E+e5
kbNnvvMh6qnMKEZ/HiHcf/MhNh9fU/ZXj3tkUtx9Sl0kUv+23yzR86iF9Zfh179c1Gi4XmVUZow+6n09TSEjFXT9SyvpaaJL72QlMd96r1ttC7/1kqdqsoos5lXvNYC/VP/yXGbsruP9mhlj+StGT/Y9fDJjY/18
0Kn6eUdbJvz4z+D/jPOX9JLeffQ4jdUw2q001qJXRz9JCxybi6qE0b80Rj5bB/2P4jCDJyyKnCdff/AYcyPJmeKM/qCL9AjnAfX2MYb7b2yWlJG5NH6ofRacicU4bfH+2WksIEYcr3UtpnH9pZbGHLyUH/xLn7yV
g8X4ek5PGnNHaT2nGu2EpWExh54atdSn798VmTGt33giM3Zu/aXKYp8xPrua/5yx8P7ZM2Pf4/wlvaR3Fz3OYg2OeROwGP/sZyM3rrfSr/5qihLoKTCCns+2rhrnlAD39WWU4tY514wc6WdKiURnul3g51LB2W5Z
iY36PRLjhfGektdDf0vgN00WKNyvPfq8oXQk+4P27J+ufxZi436tIfvmHTf+wv7pycyH0ozrL31ozMUuRWZbjxh87e6SX6/SngELzIyF13u1s5jiD57MjAl6Z/JqXv5lTGbs68dnXz2xqoXKZOJqypD+hc/g/9Tz
l/SS3tfrCZmxlca6ncY4i6nr8Td2on5Z8NViRPJqiwrYaot0fZ5033Er+faulOtvC9cLpDEz3l7XlOWG2/xzlvk9nOiEFX07t8GjRHs707l2ih9qn21nmnMX4q8GkZxyvcpwtpKihx86YW7Lh8LM/qV1/aWNxaTr
XzppzM1iSj1aK43xaNlS0LsgWyf5l8IzxWfGHH5jcGZM0rsgM/Zp43NIE7Nkq69IX99MU2nsOxxv0kt630lPYjHCWIyvz8O8kEJja9yZJwcuovcY4/NhfbxDjR7Zaihq4CwW2T3y/Q29DXrCbx63V6V6ex7pNurl
0I8Kj6vCPom39yPtJNLLtjPTCJ/DNfpbOc/B1QK3SS6syAb2+XJe/mpAlPT8M37ijC5pfj/38/zXAtjjxP1GO5P51LzgUfW7gzNjIhFdXZ9Vd71K+x6Obc73L/OtzxqVGdPqnciM+fmX/pmxO43PSS/pJb2fomfK
jNlZjPuNnjSmxBo/4RpURb4BPZG91LgSlj6ORQvkJUTQE++z701jpkRpG9CTGY/GjvNZAfez2MIR5RhLHimlFTwyFxVnx1H/6EhmcU7owQ+1x3Xdwh4NW1r0RBrzuY1MRf1GkbAMt01RYTHz+kbDHEMHixmuf2mg
MXd8wfUvz19b3K9/qB2aGbNeX1LlqSvWXwZFmo+9qrbFZ4/3SS/pJb176u1zxoR6r73BpzTFRhfR/9A+kukyY2J+TJcTq9BvpL9lPI7ITQRoK+dxKjrYg0XxfjXCNuiv6vboDqpybKA3x1jRCHoV/22EnstxwCj6
rmKd9HUG25IJXtfxeoHSVjnPtB1jocR1jhxbv7pm6KbwuHGg6g+KuSr1NrsiuHg/I6xF4CzJHzReQ1xYKWlc97FFfL8ox7vmA5HG1MoOlrnvfP3vkpm9STE6iUi5vmTUlYu075fQqvzazJhXPdWAzBj3Gy/KhoVf
r9LFYvccn5Ne0kt6P0VPmsHvYDGj/2FiLgeLSf6lmcmYo1huFCaymERkoLdzk+ZxHZMJLMYorHPo1ZiJq3EPDZNpWYwTGa3ndmCy0Nl2UsTzp8uWiCsdlFUPmjUM/Db38zSPCLeznZRct7d6qvqteF0Uxjx426TE
+Cvn/q+hwoombiR64FC5Pmto5QkjEZ25HuSFekYWM+o5fEqLP3hZbQv6aND6S7/+nZzB//Xjc9JLeknvp+iF0JibxdC/9KYxw/wxIdLr1+LMLUZjPb9dWcjMFJGpQM9EZtTRzLboo9egH8poTKS0EbN545rTw/ye
fkac/nh3HlUe12QNR06ADWbg9megz1+jX9tsubmer4DI0WFmr0cmvDa226u/xZlMyNbZb4urIXheb8/T4Ho/IUco3M6lvT1JxLa+UcgsFgJnqfcLcTteMW95Ys68ZX1j6PpLnZ59D/uKhGJ9ff1p7Nz6Rq982xV6
Fha7//ic9JJe0vsZem4WU/yUk5kx1PPgsC3qWWwjMtQTycyH0iwshnritmZtmb9kFtsoDP3QwcBWfmdAYjHUM9EYPZYa83sVZvwaiD3cw26vM+gYDdbM98X1q36rIWrM6Dn42vD6tnzdB8vcZZk8c1COmRgF/60W
iMjEUE4WU/xfn6gy3BYF/1KMUWwVVJ/VU1tYf+lBY24WC/UHXfFderGZse813ie9pJf07qrnVfXVVKWVsxj3L/2ZzEEc6OfpfEqVxrR8doy4XjIki2biL1lP5TDKXLkxtngMmgh6+2+dsJ7TFNdzwnhqX23AKIz6
q8x/ZRzWA0Ox2wTv31c1ZMI6h9x8G/3afTWE/uhsbLqeGf4q8uPtOIPusTfcv/Lc/g4Sea7ifmPlR2Mb1anR7A96eJnS7H+JdYLrszoi14vmvSOF8b/f8NoWXv6gFEkOf9M8XqEXlRn7pPE56SW9pPcz9Ewsxq8/
6KKxQuNpaePBv7RkfgxrKg8sxtdfRpCZnsu4n+dJYwqLKWyC6y8F/vDmLANzbX6tSmMik40819fztQiF5vbI/doR58et60db5212ZmZ8hpl6s3Dg1KGdmV8Lb6EWgGihUXNb3GPCc7ZgVG9PdE4d9A//51F0e3v+
TtHnF9f1uod4WD9oorHawHNmv9FEY4HXQ4qoz2olr6D6sUq9syv9QT2L0fxuHJnF+qFhmbG7jM9JL+klvZ+iJ9HYlMMnum9mDP0ybxpzsxiufzNT2s40nhH9GfE+e97KntPZ13OK++kpzcyHUl9Qz9R/lhFSeU49
krWvDR7vhLw1wcu6r0bos30uXOd/m/u14iMQkadyHku4p0DaKqTbFexVAgTRuN1P3y/SI+pttje9pxYjozoeJ4xs/aq8slWpcAJnsUF3uMGZcjVyW7VVIumF2KG/uj7Colib2DgP6xj31Zm4PjTwGt22yPxQ11b+
UdDLcZWHED0zYyJNkedD/C0qvtC/HDI2P/bTxuekl/SS3s/Qk1kMxr8AGju6lWrU+Jfec/c1M8c69C/lPJP9tp1j2PpGmWrWDJP+to7k6l2V+5dyHs/MjLl0uxUorGGuHffzfI6F9XIuBu5PrlU6RjHPRa8nvP+2
+ZR+caLbcworWES99bdSYDI1VgJz1dC/qm6gr7UU6Xpd/B9iq4k57NewCGRmizMyHK0f229z6FhklCaufp3hzFXSPeuq2D3yar/8/bdm38psz76Jt2ks8R5H5K+va1tWm1+8fYycD1W/0avivxgryp7W+qxGGnNH
0PPisFf4lz6ZMdd42udh7fkI3SPpJb2k97l658YXTmNVnvvNGUP/40hjPrWVDBUajv6R8Ph+JaSCV8PX1cc/3EY/VOfnZR4x5/kT4Tb6ocdHeqFm/xp3ZlwZ8zj/qeV+2T4DKpdu15rbJnJdZ1itfujKiWumSF/j
w2N2HOrpM34E4yL4irbIue35kHJpasyFjNqeGaOOZr/FHN6mFYugB5/cmDPbo7KV9Kh4P24J/euwlx32r4D7CnxEjnSPksf1/gGOC7dH6suYhngbzh+7z3SWRZo2zSKs9yj8fRTOvzG/eq+m2hb1/gz+mTHFbzyZ
E7vID9XoXVP19X7fp5Ne0kt630GPjk80f+9PY24WM6y/NNXLcrIY+kdrxf+dvdTYCtTUHghKYC7uX+73sRyRaW9TNPurKjd1En8d4+GcaK+naaQxaT6V1mvd1nOaPVr/OHE9DxoTmczGYuhfCjTGWEmiMTttrX4o
zbdBpPV3998OkZHXGhlb0ViCUq6P9PWo22KCPVhsCgL32CNTlemtw+Pt8PWdMduoRhNHD8Xx24POPzf53cd3oRwP27DrGYb7lKbo5V8GEFacf2lmsTuPz0kv6SW9n6KnyYw1MHCxK1rnOLvYXW8zODOmqVdqu554
bmQxTkf8+pKeNHagMA2LOfQONKalMP31Ob1ozM1iXE+lMRNDOWbYOfxQMa6z7K2R+6GTEtf5/8e456qkuLIY+o06JmNx5ax9DpoplpjnKtEPLY0EVgFPFVLsiwWegcWumGFfKYLe8T7GbTXcZgxH3dmJ37/eVmMJ
z1Zj/whnzUqboVszd7qMn3he+bmXXg/C159UWyRC5hPvcbHY5g+ez4mt/uWF2TC9f3kmM/Z9xvukl/SS3l31/GjMzWLO6/EFVpjXXI/PnBPzyIxxv9HsUwZmxrb6rHYOk+fLWVhMe/3B0MyYvJ7TTlViNQmPuOkR
7ofuUcdkehYTiAz0IslMichZ6Dfu1KX6nmvcM2NWFgM9kcY0BOaIC+61cJKjej2cvrIeMEq3kfHo7VqiPiP70Qh69P9Kioz0GuwxizUekRgrngns5Qh67Dd6ni7IjAX6lxeslwzLjH3K+Jz0kl7S+xl6NhZD/8Ob
xtwsdvDf/OKR54SIfiObX2Mns2MlCB2LNej3uHjPKw+2Upjm+px7PVOfWT4HFhPqqXrQmDszhnqqj2WPFhcTX99tdWfmdU0ETdz4i/uhWjJTKY3fVuegbRH9UJNPafcstW6k4l+ucYb7KR1lPA4YKVtl9YiR3Sbw
QuScyCDS9aH8NwKPy3HCaWT2eNgL9UbMzbHIHmG3B+hrrok9HJ2BxTT+4KmcmORfXpATs/uX4ZmxO4zPSS/pJb2foncuM8b9yxMz+C3+pR+p7DOezf6lSmNqVS87hTXbes6wbJiDxYzX+9TSmJvFpPWhPkzm4C/u
h3rSmBANVXa5X2ZnMlPGTBP59UNFMmPsZV4jwGZu0RyQGgv0L3V85jNPbI0TbN9i7NG/pOy1xwE5bI07q40Cq81IaWJcyhx6D3zF/o+JTQZ/pqV8v0YPnw9obAKCKUIjHK99q8DM2HX+JRvnPm98TnpJL+n9DD2V
xWB8Dp3Bb60judWfNK2mN67U5zWQDpy3+aEiqdjn91trq271VH2yYfbM2F7fVrqiz5HArFE8djw27l/qyKyLyYw5/UtXPNDttt7UJ/8oztI7VtjY69HKV23f47zX2FB8Tzlus+X5ek5WIW2PJhrjTKbJlZE1gp4/
jbXIWWIUWYzQe0AP/68nvI/FhUagp8wSc2CnXI3Ph+kR+CMp6KXPDPcLj4oshn5jFJnpWczqX55aLxk7g99/PJ2GeVqKchrh/yzrsxn+ZvturrqMZHM3VaQfSzIMbVuMU7dU3dh3wOPlQsq+r0eCD00Lmcd6yaFF
zWC71+dH0kt6Se8qvdDaFkK9V08ac7MY+lsqjYkVw035InV+f4vr/XIjjZnqCVhYzFCP1pwTc7CY9XqfCo25WUy4/qX/3H3LnDGlXq56HQE9fxlYTFi/6kFjRhbb+IvXt/WkMTeLUT0jhyk0hnOvzLGh9fqQvRb0
KZfNrRRvi5kxxmJ7HgxoCx7Nd/Kieg4y84mMvHR6Cp8hjVW+Ef1Gv22JT+R6Xtv6652vbVF3ZIY3Fvz9kmme2X1zM9fTMkx902QjASCrSdWXEOeeVPlUDyVEeN6qJ6Sfq4kUfVWNEJu6BH5bpvKOnx9zRhsAOjQC
f28E4p36l/SS3vfTW1kMxitfn9KUGZOIzFh/0icbpsaa+2Uql8g0pl95qcmJ8fqdulphvvG4XjLHZ/XNgJn463j+ii2aPMu9qkVpzgFqjzcmctoy+L+uzJgxbvVy6yygBi2Pa7UvIeL1OdffREpjtWvtmTG9fzki
mdHI5sCzaGEyjLP2Nn2/CG4mxnXmFuMzelvNmBkj6Lm3Ut1PjRNKI83XhdCYO256FxEWrx8bsIedxfzG0zwfycIrO87j3EzzOHZDVZKalnieC/gjrOaFtM0AejVZ2nKpp6yt+O2CjLBLObZ1N2X9UhG6dzmDDiHk
Xp8fMo25WeyOn29dQ1s90va+/rHnY+29x5v0Pl3Pf84YvX6eP425WQzrT/qSmSlHJPAX+oPeNOZmscN6SReTOVnMst7UfM70LLb6oQE0FuDX+l+l3MpizvWrpmjgL7yepp7GTFW71CiwGF5P05vG3CwGeiKNVchT
FecwfWyF2OG8f2EuPeix3yaccW8irNH3Nugx6iICgRlu+xAWza8Fk5mFl1DvsmyYqnc2M0bH02wmxVI2HZmWjBR9X7ek6uZymPtxaaqlmvK2mxuSAV71/VBNY981ZTPO3VQupIPt85mQvAU1ArzW5kBmdT2ME7U6
qW+55tu++vODktjzEUJj7+2fS4/1uBppm3va3tU/9mz0eel4dc2Zu7J/Se/Oehoaq3P4/AnIjG3VvK3+W0SFC0P9U3tObK3Zv9+zsQRfP+hJY45s2Ho9Q7VWWHRmDPtnpzHx2lOyW6lhMcfxBsfNb/SiMXdU6u+u
NOZeiynGbU7/Vk/VHr1zYoJ/KRKYKYosxhzNHOPGZbj+cqc0ea4ZW4vZKXHAKK6K3CKuD8XKGfw+/9tsZaW4dnNdz4m/XZMT0/iXF/iNcXvrWCx0PC3rOV+GvBzauSXd0DbTnANNdUtF5radgK+GpV7IAo+QuZqA
1BhhzcsMG8A9HXw21/3U5GPblWWNscRIt856Et4/lsMqsc1CyzvaMumH1fNtJ9rKmTaWPWJK7Da7HzdpGYvV2ESdYaRt7Z8pi8ZuZxM29oO3xW1cfqhGA3/smSd2JB3o0cj4yH68bBt2j/l52PGqfVJ7w86QKz/2
CXyQ9N6nZ2QxksPnSJUZ671qaczNYl71Xu0VtyQW4+sbPWnMzWLSekn7DDF2PWkHiznWS/pnxmQ9lcZ6POpgwgr2Lx0UJviX4TkxDYtp1l9aaCwzVilbK6Li+svMsapSjUYK4+sv1UdYTYyc18fYZ5yZWIxHrPea
a5isU5is36uYmSP6l57bYkQ+8/Ab4+IFfmOsfxmXGZPH07YDsALCIePStuUAVLZUU9kSdCNHMvZDXb57vDfRmD2rJe5FFtrY7VVPJDqRYJge0zY9m7gv8CknN9+9xf6pz+/0V7fMlJyXch0v66VIZmw/xlOsB5oj
FTiPKaz9i8nNvef9kvTuq+eiMWttC2Sxw/XuTmfGjPVPTXX6HVHxG8MyYzKF4Xo1Y+V8+7GLZ0lwdqn/e7xv83wVGnOzmKffGOtfhta2CLn+paYahjvi+ktWb95SJ1a8IqWdxbT+pVgl1SdLJlQsw3qqYuWynclM
KzJF51KJvN6r5pGAKPAXrUd7ZLIzOTGrf3mB33g2MxY/nlKPcqmLcq6WMs+Hal7magJ+hlPWTX2XE9J3VTNOXVd2PBIe2xJgrWsgjl1dNmMPET7ku6qsWGaMtEPRDOH9c7MYzTeZ9mYEIee7dlUNIwFVAL9I/KFu
qzKX+JyMb/Z99X6oXcN2NqieeD58jnfNpe3Ut29PeVLss08eTH1VTJ+/51vS+y56ehaj4x+jsXLJZ8oG1vyYk8UE/zImJ6bUfjX4lyYmc7IY9/M8aYzPDTP1b/Vr1bNioDE3iyn+78nM2An/0lzv1ZvG3CyG/fNn
Mm3NWJHF0H/bycxVb8zOYiX3L+1kZq4lSzKlbhn6lyqNWZnMFlHvBKV5+I2nMmOvWS95ZgZ/yHjaLYSMZdbP9TKXeT/OOTBZ3dfLME1di7HBSO8hND4f8H+19NPYlcBtQ1cs9VS2y0xI0fS45rIHSiNVHt6/uMwY
H/05mzD/0ofGWDvy1JHFmN/oS2Nuj5P1z8entFGQ7XhNmSyxr2YWY/k/icYMGbor3n/hLel9hp49M2ZmMcm/DM2MhfuXPnVRJS6T/EvzTLCdMnrONAYW4+s57XXDxPPAIzs/ylmi9Sx9mGx3Kx0shn5jhE8Z7F9G
Zsb4eklPGnNHo3/p9iy1mTG8/qU3jWmjy7+UV1uOhxn89tjx+rHdIYZwlsR2qGfcNpyzPP3LF66XdOmdr23BGqmHrKH13Nq5meEvcFqWuZ6GYarIPOT1QPJuqjKSdWNJMI7j0g3lwHJlpO+rql5qMrYTsFjZEGCx
hq7/HedurtrQ3phYDMZnZdYYu0fcSvXtVJeSZcFoPow2RhY5oU10JU0+pUo8bF/Ga/K2YmbKRGlMT81hrZ9vJhqzH6/YP0aAK/+J/ecsp8x8E71MUy8+lQ+S3vv0RBbD8c+bxtwspl0/6GYrHYv5X/9SlyUzsNjB
v3TQmJXF1v6JZ6KAc2OhMXdE/9Kbxtwsdol/KV//MsqntPiXoXP3R16rbFfyuf5leG0L+fqNXjRmiM3OYqAXQGNuFnP6l3pVI4tFrZd0+ZcvXC/Jo6EHbhbzHU8JGfo2n9qpGrqyn6cF1Em/zOXStxMA2VItdOa+
QY+0fV/XwGFZS1dhzk1J61zUGdaEtc440+uFZsb2eU7PhzyjXZw3Jc7g70faxBnremqi348cM/itfihbKbATI/UbVQ2RKDVnQ8lI+R3vnNMm7aecV7Z91dHG5sOtrKvONfu69ZxJ73P1BBqjV6Sr6PIqhcWylcjQ
j7LTmE9+zK/+qU80r7+kHFYEREphJZ+Vv0VhvaToUGpoTGQuc2T1bQ3nzP8sbrzJ69vu6xZCq6Ud8oQe/iWr/WrPjG2kFOg3rmzVYP3ahlfsWOPRD9VznXJNciFLlm+ZMXW9ZEidC70PCZH7l8frcvtUJmu5Pym5
lKhnYivT9SUtEf1Lj219CSvYv3zhekkdi4n9uyIzxsbTaSL9MAKL9U01lXM1jkU/kwVe3XFZ5qruazLRotm0sAjdfh7mcuqmdhx76MpQN9m8kLqtZ/j7GIcmJ2VfVcNcTz05mRkT599fUZfCfz2n37O96/PNNAfM
1FZ2ot8HzT4lO9Iaf+yEtTqa8P0oqN5Y7PEmve+gN/D8vS+NuVmM+29nCCt8PaJtfv+BvNC/1NHYgcMsFKa7vqQnjblZjJ8/Txpzs5hxfajdtTWyGOp505g7avxGC425WYzredKYO2r8SwuNuVmM14/1pDE3i2H9
2Cgy00emd11O7OBfvnC9ZFxmLGI8xXoVpOuHup07krUVsNdA4PzN04J8D0w1l3OfkZq0Q1bTqmN9DZ/jY9kMSzVV7TyPdLYYWfqx6gkVykfgNXq1pdD+hWbGXrWe86qaZFf0T8xLrf6qz1lUvVb1qBhf1RqnlCsF
zha7Nx8kvXfq+WTG4PtCAI25WczpN5pmY5n14tYFqCwmr5c0cVhgZoz6l/40Zj2LSGHb9SpdaxU8o+DXetCYm8Wi/cY11jKFoR6jMbfjaaoGK7BYUL1Xj8wY6AXQmJvFDv7l6czYVj/WO3r4jRfVtrhuveTOYvr+
xWfGDP5gP+dTTco+r3pgsaKtp3FuxrGqKFNl2TQtc5UNzbSM85SP+VJMdVfBFvPz0QCv9VlVIIeVeJ3KrO7Hdh5C+6ZbPyjOwzrOfJddwis+j9ws9lWfb2INfj89cbWl6siKjanyjYRZZDXPh/ln5a473qT36Xph
PqWJxQzrB6Oj4F/GeHjKrDTUs5OZyF9OFlP81ZOZMeX8mY7Uvnp0IyzD9TSjM2OCfxnkU5qiw7880JibxVDPm8aC6r0G+ZQmFkO9CJ/SxGK+fmOsf3k2J2b0L1+4XjIkM3bVeApElk0lgfdLT8u5dsPYNHM3NUPV
VnNHp9/NFa8TOzTNUI/FUA1VB2/Psel6sep+XvZk3lzKz/n8SHpJL+ldo2dmMRj/onxKEyl5+Y12/jrnhzpYjF9f0subVHus0hZfbxrsU5qIjJ+/kCoe1qj1L09kxnD9ZYRPaWIxXH9ZGGfqi5EI0chi4vUqr8iM
8fWSwT6licV4vddgn9LuN8bxmYffeDoz9rJ6r9Ez+E+Mp0hV00z6gZB56NtiLAfSNk1OJpKVxTTM8HrkGSmWKiMjWahHOS0Zzi6bOjLl81zUwzI7rlF5v8+PpJf0kt5Vev1Cm4bGRmQxOhF1JzJKEUJE/3KtN5ZJ
seRUFRRBT1XyiWY98b6K58z2WKNDWXO3kvGXPtbbekl9/wt2Hvwj1ws9xopnxkreeymiv8pmkMVFSltCRL3DfchtGa7ezI1x2OZ+SRHXX2ofOcQ1D1ZI9yvV+rfrX45CJLz2GGOydoszv2o4ZbEMqUqJz4fpESnm
SFWmSImMURir98r4bI+2dZb5FtdqZIzIGJ2t/iX/re6R28LjtEazfxlHWx7+5RXrJaMzY3R+7JvH5wwQrSfl3Cx5X07zkhfjtCx9npMBuKwZR7inAUYrpnp+4/Wsk17SS3p30+MsViKL9XmJ9V4LOteg7PNhcytZ
xOtVauOMj+5xpnUdaES97TdnVJVWvYkxIeotOyEKnGiOtFJELkV6vaGCXw+y4L+Zcljq3iwKzwC9oOcBIvV7jOdpkeKsO5Jj3I9XOBZ2vaRcivmWucttEf1L8+PFxnumWCMTNnzOXcHXcxaHqDKcZ0S/0fR4gxzI
YmeIPc/fVdnRv6TZtZxHkdKCIurRWv/mOAOxMd5jebhMjEe2Q/8y2zJu+Rb3K5PL9fv3WOsi+o3aRw6xxdgJfKZlscvqvU7BfmOsf3kqM3a38TnpJb2k91P0+ok2vBhiVjT0Ix3GrhqJDD5/ygqzZA1wWb5GGP+E
33gccas9tv4R9PbfVKVVj5Jhh7dNsWeR6/VShM8cHgdgoUKKI7BOgbwpxxH2zVFv31uO+zN0eB46zZnZI92yKDt+/uzHojs6ysMDkpwUQW/ifaLUTG/Hxpn70/i/IU7IxTRjmpsjJcM1Mj9Zvi8uMmpH/zfDac+a
WGVIpSzK1zPYybVEruSR1/MtvWOF1GeKNfdrW4wiP7JoIs0Or+q5x4zHHteH0pzjMY64bWhk600pLXYbmTEmi8yMBfmXV6yXDMyMrf27qurrZ4/3SS/pJb176vUDbfh5CZ9kyGQ5vVwM3O5yesXgAUe1UYhYGVaJ
2RYbPp4262+esTZHHE/rlROLGfdg0XT/GlvonxxZ/zy2MkbxOSfeP/1ZkeOMcdqiRmnT0x1Xq8TD/WWmj88H/p8b4nGPzhJp1jQHPfzfEnvclsac79ebI+pZHuexFGJli6C3f4vY48i/N+i+PZi/BRDUE36Tonp/
x9l4QuJm9+yR3k/18H8pDsixe8x4HGl+VhMJbokR9ITf7BE5lc8x5ETGvFGWH8OrkL+k3utFtS2c/uUs/a15ZcbuOz4nvaSX9H6KXt/RRiegZjkusc6LHImMcRm7ThJE6n/sv/GYbbHYYu0XcTwV76usUdyyEaKs
1yiPNxQ3DtFrG6Oe/oiOZ0aJeP7o3mv0PE9SL4Uo9W9/pNPG3BpxG9Tr8LPLHntq0Doj+oP0f2ccPOKqx34bvSKjZjnmW2w5H7SWKHKves/hftRbHwHCKRYe6T1y7HQRXowe2ZhH9KczTrM0k6rGArf1jOifs99o
DnplsgmzZPWRxg5Mo4nPx5F2zsXL/FC5f0Kfz2XGvst4n/SSXtL7Kr0hM7X1em1XtaSX9JLe3fU4kbEsGTqXK4vx9ZyeNOZmsUvWX4brLcDbhdpXdvT3G5+TXtJLej9FTx2F7tW/pJf0kt479Fw05mYxzO9601iQ
f3mdH8poTGGymHHws17fpJf0kt6d9Y5j0N36l/SSXtJ7h56exYT1lx405maxi9dfhus5MmP3eT2SXtJLej9LL/wb4Wcfb9JLeklP12IzY7jeJcKn/CL/0tBX/3HwU1/fpJf0kt6d9db5JXftX9JLeknvHXoii63r
L0N9ShOLvXD9ZWDERaJaf/XMfA3W5nzI22kue/J8tOVc9VNbzQ2PM8QWYw+xhrhAHIYMIoH9GjUuLZnH5q7vl6SX9JLetXq+Y9B3Od6kl/SSnq6FZcbU9Yjn8mOb32ip6cLjwv1GlucqD/fwyPWWjcDoutMG14zW
2z1CdI2DPq/HtLRL1c9dV1cEyKto8rFvl3ocx4aU49S1Y9VMVdtX9QTff9u2qkjRjU0/Dl3bNGPfNRDzdqy7oWvykhJb11ivYv2V75ekl/SS3rV6578RftbxJr2kl/TUtq6/5JUxTDS2Vn31oLCDf+mXvfKpr6fS
mMpkwj1wRBVWo6vliPX1vGnM5/WYs75supl0bTUtQFpDs+APWcZ6KIeh6atsKimNzcNIhmIx/JBqyLv++ZjGFuBtKWcyd3F9mjPaioa254M0tNn3YNtkEzb2g7fVfVe9nNAmPm663/gM+PN81CNtYp/Fvdn9eUeb
uB/by3W8JlVTb9S+rHompfD3y5l3W9L7fnr2Mejr+5f0kl7Se4cez4xZWWy9XqWnM+jMkmn8xpjM2EZevJ5bKUcTjblZLOz1mJZh6rMl6/pqnqdurrulm3rSMsKah2kBvmqHoW3rmox91hDGZHM3jkM+N+MAsRr7
IQP4GpqSjG1VFUszlSS6Hq0/OdDtKE8y2hlG2tgjbD+mwfTY/V1DW9nSxm6L9zd5A++XJhcfEXlKvN+nx2M1wus7VhJh9bSVM21Mz05y4v3y8fr3xnZGv9N4kPTer3f2G2Fg/3Laxo62/W92bV3d1c9HV48tbWzb
u5+/pJf0vodekE/pt77Rx8WUo3JVC9A73CcylNmnFFxKRl4lcynRX/WmsbDXY67JMI7z2DXVNC/IZHgbSGLoByn3lfdL1w1LU5ctWdqmKnkcnw9KYKRt8yonRbOUy1KPfd/GvbqMN/xozMRcrLFM0QD9o5TGKKii
gDTiAzX7mXPa2G12P9uGba97BvX9HJp5Yp8jaybLdLyqqv14zefvXGbsc8aDpPduPd0Y9KL+IVsNBW0IY+PY069fE8GGl8Fkf7/wt9V2Lf75zjoiu9P5S3pJ73vomVns+UAaozmxwk1jbhazrL+0X2lMZbGFrZdU
54BJkXFYlbdZwW+zmO9RHAdjX495mYe5nfMur4al7MZqASLrKuBJzmekH5tpGeZumni2rJoov5VNW/ZT0XYVnWxGmWxoSyCyBogsU2eOhfTP5O2xe9ijq54fjdHGthQ5q8HWj7Q9H/wRJDN2W+Qf1RM0OYNse/Px
inqsZz6ZsdVvjOtNSP/iWtL7qXpx3whd/YM/yQUaiwXNcwF9Td3M/pF6zshI5rmcinmGMWyB8YrMMFrBaEb/tlvaOmw8S3bb85f0kt730OM0Vhp8SiuLGdY3RmfGuN/opDFpbr4YxftL1AugsXOvxzTTmWNL0001
6HUDMNlMmWwegMjITAagLp4gwyn/hLTAu1UxNe1QNRuT1SuTTVM7V13YzLG9fyY64R4jOnyMp0RuO7qUlF/EOWDscXG2FrvH5FkePUR6PXqxN2xvcSuTeyg6k4yaBp6vE4+X7S0eHXsGkUFNZ2bVM/meMZmxTxwP
kt679fYx6Mr+zdCAr4qpo41ME3wDbAeAKkJK2ppu7Ns2a7o5X6Zphu8fLAMGw049DdNCv18ihQl/jfc8f0kv6X0PPYnFpnyh/FKRogECo9cKL85mxjTrL8Vq+Gs1Vu/MGPcbTUwWnBlj6xfOvw7TMAzdvAzPR7fU
BTAZWZlsyfu5WeCrJxAY47C57buGTDPc7Ka+JVVLx8mq5kQ2USJjt5fy+ZiKcQntjTlTZPLzTPkikc/ELJmfHsucmZ5Bx0iU14qmxsYeJwtt/nO8WJ5ufR7K91mm7ufXG5XFWP/OzOCX293Gg6T3fr2Qb4Sh/Zvx
Z2poqwltM7YFE2Y5jM99V1Z1OWZNtdS0ZWMPA2Y9jnkzTvO0TDObTRbeP/v3F/F74dTSpmbyswn+frXriGJnDajnzzTyqd9Y/cYD/7VBuhy+qsf2U1ctveb9kvS+Uu9IY1oWm4slK1fOsvqNtqhSGEbUC/Ip7XHz
LwN9ynOvx1wQ+K7J+Qu4DIisHYo2p6YlUBj9V8xd3zcE+KWGAXBEZ7NnGTCJyXKsf4FMtsC3094xzuj65z+j/avff67Gc2/CyBhyvLH9O5MZu9f5S3r31zu/pnvq6KyvcSYVoetdCE1nw1eSaZzHFv58xrGiU8Tq
iTbGZ800Tu0IA1BVjHO95HOTDUBh8NMPZUenis3DzPNrITS2N9NfDPv+5vfXZcrbm9dP+zemp37nlOdv4HSLyqfHpty+/H4JW2ukP3/n33NiS3p30VvrP4fQmLvCGPcbDwQGjNQCIglxe7TFLVvT/DGqZycwae6+
ymJizLl/GeFT2l4PPneswLljU5/V5UJnZFTcm2zGps/nida/mHusSbYSWaYQGfDGymSYRRtC+3P8O6bjFXtE9Sm/9v3n1jPNabONlfvxxjWd3rkZ/F93/pLe3fXcY5BbjwxTMZWk5zGD2E35VJAWbuekobEdaAJq
fT+TZe6nam6WCsaACb4zzgBzcG9W0R3rZaybhWRAdRmbORbeP/tcCXW9tfnvVx0Dwv4aj/0TZz2IHGZqfuOBffat7Zzg58clMyN83y9hLem9R0/KjM3IYhOyWIcsRpDFJuo3RvmUhmwY1mcV7zNy2JYZM7mRnMU0
9V5VGgvIjMW9HtPUF00Lw1xOWWwsu34ZR/iitND14tS5zLu+WlhNMs5kVVcAk2XIZASZTKgTy+4P759pBr+petjd38/rek7TaoTwccvn/IWMjPc+f0nvznrnvxGSgc5nmKqBDMuwdA1682MG/3ctv41ufdEVXZ/R
Bnv1dNG28DPTf0Bk7ZTTv7cpH4tuoQ2N/+BvbfJfjLh+RuUV+1+XuIp7/Wtk+TX7GiXj2dL04vx4IPuTbH5EuE9pegZ2/l7z/kt6d9HzpTE3i23Xg7Q7lN6rKTf/ElnNTmNifszEYpj/OzWD3/16TPBtcpgn0ndt
zuOEce57iAuNc9YPLRxaP0IsIMIXNBphfKl60lZzLVxNaRzaNnjO2CvfL0kv6SW9K/VMY1CIHiFTOdXDADQ29WMBQ01PijFf+hEGy2roaC2g52OktX0KGGOmljMZ/9wXftg97NGhps1UbczVP9M3QnXmE9uSzZcy
05iYybJn3diWMJ4acv9sD3FduM+RyP3z/75mWqe01rsWtzrzDfMu7+ekF6vHWawCLMnKGYArAxaDb1PAYgTroxN4K2ZAYwv9OzpT26Lg14O8qrYFvW31LyPmjH3965H0kl7S+1l68d8Idz1OY91Af+pyKWsAjCFf
hjIvsgIpLCNZPmbttLR1U45tN3RFB98Tm6kp66kmDXzzpvW9W9Iu7dItmD87UfWV8YuZTuwz5CWljcXg+7SDxnwIZs+MUb6yZ9FMqma/UZ3BbyIsLB8yi5x6JLbnw8WxV7z/kt5d9Ow05mYxqd5rXG0LyaXk9V7t
NfjFDJidxUrUy6+pbfGJr2/SS3pJ78568hgUp0dmWrtiKIYKGqmachryfMqzgY7PeZbh5NSMLEWXzUvWD924tGM1AHINOFl/BAhbuoEW+S7oYkvMsZFzx+vHS8x/szOU/5wxv3rXIXPG2PFeN2P0/PmL1bu6f0nv
aj3BpczQpcwqQr8vAIG1xUhZvJhWJvPkLMWN1K6/lOeRHWfwixRGjtdAAr0AGjOwWEEzZuv6hfu8Hkkv6SW9n6UX+o1Qp4eVxJohH0poXTEV5TDCKNiQIodRfKrp+D4PVVHUy0zysVoWMowTxH7sQI/Wj8kWMi7D
SEqkMTLMw8n5EXbfzseRW/1Btq3perQmn9LkQK79E3NYKpPZVggdr9d77v0Rev5i9a7uX9K7Wk9HY0YW2wiKzuc3z843zg3Trq+kFIb+pcJkXnPDxGpj2z3oX3rT2J1ej6SX9JLeT9Jj3wdPzuCfkcUyoLF86HI6
f7wYezpKTnSYzWZ6jZVs6RpSt8syN3MGMZs6iPVEII5zsUxTTTpSgVY20Kr9J4/XuIooY/Pb1VoV+m11dQKP2wvz5Y1rlAy9VOpJr3p2H5U1sSa27Vnu/P5LenfR211K9v5z+JR2/pJYzF7vlVe4yGGMoHUuukN+
TJ2zn3O/EX9z09jh6pRiRArD61UG0Ninvr5JL+klvXvr+Y1Bdj2JxnCuEqkAHzJqVwKF4Vi4LB29xtoyVeO8LNQfHIZlIdXQQMz6ZRmHhV4pidLYmI/VWH/G+Ut6Se976G00NgKnLMBieTUXHV4jfIJIKSyvZ/hy
lWM9VfUaRPZouopRwdc3Fnx+fQfYVNBvObBV44w57KWJ2D/tI/AMNFb4DCzW9Hqc9nHwO7y+SS/pJb17611Q2wJZDOvHUhoTI70yOPUucWXk0ELD+hfDAryVM+ZiNWHHZhxHAiy2TPlY0ishfcr5S3pJ73vohczg
d/PXXk/Vh8Y2FuvxHg2L8fWSnjRmjBuFoZ43jX2H1zfpJb2kd2c92xjkqzfnczXXjMmkOPFYTjWNzwf8TyvEVlud2PxYIZbSGPwrpg85f0kv6X0PPSEzlmFmLMPMWIaZMaQwyi+YG/OiMTeLcb9RpDHGYYybgskL
/UZvGlspzMxi3+v1TXpJL+ndW+/cN8LPO96kl/SSnk7PTWNuFrP4lz6ZMYXF8PqSNg5je3hH0AugsdDXo8/PtufjvEbSS3pJ75569tFEHYM+6fMj6SW9pHeNHmexms4Zq7Iihwh4QfmqHop5nS9WL2VOZ43FZ8aE
+qwqjTFGKjlnNVtUZ3rp/Eb/KFBY2QCICePgXV6PpJf0kt7P0ov5RvjJx5v0kl7S091rojE3i4nrG09lxjiLcb+xVKKdqowR9GyPH2jsLq9H0kt6Se8n6a1j0F37l/SSXtJ7h57MYs9HCI25I/qN3jRmoDCBoEDP
i8PcFMbiun7hPq9H0kt6Se9n6fmPQd/jeJNe0kt6uhaaGVPWS57MjNH6hP405o7YP28ac4+Dn/76Jr2kl/TurXflN8JPON6kl/SSntrW+s+eNKbykiYa/UbLHDCbG+nwG/3igHoYQW/77Ypx8M6vb9JLeknv3nqu
MchHj5COXn3SKz4f7q0+6fwlvaT3PfT8VlNSvxHXU3rRmJvFDusbfWbcW6OHfynQmJvFvs/rm/SSXtK7t975b4TPB2eoZSrrQoxx99/x/IlXLhKufwQ/4nUuv65/SS/pndULqm1h4Sx+Pci4bFh/iDW/PpOBoYJj
i/4l/i/H+HHw+HoQ9jPtjVW6pie2qqpCijmPdVWu8fmo6mGmTdQgM213er8kvaSX9K7U049BYXpu5no+gijtg84fu4L48erg9+lf0kt6fs3GYljv1ZvG3OT1fHjQmImnGrxikxRBT7nPEDvQkKOGxc68HnN9bATG
P1KSsl4IqSces2Gs5moaqmpkt5uMTDWNsAvdmpSq0p3eL0kv6SW9a/VivxGKeldkxp6PEBq7z/ljV+pm1/EOyY996vsl6X1XPa/MmHHO2PNxalYYi0KmCvSU7JWGpLwj6FkfDx0Hza/H1B8bXvGta/qpaWoeazI3
eVNOWZNV41hX4/PRFGQEGsPHx542SaWj7U7vl6SX9H62Xtl0HVlg5CRNfoWeOAbF6pnmfj0ffdXAF+mhbZaQeMX5Y1zEGInxkvho19AG47OQ0WJbZRM24YflvvjZGmkTH20r2tjz0Ouf7890nZ7pWJiSqnrF+fNp
Se876UnXpkQWez4kGgufwe+qz6rO6FL5y0JhuF7yBJ8dWYyuXzj/Kswtbf3SDnR8of+XE0YCsS8HjD3EruwwNhDbssZYQWzKEmMBsS4zGouFaj4fc3uf90vSS3o/XY+SGGUySmWMyc7phX0j1OuZMmCMraZ+KOXY
903DbtPxWX3kivNnIhj1fnYPm/vFKM2sx7ZiDMXuZ3sw5nqlntpjxms61rzi/CW9n6an0piFxdx+Y8xM/BbXS16WDSs7XC/pTWPucdD/9QCGGisYE0nbjBCbZoBYN+2yjKRaIDblQv0A+H+C3+oSHh+rsoNYljXE
ooRRdMyRxprScSUVc//Eccb0nZC//so3wwrOX9VVnX7sKWiCD5q4hziSqW0G3jWMyvh9uMYf0V8wjeLrN134/NB+1/Uf/eVjF+cD0yOXj109Ij5aG37o9322hX0r+TPimvdf0nufXhiTmRv7PnjuG6HMYsxv9KUx
N4vFnT/TX53898H77+E0sm2qkbZ9bph+fLlaz0Zjbhb7jPdz0vtqvZXFeL2H2Y/G3HFbL+mzytEjJ7b5jX0+ZsWpKOldVeNnfT2QxnIgsL4tt9i1G5+Nc02Zq6XbMDIDIiNIZIzLWuQyeD1YziyuNzjAVOIYAeOL
sBqJjYPiPSJPcUaxftNcj9dn1HOxUIb5WHFsDvvurHse2a/Q6Hkfu+7vjW1l9yXs29x1PEh6Yc1EZCF6PmOQSy80MwbjSwCNxZ0/9a/ONFqofqK8XpL9FZnpSf881+mp9zBe86WxuPOX9H6anpQZs7LYpesb1/WS
8vz6ETksMqJe4H62cTDm9dhYjLQ9xgFjR7ns+UAyaxsYwElWU/bqqlIgsxnJbEQm65mLefX7hXGMPo9E+YVt5f890MQ0cv9MLMTGQZwoN4pjon50pf2Loz798dDx1D+LJj2P0Pt9m+Prod/Kv32P8eVn6MVkyXa9
898IKYvR8U+dNcZojBGWf7zi/B2z8zsPqd9Q7N/X+HfHg6v4fIT4ilfruceJT34/J72v0RNq8GdVRmmszpDGCK362mSUxpqcZ8YchCXWU/WKK4sZeAnXS57gM7feuXFQfT02GpvbmcaO5sSmdoI4ti3myvLNv8xr
6lX2Vbty2fMBZJYhmU1sftl17xfx2yIbk0LndLD5Ebqxh42uJrfS9M2Vrl/YCUzU8Pmuq3MpjX6oP11K97P8munsqrlG1zYs/3fuNbW//5Le1+mRhemFOpfmMci/f36ZMeANZwZsysep95ylau+fnYiOtSjoCMX+
3sS/crWGmDoSiDPuxee5Tk8e/1i622cOyLnzF96S3mfraVgsxwr8nMWw3qs3jbkj1mc91qo4QVjoN0bvrY6D516PjcWWjsUS9FYyY9myXsiPVU2DWTKaDRsqlitjLmbB5v2fe31FEmDjhchLbIRh40vIDFt1/VNO
aFvzV5p+KHoqvYmeAcArNL/1TKbvuuqKKXb/6i+Ezi9z/b2x57PPBPPZ5qvHg6R3Vm8gNJZAOpTFYAzoXHpnvhFu8wWiZvCLSuPQw7tz9S/Zb2fOXMj48srXI1zPKztu2Obr339J73P1XDTmZrFA/1JXBey03xjr
X8aMg7bX45gZaxfMjJFDZoyxWI0sBnoNzYYtdYdMNrJsGVuLGfv6hs6xso2VlIfE+5ivKH6XtPOFuC/FkedjrMuMNvEbqujqse+e5hn88jddup5EJSxc3jqb5szbjl3vX9ob01OPSn6/2La65v2X9L5SL25O/3EM
iumfjcWO6yVVGmPkNZAWugFaddWx23oi8+2f/fvTnqOif2+veT3imnn+hs/Rvb5/Se+76nEWQyqqcnptSspitH4EpzHKYfCGKwsKarE5Me5fmmuynvYbz2XGrno9GIv1MP6x/6MjXU05llvt/eB8p8EJiNVzjTz+
fgVbi2miN9Zv3XrOc6/L6//efGaImbe5z3iQ9GL0XBRm1wv/RqjqmSqN2eeMMU+yh/GekRnlMM5yeFvcKrx/x1lj8o99Dfa51+OcnmmWhOgAfGX/kt531dPTmJvFNr8xNA9mYLFzfmOsf+k/Doa8Hlt+jOXE2Jwx
Po8fM2N1Q/28ZRyribmS4gx+Vofs3OvLRgzTuiU2XT5E74yzIPsVZUubPfvPx29lTWPs6xF+/uxNPYvq+Vn9VftWr+lf0nuf3vkKF2wM+srj9cmMfcrrkfSS3qfqiSz2fGw0NmQFVt8vojNjDfqDvlcretl6SZfe
VbUt5NdDmTtWIJPR2mNDW6FPOeGcsWqrQNZVFVtZyerDXvH6HmuI0eONu6quniLC/Ap1Lpf5/Knrmc69Hte0o55Yf9vk19q2ueN4kPR8m5vCfPV8x6BXHy9jr/g5Y9/r9U16Se/detrMmJHFvNZL+vCXfH3JF66X
PJcZi3s9hJljyxaxzsXzsc3gn7YZ/HlNc2JTneFssSZkttjnv/+SXtL7NL2r6r2uetd9Izx/vLIn+RmvR9JLet9Bb63/zGmsKAotjZUlnXTsxVzPRwiNuVnstf7l+XFQ93qcmS2G9V7Hcrnn+yXpJb2fridenfIK
PfsY9PXHm/SSXtJ7h96WGSNZhiyWIYtl9QTwlQGLFZRfgMYqYT1lKG0douJfvnC9ZExm7Du9vkkv6SW9e+ud/Ub4aceb9JJe0tPp+dDYxmLGK0f6Xw9SG1+2XtKlFzsOfs7rm/SSXtK7s55uDLpT/5Je0kt679Dj
LNZSMuEsViCLzc9HsQCHFSVQWFOVJdLYiSt4b9eX9KKxUL/xfGbsHq9H0kt6Se9n6cV9I/zc4016SS/p6fTMNOZmMfQbT/DZkcXeWe81JjP2ia9v0kt6Se/OevsYdM/+Jb2kl/TeoXdkMcov/jTmjp7+5cvWS7pY
jK1fEM/I1J9pz8e5/ZNe0kt6P0sv5Bvh3T4/kl7SS3pX6YVnxix+Yw8qRZR/+bL1kqGZsXuMz0kv6SW9n6J3ZbXD43jfTUM9zE3eVX0eF6F/+TiTU1eq9P88SnpJ76fqrfWf43zKA4VtLBbsX75svaRLz4fGvsN4
n/SSXtK7p56bxeLH+zmb5mlc8iWf5z0+H+JvrsiY7D2fR+/US9eXTHr30vPNjFG+8qSdPifIZ8TGWe9aL7lFLQeaWSxufFavwSbWvw/5uffnR9JLeknvKr3zmbEZ9OaKzFNDuq6aOjJ0/TSQqVumkcx9DhEGJ3oP
i9089YRApI8WPPZk7GbSjl3b0PrUy/bjprH7fr5ZzpnEYuz6ZXfqX9L7eXobjRGZxpoMOawuS4hNWVFCkDhLic+H5pE3+Y3OaPBXz2TGdOMzI6m2ElqNrcHGfjqh9dgG2uj1xWnzo7Gv/fxIekkv6V2jZ2KxkPF+
XuZ5bicyZX03t3NG8rmephGIbCoofJFlAN6YWjIN2VSToe+ngjRAYDmpOmAxkncNGUeQGJuhbYa5n5upt2fGPuPzzXLOAjNjn368Se/uenYWez4ONDbkU1Y4ooXF3r9eMiwzRs9f3IhKsrEcBhjVKvgSOsE31KXq
KxifIQ7Y2CWjCbYJ20xbnWHLaZvhG+xUwijZk5yUYzssd/38SHpJ7+fqlXk7jMPU92PdXqEXnxk7jveY+yo4jVXTODbAVDPEahqGeS4m+NI3Z1PVL8htLc+edaTv2gkGJvg+OJF6hG+N8zBXZDyTGaOk83y4aMd0
HVp2m92/mgXZBOO95mq14hVgxavfajSEbeT+1djErdi1ffmx9LSVM23s0RJ/qpw2+Xq9x2sCr9/Nkx+a9Fx6nMY64Ch3ZkzDX89HCI1d4DfG6gX6lHHjPf/rw6yXSl7VQpvIX3X5fNQltIq2LqPtXGbsMz/fkl7S
+xQ9ymGUyCiTUb1wJpObPAadGe/hW2A5ZMBfC8kwM0YmAsdbwbe6YcqHYWrJPJRTTUgP3/pI19eYGZswMwb3jqQdx3lY2hLu74Zclxnz758987SSEuWrtbH72H55R5tIROxRpse20T0D65+owXjP1D91G/l5KK/N
nMwYjTEyY1vlhDZ7v2XeTH5o0jM1DYsBHxTjRmOUw3I/n9LkUn7lekmfzJh8/uJGVDEzBuMfy42p7FVgK3f+qtkPWpmmzFj45wfBxp5S+k6Izy/rsR9xK/Z9r8CfERvTY/cwuhS3h88j/LH3RtTjj+S0MT22zXq8
pj3Y7YxgU47LtJdZz+fY1eN5PhhtZ4Yf9qjmDKCgeKSxr6+9Jb136MlMZiMyl15oZsw83s8VENgwl9M41shkOWa48rmbM7i/mQgFimkYxjmbmqGalqno6XhFZ42VU0fGrifTOLcLsFrb13GZsbV/JhoT80z9QJu4
jcpc8vGyvBajHdMzqBqx/WPPo+FA3Ib5HYyv1sbuY4/bn+cVn+dJ75P1JBori5LSGLIYvRJSbmIxXC/pTWOX+o2xeqcyY77jPf80JrQZyaup4fsRRDadrMM20NZVtMVkxo79GwraVPIpW9o4LQj3iDRFfyhfMeYR
aYzRncga7FH2o1IGa/ReykN2FhJVVXY6Pj/lIf0z6Z5Hc//h2OnxSn0Sjl19HvbDXl+/18NOY+Gv79mW9K7S82cyUxt4vcPzo/xMJ33V8J0OxpehBQIrSA281Y09fDus4Z0szCCDb4ukn6eKdH2D+bEFvkkWXY0u
5TAuY9GOe2YM/j6ifEodg1C6gf6Nu1sob2UnKT2LPR86GlMdSv7dzfDM8uel+Ex7z2UHUszo2VjM7dde9Xme9D5Xb2cxyi9GGmvLmq6mbJd6hq9MXhF4g/4/QxyviKgXrzFhX4QIevD/NbUtaGbs+TjOGtvZ60Be
PTbkL/YXD0MgNDkzBnqaWWNnPz8Y89gzSSYWkrfkn0cGopPOjYGFqpK2bqStguOlv7FH1D18qW/fC85f4BEZ+qp8/q5HzfpvIjZNzyQW+xzeSHqupiMyfz2/zJjXeI/0NI1k6emsr5qM8zS3ZABKq0gNfJCPdJ4/
ziKD/g3DAmNOC2Q2TyWQ2QT71cBnbdfAKNa07TJDm/wyY2r/VNrxvyen80u0PqXqDGpyW0b/kukx51D0Fe0OpHq0q3+p67ndpzSx2D35IOm9U2+jMXgbuVgMvh/VfQlt7pqGeN4u8Hatuw16hkfibmP/gvaws1j4
+My+LuGfY66SF/CfwF71hG3GttDW4Y9/Ziykf6LDx6hJ5Y5Vz59dWGNsp7KYWY81RjOMbEQN0/bwfUFxKH18StPxwPfpABpTmpJrNL8ecZmxO/FG0nPrhWbJVr2rqr6u4z2nMTI3UzYXEyEwuEPvCDBXMzb0G99A
a1ssQ8fXV7L8WEHqbiETybpyrIemgfczaPTTiRn8Mq2s4584Q8vuNKq5LTEnxngtl+YL2Gfws+3VGWf9SNs2f42N4spcM3GlgPps6nOu9YziZ/CHf54nvU/W09BYVRAgsKjM2PNxzEApsavbsm+Wuijrpq1ImTdd
NUFktw8R9AyP6GK9VA0MKWKc98j1MtyWx7OZsX18VtdT8tyXgbyaDFuODf9QaWYM9KzrKYMasALocV5g44JITKHsQj1CGP9qpsdYhD2e97SZ2EXV28lr9wdFPsMvpcZZa6rTyVho9UOZmym6iOyH3U/6vbmPnebX
fM41ezZ1tpikCoJ0PmaMT+l+/yW9u+j1I71FZ9xSGhuHdrDvY2OxmPEes100x1PCp342D1Mxz3NHUWym88dbeAQG+LmdlrGlay63/NgylT1O++9zUozwRw57dFNmYzFb/1Tacc+novOvAo7UORvrDp+/Lj/0q/uX
9O6iJ7FYVQB5HVmMzg/baMzOWR6xof4lcBhnpawcijo0Vl1ZFfkaga/gf2mrtsqKvm5orBbco8Vt2W0h6ljszPjMv1NhSmzlL+qv1rPKXk2JrcKGVmY30ebKjPn0zzTHS92GXo80zKdkvqKYo5KfQe2fuPdQ0qbJ
EQnOH99G4zeqM/hNhNXmtInfYtdesv6F+5T218Oe+wrJjH0CbyQ9XfPLjKl65zJjGn+Q1rYocT1lN5fTTLq5mCa4J5sGalxu+bEF54+18M1x6hdcXwnfIYGHym4cx2Fu86km09Cdy4zR+VzQetpE907eyj9rJB5v
fBV92/k713z82nv1L+ndRc9NY24Wez4CaIzlsJCayrbo86HMijJvxEjzV8f7xFh01CASI1eCA8pnkbbYPTAeLLh3g1sJMS4zphuf1cwY5y8DeTXsB4vBPh+YEu/clcZ8Pz9YLkjMYZ37PApnFOHMCPuytZPrekR1
W/bjs6bR9XqcO97gfayzyLbzFz2D/3bHm/QkvTPz+NUx6Nx4D7g1wAi0TPVQw+A3TQPo5XBfTSvDknkmc0UaPoOsAWKrcYXlhCssS9gz6wcyjlOXTS2BN6rKYn79E+dQqX6euA3ntYtmt9/t81fn196pf0nvLnqc
xXqBxepiykCvKUpAH+SwounKJis8M2Nm/xJ/w5wY/JkXbb7AkLGMfTaVc58D7JGsLRfoTjN209jn2ZQNTcfub0Z6/0Rg+zZrypGu78k6gB0YJ8oxq+ga7GlchB/YBX5vFhggM7Zf3lYVDJhL3mb8/n0c3M/fmVGZ
Z8b6DsZn+JqJBMZyNLzkPua+uhnbQBurzQ9fVaGh2ZfrM2Nhnx+m+e7sfrrS8vkYInlKT0e2/ol708+rMrc7mqsfal/TGNau/Pxd/Uu2ZtV4hoQ5ZZwuLSx2f95IerrmS2E2vZjMmHO8z1g9/qWcZxj98plM7bzM
/ZRRt5L08whDcT530zJ2MGzT9Y3UrWyGepqnome1xyqy0CxZTGbsLp9vSS/pfY6eicbcLMbWI4b6lHVH3cO2oZO2KT0BW2XlQDGGzXccm6bJMsZT9P6Jz5hssD4y7tGwPdg9dLux4VsincE3sSIbcT1OQeWE/YDi
VoZruqzKqpDMmH18VjNjbUEbq1dRlAXOx9t/igq+D8L5ZrP22XWRzmXG1P6pdbREVy9E73xmjPGVPJfL1HgdLweLffXnOTsSnROq6qmz1l7fv6T3Sr1xYHpnqlqwto5B1473M12P0w1D3dRF1cxkrklXl9VS0VWV
2Tjz2zAGjzm/nU/1ULHbE2zdAc3RmrBDPs5k/NTPt6SX9D5Fj7PYgCxWUz7wpzF31PmXJhorB0ZN09hnlLRopL/Re8uBMRWtT7jTGNtnbGhOjPOaRGMKi3Hq29luXb8gnpFz4z3PjbHc10IbJS5oOGeir/fG7mGT
2cX7xczYvT+Pkl7S+4l619V7Zc0/MxY73vdDX7aLevv5MD0i3n7n51HSS3o/V4/T2FzkQGNd0QCLtQW1uEvOYo3EYnQ9Iq3bRWLjkcVoPS2RrTiBAVOVSGpNS8mJ5ctkqmLbH/1JOF7+0yxjD5H5m6iV51XeFzn8
D5Q2ZbQstZPFwsb7zPDDOEvWE9lL/bn288O/Jb2kl/TsevFXp9TrXVXb4is+P5Je0kt617S1/jPnsAzuKOqxzIDAqrLS0RhmuFa2Ijrmej5CaGxlMUpZQFxT049tkeVdtvRNVedZT/PtwGcNMpjkU6LTiPPBuqKq
hr4uWjpNZwTJvITfm4mwuWHoZfZsFlkBvEZn849TW+ba9ZR3GO+TXtJLej9Dz8Vid/78SHpJL+ldpcdGApYN4xSWYU6s2fzJnNb/4zQ2wjYE46jcXuOElKaLE7AY1p14PkQaa3DOF/UbR3pv10wlLZczQ6/oLP95
mvqq4fPCdhZjPmQ/VgOdj4QZMp4TIznOOKuKsa3ZSoGZsh4hOR36xFn+Jhb76vE56SW9pPdT9M5nxr7P51HSS3o/V4+NBE1RAmuhN5k1Nb0WJXBYDXGg9UIhNljbgiB/6SLzLwlmwOw0hhVYxdWU0wgY11ZNX02E
U1hT0vxVX9flXPQka7t8GQfqOnK/EddFlm3R5UO1lH1RN00FJAnaNdZ4PcYJ58Ph/3KMz4x91nif9JJe0runnp7FPuXzI+klvaR3jR5nsRbJS4x92dD56BuNYQ13pKrJEPX8JURcfzkCN5Ey64oyK2qayxoHmvua
SDHTqux1TTNnzVTnZQUxK6uuLuuiQ6eRTDP9v+iquW8rWi+DclhNOYxzoE8UsnjyOMjO3x3G56SX9JLeT9GLzYzd4fMj6SW9pHeVno3G3Cz2fGhozMpCQFgFEFZXDgVBwprahU7AZxT2fCCr5W1dN2UHsS47Rltz
PuR1OTMHcqi7fmS5LcZtpmeD/ikEZqaxO7weSS/pJb2fpCeOQXfsX9JLeknvHXoqiwEPtZJDSeNY4vVYj96kTy5K8C9ZRM7iuS/krKbCSJCqKqSwEbcckJpKJDLcpq6Yf1lNNCfGYk2Qyei1lSq2Ld/PI67rF+7z
eiS9pJf0fpZe2DfCzz/epJf0kp6ucRrjM/WFqGMxPmf/+TDM3Y+MfP3lKESVnhiTIbEx/pKIDCit6BmxtSXoeTKZ3zj4ya9v0kt6Se/OesNW7/CqlvSSXtL7VD2+XlJHY8hhEo15EdbzEUBjA79tYTHQU2msLssi
Lyc655/d5kzGsmSiRi/Ejut1MT6l2thVjOj1ma5sSS/pJb3voneO1dh4DwNNneVlnvcQp3zBK6YUWVa1xf/P3ps0y67jCJr7Y3b+w1v3oluzxHXVtldlvYuNqKEyrCIjoiMiO62srP57gyAlgQM4yP29e869cpnB
5RogSu5OfgQIsKtUbiItW8wXqeSIe7umBtnjOs4Cotc/P8y2HDl6kl4HJeibrHK8KCP6oO8NV41LfeQM60aCPvKJlYKcJ5sB5NKMoE+vEwn6vG3dSuSCOny54RUOqbbsWl9fwZWqvm4mNVEKyqYRVePIGY7RsoYt
IYl7QR89tm0kZnNXcmgW0KRkbeTUbI4Uza6yK4CstFT2l+sTtNFqOpccubY1aLK316gP3y2psjkcciNyh721JXH7UKFUyavg94ezaVcB2WBUopatiVNUssM4RS17zOOlZQdHtqBPHdVgZGOjrxGR4SsTaeaXVNdW
s333arZvIwfMHjacOcRq1jJGWEyN53+fNayX6L8M2b6ApIxXUkJdshipvZFmrNlWi3XD/GE6w5ga4//5Uc+GyYjn8tTUoya1venmttIyxmJfuz/96Hv0Pfp+BX26jkqzmKqfAzQ2hGksLVFfNo2lCcuU71VWO5kL
9BXQWFpi+SiNaQ5jaCzNYqgvm8bSLAb6CmgszWLq+bE0pmUOf53HqPvNJLYYhZ0shvqyaSxBYSAxHjGbxtIspp5fPo2lWUx9vyyNEQ47LWMJzx/6L7NGazlybuUwK3bqZySvRuW06OD/q9iq61yprWFi6sa6VRkx
VqkeisqL0TS1igBQUZaEuYy+Rcdf6v1a02uWsZ+lvn/0PfoefV9Vn0VjKh92pSb5RquXbxkLS0NYnx/Z1rABCWsIMBeRKn92Po2lJc7Hl8FhETmrGf0OCfrSHEZJiW4PMBfou6xlWm5E5ljGkLwOqfUZDqPSZjKX
rXxpWEzZTyNk1jtMdrHYCnym5QiyMlKofFDqHeUM22ojKXPNwG22pHuN1JwF7a9LXT6Zabl59jEqV9Sqnh++KwlkVnMcdkrFWfXJXJrC+nML/D9OGqsNsTUsk2Xwl+IXzzanaMzmwIvMfAoT7QhXNhQG+tQ78Atm
GivnLN/f6O9Bj2GIxi7yMt5IskWTF9RXuxTDXA3DKMd6U7n74VyVrUxbw1CfOa9Tmcn0efBol7r1Wex71M+Pvkffo+/X0Bdnsc+PEhpLy9N/mUVjaRZ7o/8SaQv0FdBYmsVAH2Ulyl4ck3EshhL0rZ6djMgEeXmW
McffmKCxNIup8dT5NJZmMdBXQGNpFjv9l1k0lmax0z+YRWNpFkN/aJk1LMpioK+AxiwWC47o8vyNUQsYJwfZ7TrnheJxzHqx0Wz5YyvnfdcMpWW9K/JSsyENQs1fue9QxKWamlHt1bli7fkqJc5iWY91Oyx6jso7
lrEfXz8/+h59j75fRd+rljH0lw34KS4zuehN/sZyfTxzWRL9lz6NcbaqOIvNlr9RU5Vmrx2IqUFZG6m2V760yKtV42mAZ1rkLS079ETaUtGTL6lt69yO/rwW2auN0pj2VrYei40nhSmp/Zej2XNJ23+pZuyhfHbI
AItp/2WGNSzTMob6smkszWLob6RE9KJlDP2h2TSWZjH0XxIOc2iMi3hM+y+TNDYP8BOf2q7vxayZq92hKppU9n1Rt7uoV1mr7wOoS0B1VEk5qbkr1SKHam03UeuZkoDVxmo/uQ3W11XAj1dl71+lntnyYLHvVj8/
+h59j75fQ59hsamGmvtgsc+PQj9lgsUS/sF3+xvv6suksTSLGf9liMncEWL07NX4GA8KO1kM9EWYzLJ3hcjLlcqffFEXJymlJVgM9BXQWJLFlL3E57AwjXHjxCz5+XHPT8mxWMA/mLKMRVkM9N3yU3Ishv7Qcj+l
y2LrwWJBf2OhNYzKzw9NY32LHkr4yTS19igakloEcNkA7LXvFb6QzqTmM1iv2vlgNUVqUF/he73Vw8Fh2j6mZyNXM49X0RH8X7d+fvQ9+h59v4q+EI2lWczxD75sGQv6GwVGBGhZSFg3/JdR8sJ4SXcPN76ek8QD
ecZLzkGbWN1XipssyxiRjtdRkPjGHBrjrGFEgj7fclZmGWuMRAoDfSkau3yZIQpzWOyMv8yiMZSrIhgjPf4Cfbf8lByLAW/k0VhYkycdfygnsy1joE9zWBaNpe1jxn+ZSWOUxeioMD1OX/sb16Vex0qKYa22Siq/
JQAZzi0+7ApYxbQqRBvV8DDRdXWFfsl16WY4ZYGK7WS7QVbKvju9ntviZ6jvH32Pvkff19R3sZjyf9wcwR/kL89/WT6Ky2Kx391/mWcNY1kM9WXTWIDkHBZT/qMsGrOJiLWPYbxkNo2x9rGTxdCfl01jaRbD8mXT
WCKCcsF4RJvAojSWZrGof/CGZQz1ZdNYWpp4zlw/JWUxQmEXiwXys/qywDKmxv+dNNaqyEdtE+vmelIEti7C2LPqcdik0F5HOQ9rXY2DGgNGx/crXpPb2Dbd2EphjsKxZu2As4oPOI4fZxgHegNYS7FYTn0qRtFM
e578/Mg/9pLfrf349fTNUi06/0tVTYNavlL5Hn3fV1+JZYz1D94cJxbQRwms2DL2kv8ywFyoj6extQFoOmXaMraBvuC4fEv6/LUFxuPT+EZKRDnWMJbFAv5L/wy8NpQswzKG8ZKaw9pT3reMqXjTDTOUbaHsYsQC
VhMZYTETf0k4TOezoBxWYhlD/2WZnzJKWKw/9KZlzOR7pRwWobE0i3n+y1zLGLLYuDajHncvp3ZRXkdlv4JH3emRYFDkte6B0jbRq8yucunXMw/ZugxT0yxzq3KQwW9o7IDW1l3MNBIAyrer8/Aat2fppfWpJqbq
TS/dnh+vFI19zfbj19N30FiaxX6O+330/XH67vkpOSJ7Mb7RozCMb7zhp7zhvyy1jCGFYXxjNo0lKUzpY0btOzGSYV+hR2Hob8ymsSiLNQ32B0toLM1i6L/MpjHDYmHLGPIX6NO5wrJoLM1iSp+hsSrbMtafROSx
GPovb/gpM/2XOZaxKIuBvoPG6IzgVLo2sSUmgf/sbZgJVs9UudTj3NTK36jjHqHCwejIBn2M2ralZd9jvv2tr9R4uGHFHK8bygEzvW6Y28KT3a7yjI2Lor4wi5XVp2kWs/mq5BVmsa/ffvx6+vJp7Oe430ffH6Uv
zWKF/kHOtnVKk/80cVTSMpaXnzWet1XL0Vynq2L5VO24yO6UdPS9nwXs8F8ibwUyT9yQ6H/jsuhrFopnqqDU1GJ8o9q2nBKpKyIp+wXYjuR7tT2UuSP4dYZ+Ledmw/JpD6X2H2q5IYd5GVsNL1XIJkTC3kZL1Mdk
ejVaDz+luuampGExLRu8jpaHv1ETFuWf8ZRqy4DH9JWdDVbLNuBvpITl3YuRfvZ/WopTmvKpT5TGlnaqWiNDuS1YFjP+y0waC7IY0tQ89EszLZXKR7FuzaRQTPsYxdY39d7uUyVWoKquWTR5QQnUNX25UYnlW+AT
SH3ehNn871rGaH3q0xi1xMVp6zhG85p/3l3LmC7fJtTSbmrxr62ZYavUUk9q6aVaTBtA6GKG71d90nv0UdWqlmVQC9URuElyZKo90kfpM3S59T2kjgQeDx5L78K/d1/T8QR0+fRR/hn+E+Cuo189zud6PFm9+M+M
Pv2S3987lkff19X3BsuYwPys5YTFyoC+CI2lJcY38jQ24Z3mZKfg4yUzbGI8YaH/MpQfjDsjMaORiW/MpLE0i6H/MpvG0tGU6L9M0ZiJrSQZxhZCZCR7/lBjvKQdichwzMlkIQo7ac/ke90wHxrKGI2xLFYdLIb+
wWwaS7NYMN8rS2NBFpNUmnyveTS2GD9laDS/YS7jv2RpbOxwPqROeSuXTmW4oGyyoPOy3dt+FNrC9fmRoLGDyU4KM1sGvA6eS1nsbn1KWYxy1GEPo9t8PosTG2WxkvL5FKZpwexFDvj8ELNaOBozxOFxAsdinx9a
h89QVFPcakS5SPNVLo25R/qWquP5UcLSR4VozD3SZzH4fhkao6Xxr8aV4jvxwaPvj9PHsdjnRwmNpQnr9De+SQbjG0ulra+AxtIs5uRnzbGMcflZca8zv2SIw5TMyc/amnjJAhojksl54cRf9nhsKrfFlQHWnS1J
6Zu8fK+Exiw6olkhGI6B9txmMobDtA/U2MQuFrOvoPOz+jRGfYKUxrQcGEZqE/GStyxjZzwnlbocxxxIF43p2SnJHJU+i6G/MZvGEix2zFfZkTkq0XPZr+hjRKm3GApDqmLJazPloxzmyTLLWLg+5Wgs/rLz0ebQ
WEn58r1mPotdWxRftaNa9H69J24Z87noIkPFV1STX5oyy9jnB38sJUBKQT55XVsUX+XTGMdi15Hq++BIjytf+e/v/vLo+w767lvGiP/yLYRV6L9M0paVnzVJYwnC4v2X2ePEIv7GUhmiMJ3vFb5J1H5Jn8nilrFT
mnjJTBpLsxjGS2bTWJrF0P+WTWMBFnOIjOR7tf2UQRoz80tGWAzLl01jaRYz91vspwyy2IzzVeJ7VefQWJrFMN9risYEjuPXkptbXF9hMf7QhZEOjZ2SOX6u9PjYV2pQm8U0X7nUFbKM5XDbEX9ZWia+pffre5/G
KFmMm1o0S+jtNokoHkrRmF44GxFdDn3lfkqOxbR9MpfG0iymn18ujaVZzC/fa8v35I1HH7/YLKb6R3f8lAX+xvf5L0uyUKgx9lSG4iVzCCvOYke8JEdjVixkhjz8jTnzdevtCRYL5GeN0FhQWp7JU1+YxrTk5kMK
sBjGS9q+yXzL2JHP/iKUGvOf1qxtKUJmlR1NWVv+0AZjK23+ac9xYhPOzp1lGTP5WYv9lByLmXjOOI1peVCYy2IoDxb7/Ljnp+SkE3/J0ZjFZIxczfyXvrWMpbE0i6Xq09IxYyH/JU9jaRYLlc+nBe5sn8X0+KZe
6m3rqBZNO728lnzLWMg/yFnrKLv4T+MoX+BY704pHXGEdfgHOa6jxxqrIfX/Mixm+1cT1rUom76rPX/0fWd9pZaxZH7Wcn/jvbPL8rO6NGYxmYmODPJXaj7IQKSkv4VkBzviEVMcRqiJ0pZHYWe+1xx9GZYx9F/G
aCye+YJS2GDiJQtozMyHFJ4jfDXxjasV30g57KIxHVdYe9JjGvRfwnk+k7GeUE0+tk2sM/yl/JcFNEZYrDXrjsT5KsP3cssyBvpyaWxFynElZbHD3xgmszClJTJfnPNfUs+mIqybEv2XqOP13BaKlz4/3pfbQrfn
x9q9Efwucajx99yxlKQ6XPzxY1qfIbK2b1V9kE9j4TLREl3tEcdFvuWJ47bDv6rLVDqCvxFqsbQe/stBLVQHF+9gjiQ66J0cvOuXqWQEf1l7/uj7vvpU/aTs96+N4H9DvGS5//KeTUyivzHEZDnMFZRXvGQ8e1jC
MnbyEsmnmhMdSVksmMEC9cXyWVRlEvXRbT6HcWPzgyyG+nwa8yUZu896JluMH6wNjVG2qZFBtGRG9ht9hMKUZczkUz28ko1FY8PJOYdNLM5ig4lvHDwas/nMlnWALt18r8V+So7FNB/k0liaxRz/ZWY2MovFLGn0
5TNZgsXy69O8PGP38lvwLBYvH+cd85eDo/T4ez1CzOcVwxoer/As9vkRGjVm25Pi5aYEY/sv71PLne/399GXsoz96PI9+r6KvjzLWCKf6jviJV+yjLH5WTmbmC8twgJ9YXvXzRxien7JLLsVZ8Oy9gbiJbWmuN2K
ZTETL5lDYzRSkjvGjpdM0liaxUx8o09jvm+SsgvLYiYe0cl6YVvDLD9lgsVAXwGNpVns9F9m0ViaxYy+HBo7xoxtQF7LKY9RWobI0D+4Znoa3Zz9ASJD/2WYxkJbfJmh7xXL2FGfamJa1mVZ5lck8Ia37ZWsr4e/
0W/xNT350ZQGAT1esuMl/aPiljHf28e3RzmWMY7Fvlf7a+cOuTNm7Hvd76Pvrr4Aja31DgTRA/OoHBDp3BG8fzBn5Hye/7J8tiKHtnA+yBiNFeYCO+MbS2IkI57EoP8yxybG5JoIzi+ZIxnCAn0+jVEmGyyb2MVZ
NFMFkWp+HJLLdYGj2kO2V0ZXe0S965+8RtQr/xvNpEpp7Bh71SFzuWOv7Dm4T8sY+i9PMrNorDccdo0Tuyxjh/TIC/TRbb0p5SVzLGOxfK+5ljHGSwn6CmiMtY+l/Zf5lrG4/7LI++mz2J36VPPSVq1ibV35+eFv
s6WoRzFM3LrLYnfKR1mIvnS+hymQJYzzNFK2C7OYHl8cfuXkQnV9j649MT6mP799e9fy6Hv0/d76YpYx9L/l+CkzGYnEN75lhFg0XrLUJrbreMkcwoJjh5wjPX35Y/drE6dIR3fpfKrONkcWkZfnv4zSGMtiR9Tk
guXLprEQi7U0r36F+nJojJLIkYW+xzmJ+pPIahPfiEzGjoSnWrkIypPF0B+aTWOsZSyUn5WjMY/JYixG9Pn5NlKWsb3fXBYz8Y0rkfYcSelR+ZSRgF96od49SY+a8DwqhYnLVNLai/5Lez+R5ZYxvz4tnWuyfL7K
79Z+PPoefY++d+l7Leur8V++nvMr5W+0Z4JUcjExkDG5Yn7WJnC2P7PkrqIjU4Sl87Pm0liaxcz8kpk0lmYx4798m03M+C8d6sqQLouZjPqgLzzLkcNh1THLEckC5mVe1f48N6bRngnykhnWJmc+SGoNoxGUvmXs
8k9e8w0p4hHov6yOTycLhViNs2dZLGbiQ/2S0yfAzYcUYDEzX2Waxi4mi7LY50cWjfn8xRAZ6CugsZjU9dz3q58ffY++R9+voc+wmEAWqxWLqfijwhH8UcJ6S35WQliYnzXNYRaTxVjsiJdUppQSP+UN/2WpZcyO
lyz0U3IymJ813w7Gzy+ZQ2OavOy5Ji8WW4F41PgXPbMkpTEa38jFNDIshvlPXRrLm3c7yGKgj6MxOuMjtTz5LEakiW/kvYu+ZSzKYk6+1wSNpVnM5FN1vZUbk3MiyWLob4xz2MTYxIIS9dnb5pDMtYx9rfr50ffo
e/T9KvoMjS018Ejb1sKMGYuymDdf5Yu0lZGf1Scsif7LoDT5WdNMtjXKbXWMFrtYzMmziv6y+AxFRePHiL63SKKPy8NaNEIM/ZcRf2TSGkalxPklG4u9uDm/kca4zF+X39DES140xs1KlElh3nyQPo1xEZSUxc6s
9up+Hdq5pEdjRvYMkfnxoTaNHX5Z1zLmzVJ+sRjeb9kI/rA0UZbIz9LKQ8bHXBI/Jcdixt+YbfVKsZgan/jaCP6fp75/9D36Hn1fU5+uoVR7hBw21QtwTAVNToUj+G9bxlh/403LmNGX5DAsTZNmMeO/pDRWg2zY
TPcJIjrjJZ15jCKj+XP0lfIeZTGLyFj/Zf6osMHERmK+sMD8klyMpB4PFmexFfOpNgEas2cBvyIo7XFilMho/CDHYXTUfo5l7MqnGhq1f0RQcvwVYDETf+nTWO+RGWcZo9IuX5LG0iz2+ZHgMN+L6ee/WAL+y4vG
FktOZRL9l9x+bV075TB1e58YM/ZV6+dH36Pv0fer6DM0pq1hF4XpubStqEmMb4zEU5bKIv8l54EkFIbxkheTlVrGGqCflvIX+gfDc0AG5yNKERbGS77NGsbo82ksbiUjeS5AH28Nu+aXzM7hauaXrK1IST9vBbWJ
oQxkYd3NfJCUxqgtiI7oorGJNoXpcfxcPGJo7BXlL53X9czuauSMkQIoMR4xTGDUTymQnrSMshjxN17lYGmM8dT6/tBcPyXHX6e0/JeaxjbCZG62/iuycgmzGOqjVHWMCjs8lylKG5G8RA+/qW5S/CfgN9dMawM/
j32bXrWM/Rz1/aPv0ffo+6r6dB1lvJLaGqY5LCerhZZn7tQMf+Nd/yWNf8zxWYZYTOdnPThM5wGjNKao6hgPD4DKrh+jtAT6385P57qdyeKev/GedCgM/Y05NKaYq0mzGN5vaUZ9jsWOeEmGxnwmY1nstIyR+EE/
KrGxZDgzGc2o36N/sDFUM4FsLTvYYQ3rcZxY5zFXQGL5smnstI+xLEb8lxk0lmYxLN9FYxuODdPSZy5OEhYLzC85G8LKtGrZe9HfaJ0B7FUje21IXqsir6bfJpAtylpJjsW+Q/386Hv0Pfp+DX2GxbS/cTSeybZy
4yVtO9iAXDQCx2j5jnjJtGzg+p0zi5Grr0c/ZWSWSTM27CCYyzNpmMXy511+u4Z48o7MWllxipa+0hH85fGXlMzSo8VqEy955IC1M+f7drCwN3LAeZLMFoyXrNgcYr5NjGOxa35JmgcslEks6Kdsr3yqVjYv47+8
dITGzNtEBL8aK17S4pgzHjFmE5tQ60RiJ/2csOZqxn+ZExPKjfi3Sm/p869Ks3EQybMY5nvNpjHLWxlkMc/f6NMY8Tf2jSKvrlbk1TZIXhKZS6AcN1VfFdDY16+fH32Pvkffr6IvQGOhHPsuixEie0u8ZMp/KQiN
8R7SIIud80tu0Wys1ILkj6EK5T8tzR1Rku/1nrT9q7kj+BMsds4vGR+pT2WUxdT4bJbGmsrOq1+nWezM95pFY57FzKMZjJe8OOyisTqYvT7JYjhf5UVjPhFZNJZmMbzfbBpLs5iZT9OnMW7U/kVem0NhOJs4+ht5
Gov7Gyl5tUhenfY3tuhvbJGtmh3litKhsTSLfa/6+dH36Hv0/Rr6DIvx80FS2vEzpi7o53tHvGRcOr5R1BensfCcRSEWa5j5G/ls80kWY/KplsqQvzEuy/O9ZtBYmsVQH/VQcjnEUpYxw2LoH8ymsTSLmfkb0zTm
28SCLIb+wWwaS7MYli+bxtIshuXLprE0i2G8ZNpPuZ4UxrFYzN/YIXtNSF7ob2yRrVpkqxbZimMxZS/Op7HvVD8/+h59j75fRZ+hsYN52Hz3LouZeEQ61/ZLMuG/jMcOHCUbcMwYnV+ScJihsVC8ZDi60GIxEz/o
Rx/epK2s/Kw5/GWk8V+6M09meit9FkN/Y4jGcmaZ9HOIKXtJmsZ2b8ZJlsWs/KevW8ZC/kFKYzp7WNwyZo0Qs/K9vsEyZspX7KfkWMyUL0Zj7hxIIXmyGPovLw5zZ6Q85EFePZLXosirQ39ji2zVIlu1Qvsb82ks
zWKfH7qme9fy6Hv0Pfoefe/XlxnfyM0o9I54yQzL2BnPaZeJEJgza3fYGsblU83J78BlRw3lU31Z3tAXZbGgviEws2TMMmbPL2lnd1Vjx7iMrr5lbMMtWu4m32sBjaVZDP15aRrj2GUA/jokshjo8zO68lGTLosJ
l7/O+MYhWo5sy9gZf1nop+RYDPOppmiMShpB6VLYrPOzAnuNir06ZKUOWalFtnJpLM1inx8lNAZSXaGuxSob2VRLO3TdKlqxj2Ksl02oeINazOPQjYNUcQHt2myDrEeoOEQt4eudmqqeZwk8KWYBQDnMvcLKuYcv
eBbVWLf7KFHOSgKfCvw0xcfCMXELXvZbky/3mn+AzM8J91HDjxNjVuGxqplUqGxrqAHbgci+Rvu4en+LHGqcr029v0tm6JtAVrkS71fgp7dIRt9cQz1ZIHl9an9ILp5c69WXqC+455RbDfV4QK4q77uWUMEaif6y
6trW7qgDZddiJoYc2TW1lqjv/JQhK2CNQwaOieobsuVoMqw2Zj7IBkdr6QwTrkzN2n2N6JoxfvDwJWqZQ1KRuRxRXzaNvdF/GbeGLQd/oT6fxhyv5MlfdC6hIIthvF8+k/1R/kten09jcfuYw2JkfskMGrOsZIE5
jhpoj5w5J6M0drJYOCNYbeIlXxrBb/YavmH8eQOO1/dozEjJ59g38ZKxqEpKPkkWw/K9NILfZjEsXx6NZfEXxkvaBBbksEMCfyEpcSymeCOfxpIsBr+XettqxVBrPwx9NddzM67juq7AVBvIuV9Ain5edrH17Qyo
2Ck+m7taTGMLbV1drcMOD2QZBM6PXQ8rPM9VABD1I9LYwNFYmsXM/JyZNBZhMQlf2zJKnS83wGGtIbCB0lhawv0W0FiasEDf21hNsRjqy6YxRwYIy+h7hdIs2gJ9eUzGk5clUV82jaVZTP0/CIftyGe7zVxG1rC9
NvLYvp/S0Nbnh81br0rQ9x5NhraMPo7DJkNel4zPkG37B6ldiJOaVLQMHGP8eTmaOEnHas1YPmfbK5LV59/jZmaOnDwWI2PcjX+QozEuvxbLYmb+xjd4Lgv8l+X6bNYMSy47hcVcgfklfQ7z/ZDGG0nm/TYsZvyX
NIdFhMbSLGbiJTNpjKEwwmKgr4DG0ixm4i8zaSzNYtb9xmmM+l1ZFtPly6SxcLykJT8/zCfMr5+isTSLYbxkmMbgBeS1N83aAAUNcy27bhnbdeqnrl73eR/6dZvXAS41L0MNUvbQX0AmW4HGdmXlGrcOmr5Rdo2Q
49BuHdQUUzWozw2Ql0D+mlDaLFZrFoP7LaCxNIs583NyNAaV22kZo/zlsZjyTyOTldq+OswL7m1Hfdk0lpbq95dPY2nmAn0FNJaWoK+AxtJS9T+QjHx5yzIG+gpojGExQl6fH+ZTgzYpLc1+JK+6jL9AHzS+cPab
iA30FdBYmsVAXxaHBcbPX5xFJM7fGNxzj7Ywn2ohk8Uk+i9fpTRCYef9ag6jNLa7vskAhbVnri0jz/ynWTSWto99Ef8ly2J4v2kao+PBoiwWjJdkaexiMSurBWExzPfqZsv3acyfJ5thsXO+yiwaS7MY+i+zaSzN
YiSe8+XcFo6+DBozLObPO3lK9JctMQuYI885kMIspv2NhX7KphmQvHokrwmUd301TvuoxsN1K7wP3QKy7+YVOLBr1l3C/SKTDcBh29BRJlurGX758zDuwGIt2se2ceoqoC24X6QuiXJG6TAZ0Jg0NLYE7GMOZ1n5
bZmcasxsT0EWU/oO21iaxtIs9lb/ZYm+e/7LKiB/f//lhCX2Jedv5JksyV+ojx7l01iJfWwz/svNlpYdjJJXg6TiS81UPfrz6uvTi/KO/zIhib/Rl7bXMYe8BjPfYpiwbkh8fu8ithn9l+UkFZGoj7PvUUn5i0h3
Fm3053Ej9fvsEVOjITJp4gfNpyo06oru7aN0dMwHme/35GInbX28P/KiLW4MvsNZ6L/Un+IZ9X3p8lelyAv1cfMepWbwphTWIae0xp/XEoKJkQrHYrZ/8PXcFqck8ZfUSziQ3GMcTwVZzMtvm0Nmmispi51EhuWb
jJVvVFNxxGgszWJmfslMGkuymLJnS2SvcW2BcICLZN+347JPw9K3IGXfAHnNfQVy6nbFZAeRrXBw122VhG/gIDLgK8Vku2GydWiQxqZ5RBrr0D5WobcSaCzNYqq/mk9jaRbLmp+zwDL2+REaNXZfFvgvf099LIsV
+y8T/PWS/zJAYZb/Mm4Ho5JlMeO/zKSxNIuhvzFFYx1hss7bYknQV8xkMcIq9l8mWEzZ2/NpLM1ioK+MyRJEVOC/LPc3lvIef78+h1UkRtKXLItZ8y0maYzx8xEWM/o4GuPKwUrjD82xfaVIczPxkheN+RYwzvZl
zzV5MdeM+tTYsS2HxtIshvMtZtNYmsWMPy+TxtIslsj3GpudMshilr/xFctY6H45yxgzfizEYp8fGWPDLnvNbFOYz2Kq/mNoTA22Vxn1ZySvdYaL9eNU7dNY9wIk/J6Bv/Z+ALn2vSayzw+HyQQy2dRtQGMLXLeC
qmRFJpMgLyuZJrJqhl84slijfZXAa824dMo3uSJ1RZiMsYwdRIa0hf7GbBpLsxj6f88ny1rG6PixEWRtJO9vfJP8MvpGIvP8l3FK4/2NpWP3uTFj0vgbOUort4ltxn/pjLs3o+/9EWKaturYGPxM/2CC0i55+i8L
mCzDH1oZydvErnyqXJ4s3j9ocwn8x7oV6KM2Um+h8hrPru5Xf6L5txaSJbVQon/wvo+xxB/q35e+X5vCFJVUF3mReEmJ9qQlm1eCLIbxgzEa85mMspgnT/9gvqaodOIbOU8jJ2dCUyhVPiiGsAyBuWcYuRBJWAz0
FdBYmsVM/tNMGkuzmOMffNkyFpyv8gXL2JnvNYvGPE0efznzVeb5KSMshv63bBrjWKyb227egbkGFV8L70BDILt+AQn9AMJk08lkGzLZ2ndIZprIak1kyGLDVkvg02GH99ZiMoFMNq41VE0L0NjW1Za3MsJixn9p
09gasI9lWsYs/yXHYdfIfhyFp2XYMob+KM1hfS1ODmNo7I3+xq+lj6Gx2/7LsKexMTLCXOhfjdNYzvixk8Ki8ZLMeLAYi5F4SToeLBkXycmov/GGFzPTH1oFZNAzifqyaSzBYivmA60tGvOZjNCYxWI+YUmMbywn
swh5Mf7LcsuYuR9TPofGjDWM0pg9KmzhWIz4B4v8lA5bnURE/Jc+Q/lMlmQxEt+Yx4EuhQmgoOaSZn5JbjxY2uvosBjebzaNpVkM/WU3/JQci3n+vBctY9n5XjMtY1i+G35Kjr+Y+z38lBf7UelR2sViZn5JyUjO
MsawhKr/0jTWj+08K+aahloxmSGyzSGypp93qA9OJhs5JgOYWpHG+rFWTHYQ2brM2wC75r4fl0Us3bbA70+03SS7SXTDPE3QcgBtbchcEfsYz2LAVwU0lmYxzJcborG4ZYxlsS/ib/yj9N2Jv5xjRJYdL5lnGYP2
I4PGCkbl63jJgO2Lk/7YfIvCTLxkJo2lWazYf5ngL9TH05hvDbNZjPPn5diIfAoLsJjx52XSWJq/TPns816IyMzyh7p0WQWsYYa8zHyLPIEtQcmymMl/mkNj/tmB4018Y85YsywKM/5L/SnCYRaFHdwW4CzQ527j
slNw/GWxmNHn0ZiZ+duXCRZz8r2+bBkL5nt9wTKW8F8WW8ZM+Yr9lByLGf9llMwcy1iUxc54ySwaS7OYsu8aGhNDczLZGGOyCJHB72WV/daN6w4EtqzTDMSy1nPb7csqtm5eJHDYvAgxgxzF1M1ymeCYWYzDuPos
BrwWorHFojGbyaIsxvgvc8aMXV5KYhlT/v07fsov7298h77y+MuXoyaz/JehsWGMlzISL8nkDYvzF/SP/OwVGX7KG/GNt2gr6L/MsYZRScbpY7zkRWB21qzSMe6j8Q+maUye+R1CLEaI7PQ33pPl8ZeFMQfn/WrJ
+SbzrGGL8Q/qWa4vWWoZC8cjxs6O8xeRpz+00E8Z4C+UKp+Rw2SVkVzcIyft+SWzaCzNYhgvmU1jaRY785/eHsFvs5gzf+PLljEn3+vLlrHk/R6yxS2u9IhM2deyaWwJSIccMP4ym8aAxeSsaGseuiCRKf+lZrLV
YbJzTNkmBwF/ddFPXSfUbdZiA2SqZT1O7QIUJjthWKwWGP8LICaBveA8MYt+qBVnDRXS1o6Ss48FWEzNR5BPY2kWu54fO4I/J5ryHL//Tf2NvuRG8DsS9Q2GpBT/5MtSf6Pts0x6LvXxWL742P342DCHv7B82TSW
zlSR4W8sYq7s+Euo8quGkfUlUZ+zzZHxGbcdFvP8eR6BWZKy2AYk0hh5spiJRwzTmM9kSYn6uP03xuNH4zl9SfKGBVisRv/gwWEdsEsToLEjO4VLYUEWM/68shH8+kgBDNJa8tCXk+mekw6def5LLSXQTAf1uaqu
qHT5rDLy5CzUx3NYrXhKzR1p2ccoZzn8hf7L1TvqtmXMy/dKCeyGZYzkU83JWJ9ksWz/ZaZljOSjvTmC32Yxoy9MYx6TpVnM+C8zaSzNYqq/b9GY4qxl6EFKZLJ5aE8yG4eK+C/XHTion1c4rlPZKvquGuF+Qdnc
dzO0v10zLQ20S0NXiW7ptmpvAdD6Zhinbq6BuXokrw5li9JjMcV/Do3BP3OuJ9FXAkraDZMYoeqZmhGq+nFLsdg5P2eaxmbjkww/aRNN+fmRm2mszcoz9kP8jQU5yYy/MZPG0ixm/I0+gV1UVSXWL6tWY/kbG0JV
dWDdz1rhj9Nfjb7SXPo7cFbj5GpFif7LbBpL27mIv7HyLFbl64OJb8yksTSL4XyLaRpzR4uxljH0N9p+uxVkc9KYqNqTxq54SZdpznUr/vI2pVnleyE6MhEfmqSxCIvZ80uGaMxlmizLmOUfpOdpApuBPjqLyRIU
FpgP8mQ5Jhu+u30BXuqNVP3pMJnNyFNzhh2MzOCt/I2Exvy8YTnSYjEs3w0/JcdiGH+ZorHO4xvWSob+xpCfMi5T/su35Laowvle45YxmnGtP5/luU79l/dG8Nvy9F+SsefZljHFYtswIpENmshUvCQyWQc0Vm/z
sPXj0o5Qz03jNHfwO527DuokCW1Mt0hoobp53tu166ZVaR5ENbXT0MMPSYyVGp8IkNfLKkhjjcNkanR/M8m+FfME9fUEpNX1wF8SJJQKrjGq+Y/gXSFeCzcxAJm1IzzMcR/xnkBOJraBykCcg5ZnvKQk7CUdqfdK
sUzdaRmzM+2f/KW+X6gwFZl17yCspH+QekU1Q0Up7Mz3mm8HG5FpRuQRQeRs4gfx3ZExn6AkfGNv30h8I34KrM/uGfH1Ux+lro1YwLyx9mTEfe1L42+099RIY37OfCophWnZNDr/Kb4T9krLll8n8Y2Ro8z6gLxk
27Ycif7G8DxF5bIz+U/z5w/SlEZz7zvrp3/QnwNJz5Hkr/vzPYbiOf2cGHTc2ZHhwpUefyXz0brzSxrJzWgE/UtKYB1mX+gx74Kft5XL4UqONPGI9rE5divKXAtSGEplP7g+BWxmvtQMp6V3HdDHXfWQQT8lNwYf
9B285UpulH2UtpS+IIH58x41mOO11ZKbD+nM9+rn4G8ITcSlra8x2V81naj8rVT2mO+Vyqj17Iy/pNliJ5QqX1dr5ES2j6fVzdXX4fyX+G7JAfa3Zl1zZ+s9B8aDe8abamkfe+k4tHbHOsdi6C/LprE0i5l8ry6N
AbPM2y7GfRBAXkBj2zwCDS3T2He7qKcNkGeYp27s1eQ/Q9/Ipuv7Sqr6r+12WXfQNwWJZAbw1k9b07XLMAONiWGsxgb0tc3JYjjLpCEyxWLwewTyWlR/S8ipQx8kFGRaxq0bJjmuIGefxk4WA06E+616lXt/BBrT
FCZU/GUmjUlLhigMpfk+FI3p2Snxm7LyiVEm0yx2SOFLE38Z2OPIHGIb1fxRJTTmyZi/8aAxl8MIjbEsdnIWyafK2ZkOesqSRp+7Z8E4Ri3p9tXsvSjMIS/Ul01jUYnkZeIlM2nMYjHXJlYZf6NLUi9Jo68lNHbJ
G5xl4iVzz4jMBBmdDzJ/1m7HGoflS81w6drmIixG8tFKlD6N5Wc6C/lD6Wzfx5zffkZ9ZQELstgZP9ga6dJYiMxsSuP8gxk0lmYxnL+RI7N8L6bJToH+RtsOlmf7orJx4xstGqNsFZdBFsPvI05jPjlEKAz9lzlM
ZvPZgFcISBPPOUTsZwefudw2GNq6KAyk+j7yaSzNYlg+jsa4UXX+E+X9vyhLRvAH870yWRmycluMqoMltxH6JAK+X1F36yDnuVt6IYdu7SfZd7IfZKcCIUFO8LEFMtNMVoPsCJFBz3ramx5ZbFTxb8NUTc0ywrPs
tmkAGmuBwNpp7YVYpqHbRDdBTTjtIKdpmyqgsJVlsVn1VwHvRA//QZCTyvJ6RjkuRp40FmCxxRxvWMzES9p8xlvGjDSWMc1iNIJysPK92kyWZq6ABH1lTHaMnJ+r2sgRzzXS6KP7DxkeZW/7GL0x7ib/KZcjwpcL
4+G74hGvvBC+ZHKossfb+iiN3ZzFyJlfsnQEv8diJl7Sz+6a9lkGJRvfGJehUV80P2sOWwngnyYl0X95fMrnLFaa+SptAlN0qSU386UwnlM3qnM1/kaXiA5foe+n9LOAWRL0OePuiz2hu5LwNU2Vnl9yquw89HRU
2GiymV7SHr3O+QfH00JWZcng3NiKfjB+sLVy1du5Ul3JZVg1MjEfpJ+TldKWy0iVmQ8ykWfi9Bs6dqnQ8drfSFitYiW9gp79CKW1/YiXjLHGNW4qxkvmSON/s5msx7OHiOzNuvYnXnMjHfNV0m1jO53zJfnSnwPp
krWav4fwWYjSqM+yOz2NdE5Od37O8Hg67gx7PqmWzE155HstoLE0i2G+1wiNtVCLzaLf5QQ3vYGEf5Yc+6qXavhYP59EtvSjIjLglziTjUBjA9CYBBpDb2WzjkPbNZOoVI6LXop5Aj2imdpOiFqNN4P3CmlsBxoD
JkMaW4HAVoDtGUokVOr9rrJ4CuWwwj+lG6F+gI4f8hfGS4ZpjJwX8Vk6LIbfh0tj2jK2qpnbDYfRfBa+leyPi2885pFkaIxhMcJcOB8kP7I+5XX0yEvZJ5FUqCRjrGwJf43akh5hgT6WvTKkR1tF80vGx4xtnv8y
RGOcfYxGU5bPB5lNb05+1gSNpeXpv8yisTSLoX+wjMk476Yw/lqbw1waozJMYda4LTX/m2u9SjAZM4+31uDo821ihsMYCjtY7BwHhv7GXBoTp92MzYiK/sFwlnpKVT5/MSyG8YjZNOZRnyfP+MbLx+hLNs+qT2FB
/+AhMzVROlP5O5nrESYD6dIWw2LO/JLl0iEv1BemMS0Hj7+iLIbzVbocxtIYkXT8WMgf2ponoS1jdR5b+SyG/ss4jeWS1zk/ohljHs1XmmMZUyz2+TELaMRF3+czGdrKhCEy7b/URDaKSo0/BU6S1aC9lUBj6nlP
UPSlUjNbynoXcDTQTD1IYLFl6oG/1hFUw9VnZfPq6muMvZWf9RyJD7cm2rUb5h6+pnFQtV47dJUcpn6FK07GSgbHkHUcv2/iJS99tv0sPHafstg6dcOKLLYqCkP/IGUymuHiGM0vnGMi0tNH5QD01AQk54EcjT/U
pzE/awQXm7igJjv/aY6FKTrS/ZLKfh8iMyKj/JOKb3Q8oe49JiWWj9uv6LIlMsNKhv4omtuCyhZl+XyQL+Tjd0fro3/wfSPEOP/lbZtYtv+Sz0jRUWniLx0a61UTWZ/ypCNtqyqKvyQEZo0Bqzw/ZOUd05n5JUME
ZvsVKyNp/gY3yxbKc75FzTOx8VZhe5Yj0f+mqWsjcsX9q2GucMb64IguvF9/T9zTqP1/wThF9G8x9i5nTFbtycCR6N+Ka6rw7NTVfH8ZN883me07kpHCjh9M5xDjCcuiJiwfF2HpSzqfeJDFPH3x0fz0mTSh78n4
a2NkVmIZk1a+19iosIMNEiym/W9ZNAY9y3keGgl8pYlsqIDFOkNkKxBZrfhPjobJtl4YJjv8lyrxRNtNmsm6SUCN0s5AYZ22jzXbOMFTVQVfgcU6KatJzX8kZ4ew0hJoq137flZj00jUgPIfTQ08cs1k8L1WI+Ew
j8bSLIb+X57GOlGL7qKxNIuhfzCbxtLS6MuksaBNzKIwjB+0+UKvr7C/cWkszV8Jf16cvAIsxurLsFURCrPjL1McxhFqQFr6NpAtoTHKZCH+UsapY27KTkszX6X55LEVl6efk6l8r34EZYKwCvyXnLQsWei/TI3j
T5HXNXJ/QX+jirDsMevFEGQyn8yITcxQWA3rTV+jf7CQyWIsZvTVGbLHcfpasiO9MF4yRGOUw9z5sCMshv7GPBqjFjCfwgyLsfM3xmmLHeOF/sHj03aOwGqwtY5Jxv+H8ZLh1vpioThbWdLoy6Sx6hq1FKaw1sxX
mUljSRnyN1IZtmRFWMzES5IZtzP8lDaLdcZ/SuMlM2ksaSuLfb8Ok52WMZu5Lt+ZMPlKBeEwm8Z8dhEpFlP1KaExYKReDGpa8BHITA20r0B2xlammWwJEJmisH6eFR90u9jrVSXUh45cO0nVCo1L1TX7uLUdoTFt
H0uwGPobz0/DMg7tBldau05FD8AXpMeo6aiBaR5aw2JaDlW/N5TIlL4R/Zc2mbnX5ixjdp6xbliNP1nR2ARtL5UdEFhjZFvD77BtkMyiUv1e0kcZ2SKLUWnbzWi8JPVW2jQmkR8WUKeZ66CIS+rtKNE/yI5+P2UO
Fx3+yxVJy5WdJV3LU8sRkYmXbJLHqvudo1LZDBv010rDZKkztLRZjEp9v/qTx5rIYS0r4St3JDIa+i8pscVkj+dxcoALQf2n3/NorMB/GRvB3+ZL47/MP0PxWYdj5oMS4xv1p4vM/JxkO+bQ2E0mjUguDN7fyFrG
fPsY2Q79wcM2JjBe8rCMhZjMzqi/hijMyadqj74PW8Y4ieRl4iVzR4gl+QvtEfk5J04Ks1iMEBnGD+aSWbyVPvxb+tgqV/a7GWsWlKCPnlEzY/cpt9n5XnsT8Wik8V9a27yx7CGSo/GQIf+g9iLSkfhUCnvUvpGN
8V8SwvPmv3THg1F5+WvtMfjEX+zkyz1yg+QQeVCi/7Kt4CqOBczhsFMmWMzy5yVpjLCYHAZgMY/IVH5lh8kUh83z2sq+mesGalQxVJMKl6kqKttdSPiLVDOcXzdzKyTcIvC43Ki3MscaNvTTBvzlj1M74jkJk7Xb
uNWHz3IcurqyLGNJFrPm+4xmGkPLWJzFgMLQX6ZprEYL2YsS/YMcn3k0lmYx439bkBeAmuM0BlskWrXYHBCef9C3W/njxyIsBvq6HA4r8jfmUJWmMCqDR6p4ocCeBa4XepYHi22w95AWiyl9hMA6RvJU5UjUl3Ps
QWFUXhnGpmMsGfE3OnvOMWMjGRXGrWup870W0BgrZ6OvQ//l+QltZg1SX4u2rxaZi+MzzWLauqYpTP3fOpPRDD6d6/SoI3/ZNRemOy9mdfEcPr+L64wnlK6fZDYQYkPbHOGy9iAy9A8ekZRh/+XIrE8gjyjLc+QY
iW909kSyUFBJYyel0ad5UFOayfDFrGtuE4bVrvXzGPSvrhgMLA2TqXWXyTjZWOsN+hvTrHZtqVVbDSTVKQdEaB3jB/W4/A22HWP0aZQmXSfHnDq8+SoDo8zwWChTh4M9Xan3hmR35nttsiSNaaRyhJvslFT/j+sT
yAkIrDNRlYORdq6MkDyZy8RLdshWWl7ld+MduPGB5Fs+v488qa7TVVVgJLnmL3t+RNvP5srRlSEWU/M3BmhsGUa59IvDZEBhwGJVB72wuYVHt4qxkjZ5fX7geyWWRjWW7bA1UDksay3WbV/gz9atezXMo9wVjQGL
EfvYCKAFZbWkGi8K78ofuQ3VrEan+V5Rh8lMhg1oG8QGX5sY1tM+NmD/TV1pbN3rCdyi5YjPbEJic5+l9aTV/BpmdspVkxlQkqatmKwwpjIgPz+4PYXSEJuJ5/QpzR93NsF6c44fu+RkuE1JFS854cgygT6+uUj6
Vq0F/Y0XW/lyKZIC89seJZ8NN7lSOPcIvA7bbWkoFvWFxuTlyMkvC+bLtUsjCbHp52DzWVDiuP9e5Y9FVqvP/LIhyWVAC9jejD53TxOIKqDrNPKzIaPSWssf2jLrWqqx9G1Cav9lh2xly9TZmvoOf+jJaCae82A1
15Z20N2QuX74V4WJyXTX5+j6QtaNR/WM57z8q5r9kOFwHH9rZgdvmxnXrzwXWh6Zx5QcMR6xBUpTcqB7QPZm+0iOia8f+i7bnC1HoMHQ+pGxdTttcib7v5WP9rDc6cgDzYE7iTMIr2trnclmwcZzroTeYmP9nXH/
xh+qt2nbHM0Zm7+uLYHCmv9SuNbBYmn7azOkx6aORH+eZWFE61VfLFt1EeNv7BieCkWg7kzpzV1jPCwf32F/4/q7jkrUZ21zaIxaw6Y0i6H/LZvGPBZrkcUE8JcccOyX4r+5b+ZuF1O1+lYvIC9RL207A681A5LX
iuS1oJQoZ5TD0q/KvpFNY8M+jh38FqDCq9E3ekQQkDwbyl4XYDLlrRzFXB+lbCZVM1VjU7dBFjslPD9NYweTBZ8lfeKixgz8OMrM5yL1/brbml3lfr0n1f83fdR5tcHlM3fWTMxHe41qs/OkHbNqhuR0WtcOOptM
POcc3hOYjyg+HxLSDM5XSdkwtj6REXHMMajvOipnTB59Pp50np8vdUytT7nCYzXkMvSvXl5OaotMSW2XdNbP+FCyBxp9Oo7tWq+JhQ7X/cy153yaRzSou35kS9Mj3+rUOua3daMK4G8aXFd5Ka5xbNc6OQb0+Wfb
UtUHqfX6uBr6a/m5CErmJQj5a4+rKhnKEOLxo8ONDfpXL9ucL48M/YrYlGypNFRHtkB96h0Vl9R3e1ruTon+VbpNlYbOntl4/OhLcvyZ3zYuQ2R4UKSVxdbJH8tlLqNxo1pORBORwXy5XIbdVGa3uL5QXt7LdslI
Ew97bNPzRsVllGAwX667ZyfSJqnKWExtb3gsXteO820Dd03HUbqe++P5Hf0HpaOztkRlVTneSB3vJxgqCMnp9MIRi8/FYjrfa5jGGgF/cujkDrJvcaSXbfuqp7YeoHu0qRpAbnKq9wV4bWvqbZk2qFLWHahrR/ba
UFIyQxqremSxAVjsIDLlq1wvIlL3O8hp7xYaSWCNV5PneLUjqlMTWT1LAPBBqN7yWW4dHwX3Mg6LqhbHHjmLkzafjc4THbF8lpdTTFMzGCtas9TwDRq5MXKxpSqfu+0VaelTfLYa2R+Stag1ljQzCJj5Kul8Ther
UWKLr5/S5I/VvBLPr+ZSYnDd5MudzvLR+UD9M+gxbch2if7V162TjZlzQesLse4lD2ITOTZKvF9qsbS5eDrXJbKkjpOl6wta7o7Y2Pn019Zmz8GB8vRMH9EadNaC8Ppq8u8ecRxbcv3KpnvIhqy36J+2o0vj642n
qTk0oU0O5/+9PpGjdufaXIyrI0n5/NmtfJtiUury4achKm1ypCTX4V7V9AmTzzec68OWmvT8uUQdifpobpCS2RN07MWV3zY0H2nJfPEBifqYmUgDZBiXrfYnq3eU4swp0iDf5stzNCDGh3Kxs1wcbURi+Y5ZGcrK
FKRfLJ9tXb0vezNfam9miLj2NGYGL5F3p1d+PuLf50Zvxkd7OhLHMzD7HRqL+h4Pqf1luTTGs1i9N9XSqPqlFrKHruUsu2ZRI++bCX6CdVPXUqKc1ZHAX4rGDtnUisVCRPb5ge+jRWOOfcyyia1i6DZr1JpFZCqe
044h6Db0nXqWu74b97pVs5m3E09hip8jNBZkskNO+7SL1mYxeH4xGpOqcjaSoyp6jIrPa9xt2dLXvWp/KOWzpL2NsgalGYwgMP7QlsSM+usHBcWOMeunf3V4UfL68C7u2ihBX+axQHddkHKpVPGwQ4TVKM32QZJz
pPEnp6yaYRmw35n5SI/8J0cuYcV413Z5ZkcJzfRprZv8wIsnN09ysSGWNPOHHlEjYU0+B/rXN9IqX3y2edvSez0NKqV5fjIq48/Behr0fhM57Djqo5zamPlSG+9sTjZEBq5g8hdz1y6NAlbxxGW59AYibesjSpMP
OZRzzpXSklesrXUkxhOnNNGswwlZUL4sKmbjk7kce1RKX5r5ZgN7sqV1Hev5cdmZaZ/AtyjTLaN5fuOr8mAxjJfMtYAx/EUl5nvNpjHCYoq/tGxRNiiVv6zW1jBCYw3SGMdkmsW6AIsNckX/4EVBnZp1HEetSZbJ
Ftl3ayeFrDufwlR+vRG4cWz7QY07S8jxlDH/5TW+jDxxMU31YNYzrVfoT9HvWVLWNbJVRKr5esm2GTlsNkzWog5bVpZcLRua9oeuAbvauR7whEbXMT40/4ykDPl/S6WhpvD9vihPfZq/48R2WtEw1ra/KPKSKp6d
mXmem4OLk4PRx7Of76ueTzl56zg/g4k3vWZryF0/SO5iO2n83Qej0Ewq6XVPk14/y5cjJzPvl6g8u+4h8fkF9yQkQ8gqv0CUoH2O5p4fPgfMr0ztli59rqeV9FinND27hEr0xSRHkZ504rF1CajM1hTUF5tdNmQ3
bVzGVP5zjztt6euISNR3bauxNL6MlqmwfGlJiFfFv2VwMT27w1IyUsV3x/aXPksyPsKV2h5NtuT04NR4+fRRjmUswmLEX5ZBY2kWU/7LegOuqkFOsj+ZLERjddMsQlnDLiJrWqSwk8g+Pxwmm5ZePTDkMM8+5lus
hkUsfTuMZgSbGh9mmKyf570DesW8GZTDtDdSojeyw7FhvjwpDP2/Po2F7GPuWH/bMrahZQy/j3was+QK2xsjz+3KHptPY44M8Bfq45hMEVZtpPZu+tI+Hv0B6h2JIyJz6Qj9W68QlhMfEdWHx0L5+lMmCcvcbxmZ
RSgM9fkj/XwrmkdmljzZyfh/00yWR2FU35Gfbo5IbhatUxr/KjfXFmUKLgZEM5eR6P/Vn+Ln2YSl12cnwngw+mjscUvGWdJ1W9L46Gv98E+fn059dL0vWT+/j8bxelPSo3kEY/Q7nfmffd6jc6KF14W3Lsz3e36K
rh/6bDkSf/uE/vPQUTkySNmmfJTw3YyJOaR5rNPf30b05a9LQ8Lmt23iz/0ypUcHBNdNPm7uqGJJxh9k2aujdurNyhe+Wd+HK+l/mWYed3I/oj46P0x+74v9vVRVJEYybQ0bqUT/pfmUZRnTLLbWI2ExYh9T9nak
sQVorEUao0zWIYc5THYSmVgGnDKasNjnR4zGRvh7dt0g5NKvmsn6fh6aQBxB36I3ssJ404nlMFeGrGTW+DH0XybiL41lDH2ZDhF5fkPjb8y3iSVYDPSF98wg62ZCKUBHc8oWt7hyBhrA8QL63ZI96nOlRJrRkpKc
JdEfajNPVCKPGBliO+3PY9lvh9bJPo96YgNHsuW7aRMz/ktuP6Pb3LVqyxubG634Wi46l4sdCNCb8dfGYw7oDKvHzF7uLFr2/KZ+rhT2DEaaGtDyh75BWvo0YXWGtmbMOHPdo5+tT/M6/lKOdXx+Ztsp4Vvz1/W3
SdfJd3ast/j9np8y1juV0gAY/cpdSKWdT9phzcqe9Yyj8ON7x1nVTn2zs0ePcjxmv71GOSbWTbwz/ebzrIk5v78cGY+kSf3+KNsfozBn5AFm3Ty/xFHMujvvXH369wN77tFH8f/NnoXFk6iPJymun0Tv2v0+3Jj+
UAyXjpI/o774noS535z+Bq4ji53ZwTx55Sv1aWyMSY7FMN+rTWMtT2PEPtYv89ZhWuUFpNi7BlhrV/7QHgnMIzOLxqh9TLHYzo3o+vwYZtX8d5uAUgU4THsjc/lLPT9KYz6Thcb0c/GX+H0Y21iIxiiTha1XHnk5
/stym5jDYqCPkpkkBJazrm1imr8W43874gIYAiMyg79UPu58GktL1OdyGMdkXMli/toyyd8vR2MFuVCMv5azmfmE1aTJC+c3dSNKudaTa/PK/XnUxhZtDwr9jTMpk2axK/tIa93vkQFGUU1cVnDkJUeVqPOS6D93
tlmyKZPo37+2qbGVNo3RdW6WNJK3Bb+P+TzWjyyhbJoRbXzqS2V6uaJTNMkxkTlnfHIkZie5frCiLp/+RKUuh/BiZXhWO5kBf380d86MOQXjUp5XO/Sd66iP7rGvelBG9vqZn/pN0tMXpVlPevmEzudnS/p9uL8U
7vtDid/vUtn5NONSH8/IUx/KiGUsMY7/OMbMt+icF6AxuB/gKWh31wUa/nVV5CVWHDO2LChVgDjok1PAWzkr9moEygnliBKZzCeyekYWa2bozzg0ht5Kwzw9YSSUw9ZvUHRkrm6bVHYzxxuJ99u5592XjD6bzE4p
xqkaTLmBYCq4RS2loR+cL+v6dHKYCPkST0lHfQk865SoT0Rp7CC5i/ci6+i/PHykHfpLL9+kv+5FZ7qUg+WjHsoMpgiM6AroY32g2exi+y/zbXa3/ZecnS5is8Pvg1pf4vdOIyBqTzbGH9UgkVQoW2SUuIzMSG/i
a8P7dX1XNMO98b+5uYnzpVO7o7/Hr/GPbCYXn3WEHP0I3lNi+TjKPbyOerxfFmFhfmD96eLvxljAqNR2sENe/kmHPog/ufdkyZg2Ew9C5sPlWkMq4zHChz7ujNFbP468tk9WO0z1OXus1vqyhoWjU84IY3x+tqXG
t+Po0WzUX8bmLgz8/uJeW9eDe8nGlE9f48pAPZPc0rLqzlk/lqpPS9B3fCrls+A/EO+39D/L/5eP+2WvRxhUVnqWlR69lZ2RNFv3Ub58OyyRYRYz8ZKZNBZkMSg1kpdU5KXiZw72ypWLIrZ50TGVQyOBudaDyD4/
WCaT+wSc12xbtS4d0FgtxxXa/XlfBM9iJr7xbYT1Bn0Wi1H/5bSdlrHFWKHmk7w08zRGSiM9XyHGX2bTWJrF0B9a4gmlo9by/G98drMMmZPfNscOdrAY+i/zaKxxtgT5y/JfvmYZo/7VTBpLUZjtr2VpTPMXpTAt
a2xNaspf6A/IprEkiw3GX1FwBiMv/0IBjUVYLOTf8okkPxpCy8bEw165UppiabGY8V/6NOaPE8uSJr42n8kS0vi740fxdo2Ltow0+kaLvdwtBdJ8vz6HaQI7ZMyDdozoQgoz/q0j0sGlMT7DdI5/0I3LpVuueUBc
FrPW8f9xkVlIDoF1lrkS/7diyeq7wX7V4U8OzYjCnZ3wYXP+7ruWsTPfK3NeP8DfGQiyWec2h79UfLK3p++ndW8mMWxrsyCNWUy2LvvU1Iq8ajWKrFPTVwB/VQuO59fvlqzltsJzk8NaI+0s+XRk/I1vI7ZMfb1n
GVNjxnRmjuWkLcwXST8h57Q4gr8N0ViaxUCfCERK5nouU/7Ql0em2/loXxqJb/xvWTSWPc/BGX/p0lhIN0dNRKL/MnlUvjz1xUfEuTLEYshf6N/KprE0i6E/r4yqosef+rJoLM1ijP/D9UGlaujTcoPlu3irw9+L
lgEac1gsIFV+dG9P60l/JBiVhMVux3Om40Oz4jtS/BX0DxZZ1M5j8vS5fqxExhbH382Og2KkR16Y7/pgg7xcKC5/WfKcX5fOo6vX7eukmRC9paR81HfKW+XeOV4g4zlg+XKzxWQcU1Q+RlIWC/sbE/axyPEm/lKN
I6uBzfo4n+nt7Tp2cm32td/nZt/qHVEL5LpCf2EXTbe2sKF12Ssum17s89KJqRqF8kN2g6IcLN/v7298TZ9HYzhmrPNpjGWxk7/QH5VDY5x0mOv0h2bRWJrFEv63SM6GlH+wzE/JsYmJVyube4pGK/L+0LwRZwlp
nl8ZmUUozPVfOjMqXOTlyyCLGf9bsZ+SozAvHjHOZMnxHdn+jxzLGO9P8WmMkkAkJpXkQ26iPQM+9sKiLfTP8DQWjqCMjOEj+ZVLvZWp+NocC1h8xM/hv3xdn+sPjebMs2SCxUi8ZAaNpVkM9eXQmMRIRFc2rt0s
oq9uQ8Tmr/vle5lgLunEN96VKX2lHGjry6axNIs5+V5jZ/g5L+gof6SzQc3XIYZGf9JH9Z1YxdICfAF5jWsH5NUvYuurIYe8Pj+C7NWTrKoL8VAmWeyH+y99y9h4RlMuGI+oPZRhJpPRmMYAi5n4yxwai4/7N3st
/2XCN5ljGePynwYoKKuNov7GHBtRpr4ojb3bv8rSJZs/lj2Pu69jPDkd24Rjnoy93SezHMtYgJqM//I2T7ksZul7ZZwY7/+IW8YSpbTiETPmw7IiVxO/5zSNpVns9A9mRxwW+2fu+adTvxf/u+ZG8bwWL2lH9uoo
jkvmxg+6I8t8acf73bERBaxhVrxkeraLNSpx/jOTH5jOmUbXSzNc5OUv5nIZp/IrH5kCM87jjmTzSd+Sil9OhtJRleHYymzL2KmPyUAWj8Uc2nEY+kbOzbxG/I0xq9dFXr7U8Y0FNFbsb+yJ7hyZp49axrgxY748
/JcFNBaVfP5Yzhpm89cl2fjGoBzyrWHEP1hoN+D4C/2h2TQW4BiHxZL5Y4uiA17OR5vn36I0ZmUjQBllMdSXTWNp/kL/VhmTRb2R53ykd0cA+/6oLA4zMjlDqRNvSpnslmUM4weZXBW1ip08ZDTLyCXRn+dzSa4s
908XkvoZnxensewRP8790ixrXD67tP8tm8bSLHb6yzJ8k5a08/WeEueb1fNI0BnG7siSfL6Uf6LyzNdcwGTMFfjy3dNdfL/EMsayGPrLSv2UERYj/ktO4rEDvPV1107j1NbrPMohTF5YPp7ALpnBQo6/sS2WE2Z6
tSTeb3BPkga9EivL2OfHZRtL01iaxdAfxVvDrmMzR+iTeMmDvTpopvNjCSmFJeIbCT1lS5P/1N0TGysVZbGo/5Jmus9sN4m+V9iK99eGOMuVoZKZXAQm/s1tDTVh+T7LpGfSi5e8167b8VavEMI74rciFGbdb9oy
xrOYyQaL+kIZYtPZR0J5Rex4xFsWsID/ktt/g7zI88vhcjq+OshiZ77X+78RzV+Llkaf/uTzme/rSni9o/68wrFhZ75S3zc5Z8mFHG+0nv48ThZ6CYk/77aPkcqovpxn6RyT8NcWy0sfyTTmy5hljI+/fMEydrCY
yR9rn5emLVaq+dnzaSzNYsbfmEljaRZj/ZdeiSPRlMQ/if7BG35Kbl4jE39ZGil5UNjFYiZTJfpTmjNvJSfTkX6GprQ/pYzJAvIkr2C+zTuWMTNaOuE/4rio3H9ZbrnDq+H95tJYuJW0WMz4ezJpzJEl8VHvjrd6
n76ccWw+F5ktJh4x7qc8cpXFJK+Ps8rZ460Ye1HAn3dvNH+ef7rYY23iazNpLM1ikd+LxWGe9CnsyqfqjreKy2iLbvTZY/BDI8FCUmVrUOduuAWlnj/UfOI4q2BEl/E35o+9SrCY8/xcrdzMDfYsDvr44/vV17vy
qNH1/JwhV/lyxtA56zyLob8x5rmMy8B8lQkCY+xjHJE580vaFrApczQWkaBPfyq3hgUl6OM5LHxelj9UDGemscXkVp0Ym5iWE7LVZCIlNXl16L/Ueb7ymYwjL6QtjM+7xoNZc4XH8pJynBWJb7xFW8bfmEljaRbL
9A82GbI1+vxot3J52kGK8rNmyDM/JmfXyMknRqTjj0qNx0nKF/2Nd/VlW3zw+V0j7PxMY/F5qELzhwaoKyo55uLjB+MjxKJPI+jPe8EydiO+9vBJy8rO8zsafTdm2apsqjoysWt/VJzGqAyNfefjJaN5Kxx9LDtZ
/kvbxqVpTOB6SLr3ixLLtxJe8WVu7gj+/+bryNB0+qd17MbxKwiv62wdOvMqXfeOJ+XLngMitn6Wj+ypKqGWVoipHRZ+fdpxvaHryl8W3jOoqD+1PjnrK6534fXPj8AeWxPahfQo9sT6oP1503p8wvUV16vI2Quu
96F1KB+zJ7huX/laP4/B8tlnXOWLrmsuc1nM+BvTNHblu7dZzCEyEy8ZpjHfApZkMeNvzKSxNIsx/sbb0st/GreMJVnM5D91qCtL6lE8zna0Z2fTWJrCsHylZBZhsWi8ZNwyxvu33khYb80XOQX8oXHKSLKYl+81
LpMsRr7fuAWMl/n+xrv+y5dG8NsUxsTX3p7lNDq/qS3TljFbXwaNJViM85elLFk+i51eR+PPuwhsNlGVYRmiUkn/sad/NZSjK0c6FOblZw31CZaqy5Wgr2vJfBFG5s/u4EgsH7f/yNcWka5lDOdbTPksCyxjAX/j
S5Yx42/krGF9tmXM2KhQH2+3ei1eMmfUfsLGFo+/tGiMSpbFjL8xPx9/gsVQ3zEin1rAUpaxjPyigXyrxb64LP+gHsGfZRkryPfqW8YCXJTljyqQJv7tbTaxQPly7Bosf7H+qJuWsZv+RjYGslhfgsWs+43T2J3v
w9d3yaxnfDN+kJV/mL6yb/yc2dt8H/oT5xEr979x1qG8UUMXcy1YPpXn3ZWROexP6Y2WT8b7rcYb6Wa1YCXGS4b25BKlI618qnFJ+Yz9N6I+m61ekkZfJo2lJf6e2f2MreL1+fO4ll7bY4g0+Sdba0+cEHxJiAP0
6U8jxvjZsjrlgEzhyx6P7K/jQR89L18ypOToo9fjZPQ6eL/ulah9jLOMMd8Qzi/pjRojNMZFRzIs5vxeblnDnPjB0pFRUXnoK/VTpvTZo8Y8u1V2DoOIvzFfhvyN96RHHEH/Uek4Md6/9fv4G/Nztab05XveGBZ7
4fsI8lfEn1fKQnn3S8eMZWjN9F9m03nUn3xYamzpUxjhCicfaA6TRaMpM/KBXr8/LpqSsBjGD3JMlhvpd3DbZsVLXkymM1LE1pvA+mz8l5of9fM7WPIiNn9MVnT99IdKYzO7NB1WRpfbfK8jWTfxq8cePTvABFpb
7ozTeuXOSHDktyWfAuvHbA36W6YzlDrrunVE/8zt2fJ86fm3GA5L8Fcq3m+KygiLYfmyaSwtUV82jaVZDPXll4O7ziG1v9FnMu674TnasJiyx+bTWJrF0vGSZZaxjPysRZaxy395dwQ/yjOLJ8nfeeb0DMqc2XFC
+nJ0l+fbPLJkpv1yDoUR/2UpG/w+/sa8+SVzNKXi/eiTCOXITY/Bb4y/0d9T6s97x/Pj/Y33MpD5pDSZ5xfcE2UaNl6Oybfp++r06Kmkt4/N3xnjfHpkSb5XLfl5lAL5FrB8IfY6CSwgt3o/ZFfhc9DbdxN/qfNd
bETrTmxwdPtGyJCun/SG+tK8dzyn2ei+1p25Pcn3cVCfS2/cepADSX1gj/l3188ZRyPrC5bPZlNmPdcyFpgvMC4T5BWYHzEuEyxm8pVm0liaxTCfark1jGUkk581k8bSLAb68pksTKsWZ+H3m6KxeN4w69vH7/eG
n5JjMSt+8A02Md9/+ZpljPWHBmmsSvJS1nx8HL29Tx/LYon8ncXjxN7kj8r1X2Zm0c/Ql++ptSjsjDfNorGgtK6ZlS+3/Pn9/v7GAp9g0D8YjbrLGEllWMzkKz0iC8Nxhzyfeb+gMz9rFo2lWcx8vyFvZdz2dckN
780wF+g72csQWA0SqmhcbxSHmfUaz0bystari8K6yppPc8fy0fXNIrY1vX7mj5XBo9bTJnbN4Rmg0ktm5WfNzy4rPz+8a+evB/hVly+XxtL85fkvexzVnfZA8v6yAhpLsxjoo4TzsmUs6b8stIw55Sv1WYb8oQU0
ht+N/rb476OAxgIs5sy/kzcfZL5l7DX/pU9eR77Xl6iPsBjmK30PER3zGf4IfTmWsbz4t0LL2BvjJe/OLxllMed+EzTmsViLvWki0T/tbLNkzrj2155fub+x9AqHXUAa/1YGl1gkEpGnvsBYqgSvuHI985+GNVnj
vurwqC8qV+MvO/LTX3K/aMeSvjfSK71TPp/Adqj0a18aCmthvTKyr3E+G/opsN4hsTW4Ra/XKNuL28x6o/2hJ8tthOti65QJPT6E+91cQiyVaAM0EvSVns1x6lG+jKPoepzFiP+ydAYbymInkaF/K2eseKZlzPO/
xS1jcQobTL5SymQv2sRQ321vpS8ZfyjPfu4zcZ4i8SdzNJbKqH9Zu+z5JW0auzHf4hmPWJ5NayTHWOsmPybd40gdW8nttaTtP+qisW3+bHhTTfM50fnu6J7ROi+9bs8mOBL/kbPnXB+99ZFff2s83XTGSwpHHkdR
39rlIaDZzZ319PxvZd4l4s+jfCaivBIZM2biG51RY07E4+ytsyxrvg9Ktu4z859fJF+SeX7XHv39H15C368Y/iZOGf0+fPuO7ety1zfjf9vsbUkZaU9RX7SFppLVdNJPQB8lrBhtBVv6cPnipQzIGtmpabD9UO+n
1Hu07FEORI54jJZT0/gS9dFt9Izk2dn6/GP1dr+sIX1j05LzmuD6QMo68BL1RfYHpb6CwFIoWV/rqn4heypsf9IZOFliQ/9RaE/RqLBKjSpXxCGMf1AQyY/aj4+V8v2DwmRB1ePaXSLypU9Eg+UPDXlCL8lRkKCc
R/yNtSdPn2q1n1LgFlYafdzz48ZysbNCcvNBWpLavqgMz4+o95wSvvzhlH728Lz4Mjt2f67cUc7cuisP/1E8Lo2z8hw2iemSpnz+vMgCpW7hZtPmiXO7bgUD60Yfd5TdYqbXhfFfjuTaAjXNRgqyPlVRdqk4/0zY
V8ONg7HG9ZD8ju4YkstP5K+n/BW254EbjzM7ZfXXXX+Zm40glRMh5B90GcoeE35lgHL9ZbW1Tv1v9nicw1qixiwfVh7q8YquW/4eSVhE2lziSJsi5OHl6mrjjyL2AUMQDaGJJipbbdlBCfWBqua6zkjdJqoW0JdT
hoTvt4G2C9pKJenZPbaxPWnXR9KuDxYtHC09aAV919m6fJzUZ8ePgf4qKYddJlXi0Ss3laO5tx6ZAOrnTuL9Vt0C2w65X7KvUTbQFtUgR1x3JBw5XBL0nZ/6toEeJkhRtA5t9XUF5e85P9VGDuf6UY7rmArXtaba
6L7WlT591EjOcKR1Rxs+n919Mub5VHi/taWDloneXQeyAQm1Sd83UmXgr5DI9Ovz43//6e/zPz4/Pj/U+/qnf87wvf7pn3+BAoD89//4y79qfcB/3f75P/71t7//9n9vf/2Pf/62zH/9TW6/zeu6rb/962+/yb/9
699++9e/bb/9P//c/vHb/Nf1t//2P//5r+3ff1v1af/8Tf7Hv37721//8j+PHb6+f5v/v+23//YfUm/6P/VlQxf/zz/Dxc4D8Wp//Rso3Gco7m//5W///u9q03/++S+//fftr9s/5n9BQf/62/aPf/ztH7/9579t
f/3tv/7tP+Rftt/+y1/+vPyPbbWu9Cf5p/2fzaTv4/9iCmuu8Le//+vPf/vrP/8kK3VOl36Q/+/yv/709z8v//pff/o/1Pvf//G3v//vP/3nv2//mvc//2Wb1Lb/HKEWViv/1g59jVv++9/mv7RCVLhVfWiqsfpN
MXalksapV7tO63h8p0tzrcPPQ78w36+zDerprq22cavlAr9RfRZsUbbsaln0QRP8cqoZr1WZ/XjG8Vn94vBljsHj8ZelPtfHXnVmNe9q29JVG17evLsv6MM1iosa5IXrl2oftbavLXC/L2r4hfU1q/q9NEunFrnj
shUueNbSqOXQ92Xv99H36Hv0fVt9ofaDb2ny2pmvfL9a37Cq5Y8tX/418/Tt9SyGDqQcRpDLIPZm3oaFyFXLzw/yaTHHHueBDt3erNjWvK98735+j75H36Pv++oLtyFdrewo0M4MVzvjt0ff8X5/Fn17/fkxT0O9
LfcXaGdAg+7drKBvrWHJuLayzIiB4w8x9L36bfj3q84K/eJGePW92tHCebJXn2Wvj7wOp7+/4xq5i9ZHr5D6PkJnxJ+ALh8tWVwHt/d4Sv7/zX9O+feu9YX+7n1//JfVdekZ8ePV8zvOeMfytf9vj77XlnB/JtzS
uK/veL9a3zt7NLnly71mrr69mod+29bU8vnB79M6jpYm3c6oGkiVr+91XReuaXQtPI6t+Y3IXh+layl1jpL0fvUZrflVXS2NX6fKXmtqodYNtzbh58fp0yVTZdVlkr17vJqji56hy+pfW5+p2gF9pHoCoWte5fP3
x55T6CmV/F7iz4F/fukz4st3qA8efb+/vnAb4rczofboO97vz6MPWom2F6VuGctFgxr0B9OfyerRxBddM6n62e2h5LO9v8V+fnp/vL2LX+HQp9oF2R+/56tu58rEXTP0/b5y10pfbh8o7/dyTwd3/Nf/fzz6vpa+
3JYmr535+ver5Pt6NPnlo9fk17X/KH6UXqCVqPsu1ZZAfya8Z1aL1pHfo8m7X03e1CLD125aX05LQ6+Q0ucv8d6DftE+2HG8tjfx9jz3leqV0fK9465L/x+pdsbX91qP5nvUB4++319fXjsTbo++4/3+PPryWpq8
dubzI7elUQu1X4XrWvV7obXSqz2az4/X2D6kT/tCdHso0VKl70j3a8pagctfofTpXlGsfU3dtWuvu3fXod/fe3o03+H/8ej7WvryWpq8duY73K9a3tWjKSlfzjVL9BnLWfQF/RnupUcDENtZTjsD7RFpY3wvMrek
7C9cnavbLd8f4nuBUs+PXkH26gr6HiT2Y/QxuuXRWtUe1R75ZeZ8NJc2u1dE78EuH23p9FMsbZnK/x/xK5Tb/1K/l9LyPfp+Vn057QxnX/uO9/vz6INWYlQh93eWcywAaND9mbyWJu6t5u/3lR5Nj/0Pu++U38b5
Vzj0+TpoKxof4WWPOtP/D2701nFV9x6O/5DvF6L2uvynmPq93NPxDntdSfkefT+rvpyWJq+d+R73q5b39GjKype+Zpm+dDujxgvktTR57Yz2T6u12Kivo25SbN9a/Y2S+71Tp6b1VdXlX6F9GbpcowOu8cB3RluV
le/31Offe/iuXPta+oyveb+Pvq+oL9LO1Lqd4fozd3s0P9fz+3H6oJWQw7TXtxbT3igNnx9XboCSzABcNM3xe+Fq8pwlNf7qnr7K6Iv3h2ivLad+/S6/F/okXunRfK/7ffR9FX3pliavnfku96uWd/RoSsuXumap
vr2W9djsLS6dv0B/xt2mz/Dk+8abve/5lfdovtPv79H36PvV9KXaGZ0T9n09mh99vz+Pvr2RUP3uQ/bSwvHbPm7VsulzVfvy+fGO2Jnv+PwefY++R98fp+89PZrvc79qeb1HU16++DXL9e2dXCex+8ukFujP4Ps+
kqWWy2TksqvF9GUyls+P/GMffY++R9831teQ5W31FdPOYKLptlU5yt/Zo/le7dHX1rf3Sy8GI9ulFf1eLbVoNylXUW1CymnbJjnbchlwGfXy+XGsvWd59D36Hn3fUN+EywL61ItSaKHnlq+vwm1Iu+NcvG1eO/Od
6me1vNqjuVO+2DVfvV/9y9C/GblI+L2A7HCp1DLvry2fH69qePQ9+h59X1efqS0WtZi2R7c2wXbmTn0Va2c+P3Jbmt+vfn705ehDDln072Tu1SJwmTZc1vDy+cHtubc8+h59j77vqE/XFtAeYd1h2ht8M/2aN9RX
cdtZTjvz/ern13o0OeXjnlmohX79fnXPV1OJ+r1gG1OpZTShh+4yoKyqWnbN0HdNLf1jjuXzg993Z3n0PfoefV9Ln64tdHuj6xFdp4TamXv1FdOj2eod49Wa9/Vovl979Lq+Cr8/9ZpuPbNjUVqAX6p3Lo++R9+j
79GnlqM90v0bbU3TFrT7PRq3PuVbmrx25uvW99Dxk3IGvq9zF33G+8qX087k6ZtOTakXH1977/Xoe/Q9+n5efVdLk9fO3K2fw1dvt8+P3JYmb/kR7ZFuPbY2Z/n8UFKf8b7yva9Ho/lFO/136S2+e48Z93wsZvyz
HvdMo216sug4z5YsDS4kx0Du77n09eh79D36fn99Rzuj7Wvv69H49XP4+rk9mq/bn9HtjOrP5LU0ee1MaX4ft525nlyZPv17SLcz0H5ktjR57QzmF8hqafJeX/X/9uh79P2a+sp6NPfrZ658+baznOXHtEemR7Ng
BsmohP4Mvr+rR6O+X93GhFqa8t7NYY99V4/Gied8uUfz/f9vj75H36+o7/D35NvO7tbP4evntTNfuT+j2hntn9FtyDwObSc56bczofktdfniY9bstsVtZxZcji3695JzL3ntDOnPWC3Nsk/TUC3d0Dfw+xnGtlrm
YQa5Dktbr7OohjbUzph8aW/r0Xzd/9uj79H3a+or6dG8Uj9z5Xtnj+ZHtUe63TA1cURi/YyfXunRXK2K6n/wT7f8War7faVHs9RD22yYs2bYNrF8fnQ7vA8dtBNi6ca1Gra2ud+j+Rn+b4++R9+vqO8Yv/bOHk24
fg5fv13rLdXOfO3+jNKX29LktTN8+WLfI79+/V7c8WT+FXLaGas/47Y0jWlpxm0SLbQzYtqhnWnE1kF/J9zOnPmf39Sj+cr/t0ffo+/X1Jffo3mtfubKl9PS/Kj2I/fIvHYG6tPMloZ/evtOnx+1luk9dEus7Qk9
XX2/L/VoKtLODFC+vdu2aZKmpZmWbVjb+m6P5p3/D7hN1Beai/J66b2TVLLx9uoteq+S6C+T17bWGyZOz0jvLbvfbrtKHH5d+vS1c++Luyu0RxBN/otq8q+jSxx6fvS8+6+fo37+WfQd41nf16Ph6ufw9dOWM3W/
P6b9yNen42LeE0fjxx/5rYfftvDr9PdC26mroqNXS7czTn/GbWnqZoWWZpmGbZi2bt1G6NjsaDkbtKfGbWdAX9H45tQr7/+ha0iuXqb1J/w/vJqS7udajMH7xeua9dDH7ef2cq/jftMtzfHi2hm9/Shfzn3ltDOh
5xdvgWi75r++dn366ONeuT2aV+tnrnzv8tF8ffva3ecW7rHo8WbuHq5fE+vv2OWLtzRLO+79Jtt+amY59HMjpegXkEu/NYvchgramVa1M58f0IWRndz6aWjXbRdT1y7yGhmgezfamqZ9N2s3bt3MtTPv/X+0k9bH
1ct6u65T/fqQ7j1eOeXTZ1Ct3DXV/JJpffTFtTNaX2OVj2tpQvfFvYw94laPJlRWWr539Gh+lvr559FXGrF5tz4NXz/VzuSPl/p96/t7+spznYXij9SfeccX325wW2z7WvhYerV4O6Pys/Z9I/ZKimneBtH27dZO
Y1eBbNoBZbMJ0XZiq8atnWFL3YptFV27Q2uj3rB3o21pe/P5obw3sA2aGdPjealHk/v/4Ho0bh3s2nP0i2P++OuwD9Fr+1rpuk/77uu6X66l0Zr0Xv3i2hm7fDmvdDsTfn7x3lesnfn69emjL/zKa2der5+58r2n
R/NV+h+/l76rjdCtjX5+usUobYFCLcxVvkRLs/VdM+l2Zl2ntlvWaWxbgYO651WOE8hF8Tg0snLs2lYZz9retDe6dzNOAlqmaVq6epunvWv0yDQ9Ejrcznx+lEZsxl9QPqal0Vt0TcgRue+5OOxDVNKega9JX0FL
vyyfH/pTfp3v1916iy7FUT79irU0KXno8zX5r/wejV1fvd6j+Xnq559H3zt7NLH6NFyCeDtz3O9Xqe9L9ZX2aFL6aCvh9nGu9auFCdvX3F4MXeLtzOfHvPataWnkuk9LP0Mbs3VyXaYaWp1t6rptq6CPs6/ruHYN
NCsbtCrNNMCOQdR9t42iAQmNTd9/fmyzmPph2+e6H3XkzSs9mvz/h1+3+3XmYW/ibEy0l0BftIanW2x7WEM06WOpPmpl419Un19707aKXoG3nGl9+feVame453e3R/Md6tNHX/iV0868o37myveOHs1X63/8Mfr4
UQKp/kusfIkezdI3zbTtqp3Rrc1ey3maQUpcX0A2nx9ynaRqb/pKtTTtvkmx9uPeLdW07v1Sh6SO8wy1M6o/884ejWu/0i+/9eCI3K1f3f+bb1nj2o3wuLZw+eIvWne75yp9tF2Ljwbg2o3QeDh6Bje6wb8Hd7v7
/F7t0fxM9fPPo+99PZp4fRouQ6ydue73K9f3saWsR/MV2rdYO6PGZ8ttXPoF+jXQ3sy7sqPJuh8aQcYHzLq90b2bdRnndsURaJ0eK6BHpqmR0J8fzaYjb3Sk59qKfnxh1FnJ/4PWxVz9CuWrrj2+v4SeR6XfIzjs
a/4eri6OX/koH6fJ7yHpV3yMQ8geFr8vf/RdyJ7IjWwu7dF8j/r00Rd+pdsZqK/ekJWLK19XN3VVt939Hs1XqJ9/R33jCP9gKkGft+0Vaet7JY5Gtzaq/6H6N2hNW9F7o8aeya7RY9NK42h0f+Z9PRo6XkrXdZwl
LKe2/9H/3+PlRqWE9fmtQXq8wXvK9+j71fWZlgZfekZePf97aY8m7V8Ivfh2ht7vF6jvf5y+m23I54e3bVNy37dZwLrcVumfx7czGG+aammwd4PWNLnKUYdutjj2TEA7gyOhj3YG42duzBOQ+j3nvfwaN6Qvr6XJ
e/3e9QFtaTgvi36F25nvUl89+r6nPjr/WWiGTezPvLFH4/0/XuzRfNv2I3dx2gKMX32h/7I3M0o1ekDrG4Z39WiULe3zA8cKzGasgMSxaes2iK5vdeRNWY/m6M+8q0fzo/9vj75H36+pj7YxMy5yUQsKmdujSden
4XJw7Yx9v/n1Mhejz89/mTPbZcn96nZ6bnGRapFCLbef3xvsYWy/ZoQGIaudMf2ZVEuDvhvdzvhSW9Z0O2P1Z97Qo/k+/7dH36PvV9SnaxZdO5oWBm1muqqB+qrBpbAe5toZv3yv9Wj8+rlktkt/DrJX+h+DVEtf
q2UY1TKKz49RjKYBHzq1LD0uq1qy9AbsYdAX6YZhZ15bv3a6t5JqZ7ZFjS/Wx7bzG3w0K5RP9mZsmh4JrSNvoK/TN2JpRihcSY/m6s+8p0fz4/9vj75H36+pT9cs2lK26BdWMqYvk9XO5NTP4ZKE2xn3fvNr+3A7
o+dPvjvb5al7VcssZmg/ZiFHtcwVLoNaOqGWAV/jhC1M1w/90Mxt1Vb11FRNNbZjN3bzqBbTZ0w9P9JKbIt6SMrupf0rttXL2MagFVL2sG1x2xDLdqZfk7agiUpEezRnf+bGXM6hec9A3+25nFO/53e8Hn2Pvkff
e/XpmuV++5G7cOXrGmhpmns9mlD58me79OcgS91vo5cBl00t7dzKVtZb0zUdtCZzO3dVt3ZrI9qhhfq0btXSTErCcepSuEVfdV7Usla4ZLQzeePNTGs06dboakOudghaIez1QH1PPr3eowF9t+dyDrUztD/zjh7N
V/i/Pfoefb+mvlhLk7fktUfhsoTaGf9+88tC25ljZkvg+xdmu7zWW/1aPj/aBRZsMpqx6Zu+FUr2XQP9s2Grx3qcZtV4yAq2VKvoq25fWug+LU2vKs2pm+A112qR9eeHBMl6w0q9/creqSxrp7//6Pf4LZC/JdTO
kP7MW3o02J95Y4/me/3fHn2Pvl9RH9/OvHf8FVc+qFKU7awt79GEy3d/DrL0/bajWnrVqEAHptu6faibpVmWUT3EZVaDRRccNbqY+Gk4R7TT2nd1B9vg7KEb277tJ4njEHTljTY4bbSMtTNkvBnxswScNJ49zLRA
k1RZLk+LGrSXsz/iWf8e7ry+xu/50ffoe/R9RX2v9mhy26NwaaCdUZK0M6H7zS+N386c8R/JlibZzsiu6aD/MSy46H7OBG1IvWA4wtJWQ9UtXSUrsazQAs2rapWqdepEN65rX/fVIFXvRvRiEcv5/BqyRFoap4Xx
eiy8fW3rR+OXUWPM3JFmdMQzHe2ulyO/97uWR9+j79H3q+q7337kt0dcS1PvVYMtzcy1jSXt290eTc799hss3dSqZVT2L+ieDP3QL6Jt23qdu6qFPkG3d6safwCt0AI1fDvW2zh2Y7O34zJKUQ3bsE2rGk2e9eSs
8WbxFoO1pjl9GTU6wIrnZCI5rXEDdFwb1bQd9rpw/8ofkxAYMxew8n1+XFa9fVo7aZ2hS6nvy9+eF78a92XxTy4x/o9p/1PPUulTVwqXyWzfcbu+x2iv1hlPyBzr3xe9/t7I7Tpe+fP4u8vxFxp9RoO631OHNRJS
bvBdRz2MoedN9fF3QX4p5N8Teur098J9K1n/D/v398b69N3188+iL6+dCbdH+eVx42j4+JnyOJppmSS054txPHRTD0ulnA9rO+zDtlfQkszbPsFPfm9FJ9p9FLOY9mWuxLbv86JiatT2aVIaMp8fNzY5OIpZPT/9
v1C/dl3n2qPOymRufGhOrV2i793lyy3xpc+0Yowd8vcpX/opuvpyn/v7n1+ePtpCxlnAoobzqSve+Bq/l7fo+8L188+j7509mh9/v4syfol5mOG17mITq+plQHdGSZVfZZOThEZISaC0XnbrLmtZyQ5HSTdlPZqQ
PSweTcOzPafvFQn8/GKN93uXj63VSR0YIuUwu/9e5St9itzxf8Tzy5HWMyZPNGXfLW3fv8r9JvX9sPrq19GX085w9rV3lK98tsuc+116Fd06N6IVrRxVNgBZzQ0sG8bWqF7MosaUwTKo/ACLOqNfK4xUynt+Bb/p
QH6zl+Sj74/Vl2pnfnT5Hn0v6ntjfXqvvvoV9DEtzVZvVd02TZ8/6uwL3W+n5CKx3agOb/5byzf+8P7+o+/R9+h7j74fXV/9AvrS7Qw/vu4d5Xu9R/ODnl/2b/rb2A8efY++X1PfV6xffjp9TEuz1ju2NNlxNN/l
ft+0/Pj+/qPv0ffoe4++r1e//HT6Uu3M58f9uZxzyvdqj+aHPb/M3/Q3sh88+h59v6a+r1i//HT63tOj+T73++h79D36Hn2Pvj9WX7yd+fy4P5dzXvle69H8+Of36Hv0PfoefY++lL539Gi+0/3+KH3LtszLIJd5
FrMcxDI18zZtwz6Laf78GKRsRD3WUoppHJd6bqbue9/vo+/R9+h79B1LrJ35/CgZDXCvfK/0aH7k8xOjnGc5TrMU/djNvajGZZ5EL1rZzYOcF2gtQF+97Msqcc8sVXINCUeMrRRiGAe5CjHCRtDQL43YxmUZ5nrc
lmlux/1r3e+j79H36Hv03df3eo/me93vu/QN1bxMS696JKJf5n4aejlXU9sLsU91Pwo5bpOA9mfQvRR1HHRoOuirVEsP7cm+CDirWUAfnFfBpw7kOo+wbZvnacovUVX1vRiO74WORxdD39tEIAZ9hjon9J2qM0L3
a18jfIVxlHCuUt7CFtmPY8n3kXe2f7y639AZd0tMy8eVSWkO/XdGePU9r49bZK9L3IIGW19r/mmyP76/4/sIf4P61ZpvM/0Uv8v/7dH3vfUxv1NoZ+D/WzS++V757vdofuzzGzrZinpQ06ZVQzOv0zpM8wZbGtP+
TJ8fk5g66LBs0E+B1kVW0Oo06wJtzbjs0L8Raw3nSWhboK9j+jIbtDPtWslp9jJXh8una1O/PqI1F61ZdQ2p6h/or1rfIFen6iv4LZa+gqpV9ZGfH6ocZW1F7PqfH8fZum1U96jbwOMey0qsnp9b5lSJ/b1XO/35
oUrjtsv62iX1/HGWen60zNw3GP/eU7+X+8uj79H3ij6+pclrZ77b/b5L3zRKaBWgG9OJBjotlYA2U45iGhYJ9cUIbQi0K7uAumpVfZ8Z9kGFAU1JvYhVSCGmVbVJo7KvQUsDp0EnZlB5c6ZqrZZBbvFy6BqvRa6l
NZp9v7pd0eR7nRVa/DpVb1H1qd4WO5vTUfJ9cGermlb2x2/uqtmP8vllfqXEdvm4p5LfMqV+f7SH6bdb/vdn69PPJuf75Zbv8n979H1vfVw78/lRGrF5r3x3ezSvPL/QjJ3GHhady5Ouy2qZ5Ab9GuinDBP0blqQ
o+jHVkohlX9m2eXQr2JGS9mKLc0wDkM99tPSdQMcDj0g6P1AOzNPvZHt0slgXeHfb06tztfdqr8gA5YXdczR09Fn4++B+wmcNprPj3QtHF/sc7U+WgvrF2V4rhUIlZjaE2l/o7TdSNnr3m3/y9GnWyO7F/VV6pdH
36NPL1xLk9fOfL/7fa++eVxaOfaDEOPab9CqbMMm+nkeoMMixn5Vo8fmVi7zCC3SNu0ddFWmpZ2HapqgglDxyXCM6Ce5NotcCkaahWsgt3ylRO6eq/Rxx+pWQNG0pvAcy1ns+/DPpjwvkfe1JUmTf6h88RKkS3zZ
6+49v5S+3O/xjr47vZvv9n979H1XfeE25POjPAfNvfLd69G89vz8a97VN41zN8umw1k+Z+it1NMyr8sM9cE+d0sDTL4IM6vO1IsV6gE5VXPfbSN8avdhVGOaYY8sv997PZqQvUkf6/sv9HbOR6PrNd3D0OU7+hi6
1+CfEV9oWVV/RmnT7QrtZem2R19V7ZG9fyd+iY/nR8ucU2LfcsU/v/xvxT/+ffr0vSt/T9nTjy9fp7569H1Xfa/0aL7j/b5X37DNkxy7YazHbZKzkPtcyXWdpl3Wyz50k5qjQMoGaohNSDmOjahl3e9TMw8d1AfD
LkRX9eso500t+WVJjZfij1ILP2qKepepPn8Ml8/O9Go9tmr2kUpfnpdIn+1fgXrIlf/DH+P1SomVPnvU1/FLdz1Dee2Ctv/Fv8cSH038+enFb0tLfs+vLY++Rx+3hFoQtBe/sUcTK9+dHs2rz8+95n19Qzt3sodW
Y5Ir9GTGdZ+HpQF9UnSyW5txF5sU+tipgR6NGIWAemCA/s3/z967NEura9li/YzI/7Dbbtigt9xzhLt2x93T0QvfClfVKd9zblQ4btz/7imUfCkQAvFYuWAtacZmr4+EwZRAGgxJaCpJBNOiIy3TfvTG25b87h+j
udLzN/U1PH/DYxlrmdji+QHrM7yumd8xXqrCcrPOcsrzfbznyzMVzR3Kr+JdHW+eQ0p45p75PRePt6BiOCey00jIsaKxjcSqMy+e4UoyjZmAowwV3CrAI4S20Dw40hLCsLdyb8rmNx0Znf/0/Yh7sZZHGsK+ML4f
FM2WucRXyW9sJd/RzM03S2tlmZb57vxWvN+GN8cfpUxzhn/bFc3x8htf8wiesJrqjlHZKb9tpfPrx4JyQVypVlvQKli9mIZpjriglDomQAYhqkgw6Y0Tb1+T34pX8SpexftevIyiWY2w2a/HfcP8nounmeFGM+J7
0JhSwn8Qo7hmjAPPtJwqUDGvI6U36kNGG6KJBj2jg4V94fer57fiVbyKV/G227ye2RfLeY9/WxXNGeUXX/MMvMA2QgNpdM8Hd8pp7XvQgD6MbWzyjf/AOiXccrXnpeJVvIpX8bbjZRTNSs9Z4KM75rfiVbyKV/Eq
3mfx5vXMWWM06/5tUzTnlN/7mte7HxWv4lW8ivfz8LKKxjWo7zlTOT1TvwereBWv4lW8irdu83pmjWnKeKbEvy2K5qzyG69vdsQk8sa0N7/ev8EGh7H91wh/MNWb6C0c3E8DoFF6fUgT2TWfl4pX8SpexduOt13R
vPnojvk9C+/FMeZtgVxY8zbd9TZhm+dj4Bsq3saCjZjmSvmteBWv4lW8vTavZ85QNGX+lSua88ovXPMYXsCIeQb0jPAWM41pvc3zjRYzPBOxzTWfl4pX8SpexduOl1U0FrYzs5tjPrpjfs/CezFNxDdGeYt7znxP
GtiIbUDP/OGbLNP0tsW/kmiSwdYibIb1GNPrnBGvctm2x+dcPqPMY78e2ZY4AWF/fq245fXXcpZfGSCsx/M+ZuxZX1dTNxZWVrhrfat498Ybnsyxnjn+HU2pf6WK5szyC3pmX1zPsd9v83gmpJ5vgrp5Ec4M33gb
jdHI3v6wDOAVMU1phM3397XvGJtHImz6+7E1XuXa/c2dvSfC5jReZVwqeyJshnik0xg5+yNsTp/n8rXOUluL57DHrtpeVby74s1zCO7aDrZ4Ort5zEd3zO9ZeMz1FnHNS5qQ3nBk7dueD9F44503FkwmVqBohvW+
cDONsRnb1gibXxuvcuvZYX+8qpfHW1pJeavHIf7bnshn88ev4eXuY463fHzT9TtYfs371reKd2+8eT2TZ5oynin3r0zRnFt+QX+URdLM/f3imRfbBLy0N21kOjEV2YhpAA+2y7nYsnpzGr8xtyZjWYTNffEq1+5v
evbeCJshv7lU7vFc+W1lprXn+TjeWv/fdrtue1Xx7oo3XxcJQv6pJWOemfLRHfN7Ft6IaXqzpjfdm+xN9Baoh1rfvzG8r6LeWm+m85byzbJvZf0l297Ip/k9O17leo6WI2z6/rBpjM0jETY93pmKZqn/rzzX2/FK
r3nn+lbx7o03xx8902DUpkxTxjNb/CtRNOeX3764niO/Q69XzzCAF5gmpFW+mWObWN0EPXOeopnrD0vPK4+wOdyPrfEq1+5v7NmRCJv+eV6PClricbia778anvftzJTPb8kZZXhHokGs+XfcKl7Fyyoagvw4JEX8
zTMpH90xv2fhsS6ywDNdb1m2AbwFvkl705a9K+sv2TJrKtzfXDyTY/Eqy0eJhrPTCJvhfoxjbB6JsJn218VRQcfPeUmEzVz/3/J9zI/RBLzzxmjuXd8q3r3x5vUMMA1DtEGYIbH1O5pt/q1ri68ov9MUDZiPxxzM
Nd7W+Gaebd4jN4Cny5imjGfuMx8pHRPaE2Hz2vUth7d11tlcPNL1uW7XyW/F+2148xxCOCgaDDzDB56Z46M75vcsPN54i3WNQ71l2AbwFvkmnSuw5t+ZvfdXuB/LETbHeLEO2Ne+fn9+Y0u/oxnqW0nEzO39dd+d
34r3+/AyTENQC4pm1HdWwjNb/VvTFl9TfscVTeAZ7uOz/+Ebh3tb5Jsc2wwz03o9U8Q0W/J7dvlVvIpX8SreFrwMzzRtBzzzZ3bzPB/dMb9n4Q1M8zZHe5tlG8Bb4Zt0JvS18lvxKl7Fq3j78eaZBpvWbl8ZYLt/
y9riq8rvBEXTegt6ZjDtmGoarRmUmBaM+zEGRmGLGYFtw1DTKOuHp5WiHWw5tbAl1DTNsF5azDfn5ffs8qt4Fa/iVbwteBmeUa0BnmkDz+T61+6Y37PwAtO8rOcZ0zJgjDm2Af5Y5Zv0O89r5bfiVbyKV/H242WY
RvRM02xRNHv8W9IWX1d+xxXN1/pX8Spexat4PwlvnWdyemavovlZ5VfxKl7Fq3gVbw3vLEWzz7+8tjghv/2XkBJLJDqq/ffdtMUOS4yxxgQZLHCLNDaYY0QUoaRhmglGjfGLK3/X/ah4V8U79v39/fJb8SreeXgZ
nvFjNI0fo3k+9sUJ+N78auvX4ccIKYQwRw4R0sL/LbEEYUE4HIKxAh7lfi/CFBOJHTEEPR+Ykw54h4RF/z99PyreVfHmeeY6/lW8indlvCzT2MA0ZTyz5h+0+1or2ZZaHx8MztiaLykllwQYRKIWmKRFjPj4ber5
IALUDCWOAMMAkxD4FZoNEDwO1I2mLWF92BjYwxC1dGWV/vvc34p3Ft4RRXPH/Fa8inceXoZnTOt8hM3nY2/ks7EF9nDg3+s7k1ULZ2zPL0fMMuH5ou2wBKYB/YJcC8wBmgZIBmmEMUUG4Z5rGlAy3Yt/JOKg37qW
yU5auZnjhvKMV9iKx7e2R7tMY10O8zf2Rbssf17OiN9Y4uWWeJ/LcdECRvod/TgeQrqeWz625RRprkyW7++ybY9Huj2iaPCv/LlYWxsvHa9N15vb8lR/f/tX8T6Flz4LfV16MU0Zz6z7NzBNmXk+KmOaqQkiGm6w
QB2iyCGOEDfU+fWglBTAKoxQRwXQUYc4MAxDHeXAMoQyYojXb7alfZzlxbWT5/NbGu0yjXUZ4je+bVu0y3Tl5fX175dtbb3/0Hrn1n5Z93LA88eUxvtcilYT4oMt8XjK2ktrifn7m+Zied3rpViY88/L/oii73if
256L3FPx9m85JlBJRFH/b49XHsN13e7Unla8eVviGXied8dyHtvQH+aMs2AF2xKemcuvwqqRlknaQf0CHkFSdAIxqq1QhFoFJgXikjegW7hwUJE6xoBnLAE8TJAFarLbRmdCXcTNNNbl2L+t0S7TVjasV7832mVZ
+ZWfna65P6y/Vu7l8vXn4hv0T2ejX7wS1nCeXw1sLd7n8Ug0W/BKynjAi1XYkYii2/v/lnM98Me+XB+Lv1piFe/KeFmmKV4ZoMS/l6LpOURxhonObZ0BPpowTUnky2Caa6aJJMJ42cIEtRrwYC82SgPVdH2yxLbG
yVYI7qilhOgwG4BqSugqf+6bj5SPVBza57R8y6JdRvfsdVd8/ID90S5TXwNeSY7KvAz9L8fjfQ4ME9q/8hKPf51ro8P9Td8eSqKqpW8ba/2TOfWQjyiaxvssey5yeYj92xpLLo9Xck/L7F7tacWbt8yzaVponxt0
pqJ5PmTbaTBVsl1XNJn8hjnNTCLhGKKCONAtVmAjYL81CJQKcdwJJ2GvED4SgkOMt/36L3zfTLOy+Uhb6/D0XI+33MotRbtMsZeelz3MGeLPHIvJWRrvU7IQF22+PyfvX3ke1+/WNrwy/6YxRY9EFPXlt/W5WLrC
tL/u6FN9jfav4n0KL880L55ZiUdT5l/gjRKGeT5KmWbNDDXEEKi/hIO+oR1nwhJDHRdaGGobIQUTrbIKxM6x+7FP0cz1D4Vjy6NdBot7sYJ/e6Ndpr7O9Zcs53rZS9+epm/p6yWQL7/mtW/KN8t3JTey8v6+bH6M
JleiaU9i/nlJ/SuPKDr3vByJKLrWv7uVmfLxK3JP9bLdrT2tePOW45nnY8+qmjkLeuZMRVOSX6O9PFFYMyMUhS1nSiApORdOES201HoLXs7K5g+tzeiZpnGbtTyfay3aZRrr8v2+W5qjqY1bsbT/qsTLfAmk88Ny
Po3HbvwZczPJ4vlSR2adDSUaxw9dzl1JGQ94KUbs35aIoiG/5c9FnObGheL+ujOe6lx/5167Snta8XJ46bPQ11k9fLG5zDOl/pV+RxP4yNu+72hG18RaPB/aam64JVoZaeHpV0ob1vBWtCBspFicXVZ6P/aP0Vzz
eVnrL1medfY1/m0vvz2jVJ+8H+n4ynpE0dDeby/3K+S34v1mvHkOgfZFlTHNlfOrtUHALp0TzlnqGielAp4RrGWcdcR/y9md4V/ZfJojo/OfLr/lMea1+Jdf49+RMZB8/9/XlF+JxWUc5hPm9dDWiKLXaV8qXsUL
Ns8hZTxz7fwq0DPKaaqYbrTmUlDZcsKdAFnDoMYSAUzDTWf8ZLhv8K/ibbGy/smfk9+KV/F+Et68nillmqvm13OHcdSvlcmQQhi1LW/bxq8V0CCjqfaxYDCRpDHKqOfDbOxBu1p+K17Fq3gV78p4+xXN9fOriGqk
6XlHCy38KgGKtkRxzRHzW8IKtczX+FfxKl7Fq3i/AW9ezwDHyJ5pGkSOKprvzi9IFqmExqpTWnONlOUdVxwbBNZ+v38Vr+JVvIr30/EyimaVZzwf3TG/Fa/iVbyKV/E+izevZxof+UyvKZqSlI/PWfEqXsWreBXv
N+Ot8cx3+1fxKl7Fq3gV7+54mHmmQd0xRXOf/Fa8ilfxKl7F+yzeMs98v38Vr+JVvIpX8e6Od4aiuVN+K17Fq3gVr+J9Fm+JZ870T7ZEPR8IGcIo6gxnHDdGMQVbywxupaEIzUS1WEpXKL+fhIe5N784XCvOwDua
fjteuB8Ee2tYbyWpP5JIIp8PIsNUoK/xr+JVvHI8YBrVtEcUTZl/pmUYuY5oK5hz0pAOtoy0HXAM4bZhDqMteGf7V/GQ9CaoN8K8hTbrKv79HrzADq/i7432tno/+t9fkdRQb9Qb6e08/5ZTxat4acrzzLn+mfb5
YOjFNH4ZMgxMI0UHTIOkI9J0b6YpS1P/iPPbudXQpwn37+tC++37km+8sC/8nm5x9LYfI835FyOlmQsep1eIzxrjnZlyeAx5E72FvxH1thevJDFLLDIhjupg8LzYsVHnt03TiuEdPSgv/wseHYlfxxL4C0R0f1bw
D1t/jv+Vuhgp58dw9rn5zeNh4y3mmJf1d4K23mbUTWCYnlBY542j56NnGtJbzzfL6saXYSumZT69H/B0Qoks5ySHRCx7lSUyGPCW7sTe8jsvVbxz8UpWBtiCl0umiXiGAcM4J4R+8Yww8LzhdgveNOV4Zg5vnmnG
+3HSe4ReeAzPn5GmHM/E+5+PlIFi1tmajj4vbZ+46Y2H+FastzK+2edfaOEDP/ReFPXd+bOg/GbOC3wS2CnmihzP+Kv7bWhP/R7/7zPStvtBfAg/E9RIyjPe/PvaiG8Cx/Q3h+nenDfeRNbjEeEt71/gh9w9iEs0
d8xwP2JGiX8PVwhctcz4e8tvPVW878HL8cz5/gHTtMgC0xgBFUE4Yh0HYdP1fWcsjNRswZvuyTFN4IUcnwz7A144m2VWUUhTnmcCXo5pltXXnKL59POCnDfReAuRuJbZ5ph/Kc+s+mfCef7M3Ft2QA3t3oCXa99C
G5jXL9P0Zfcj8IbyFtTIlGnA+o7NwDYvhpG96bcBH/V8E/RN6E1bHudZ5pnBv7jcw9Fhf8xDJarn+ShlmrJ0lfa04uXwjimaGE8Q0rSdxlQgpaGuIK0lNbA1/q1SO9YAz+CeZwhoGe2oYNi6TgqCjQ7zAqB+AN8E
fRN608LojWZs5R1zvu32/oUWm7gozxlFk9My8/mdIqVpnWfm7+9831lJOvd5QQ7eTzfxzV7/tiqaoZXy+iPfTsVMMz4vxzPPRynTlKWd9yNlm0jP/DHaW0jhvsjIer4JvWl5hon9W2aaOIUjY90yKMKhf21dEZbx
zP3a04o3n+Z5Zg+egvcmJLtGS6Eck5hihwUnDWyhfmDm/4+RkxIT6RrusII9LZbOSoI74Bv/v17dhN60MHYDeyzhU70z51/KNGFP0Cdxq53yzICXG5eJtyU9Z3/e/yLUI4rme5+XdXVz1L8pz4T++6VU0k69eWbo
DztL0XzofmT55q1rXmzDIwOWgfzKoHXKZ6st8UwyHtrzSjxmFvbkR3je5jnI8/mZiuY67WnFy+EdUTRjPOUoQSIwjbUCE2MFx1haxRlWVnMBW8M5ZvA3wdh3nWH6Ypte3TwfvjcNuEkIQ1qnREdQmJsWZkIvpbTt
9uMLfQ7DiDF+H5VTNOHsWPuMrxDwjo/RDL7m7u9eRfO1z8vW3rQt/s3NBliaCxDel8P7c1nfWdizzDPD+EJZ6RzJ74YUsc1rfB9l+aZP5Qwz9q9c0aQ8E8r1+cjxRjxro3yM5o7tacWbT308mnYcj2YfnrIUv3hG
204YqoBhHNEW3l9EC6zjBCHONaByOmu5JQiYxgGrIMHgByZbShyXCLZANpQ6JQVlrlMt5eG7m2X/YqYJ7X/MOqHtjn99t/9vvGXeWJ519uafN15OuWxTNFd6XubYBtr7g3MFxorG+1c2GyDtw0lRx/1hZyiaD9+P
eEZZ6BULKcM2tIX2fn5u2mLK80zqX67cU2YP6T3XYri//m6fpWiuVD8qXg5vjmn24Sn/zaVwnWeawDddq5VQsNX93wa2SFuhPdvQxvMM7pyWlvKOGMATtqOmnduG7zyXvInb7tDmQ/uSaJP499ys45g94u0cXjpP
LTdbOfXVz+eaz8s+RfPJ52+PulnC2zPrbDpfKqeElhXN+9x0PvXy/OZy/3ammGHC+L6escA9fGprozOpfyWKJp4LMC2ZN16qT9OZ6es8c8/2tOLNp5Rn9uLxDp4dC7oG2EZ1vhdNt5Qh+XxE8wNU4JugbqzhCtt+
BhoJcwXCzLQwE9q0ry1GvfJp3bJ/6VcpM7lNuABd7H7cCS+wDbwfHJ4rEPNM8G/f2gRzqGX9YeWK5iP3Y8IxeePS22S+WfSv8n60HM+M5+stz2/ekt+zFM1160fFixMwjd2jaLb6F9gmqBtrREtsP3bj555pgrTx
/btHvl2Iecb/veTfst6YT3e9v1+Pl1U32lsZ3tYxmjL/tozRhPm2543RHJpv1qfX/OSQ+xk98/rg33jj2tuM0snOPcv1h62P5M/PXN6a3zWe+Tn1o+L5NOWZr/Mv6Ju+N01bzcOnm7ifeyaBafqZ0Fvwzvav4h3D
i/lGcG/ha0FkvX2Hf8P3g2eO8H/1/SDO22vM30X24puENwIzWW+ea56PCd9E9lpX6JB/R1M0HnqKorlP/fjteNj0TIO2KZrt/oXetK7pecbPFdD9zDTrmCQUPx/hy5utqOf5V/HOwMPIm3C9GW+BbUJ7f9bX9tfJ
79l4YQXNsN5czDbD95fZkZcJ38yxDVbejvmXSxWv4i2nMc98pX9h9CYwTboNPWtb8M72r+Kdhxf4RjbegsYJvWlX8e/qeER7i/mm5Nv+fr3NN9/0qwi9tEzr7Tz/9qaK93vx9iiaPf695gr0M9PCTOjw3Y3/zhPe
d2VYV2A77ln+Vbyz8XCf/Fj188Hl/Epb+9I183s2XlA3vietn++4NU5A3weHO29f41/Fq3jlKeaZK/pX8Spexat4Fe/ueNsVzb3zW/EqXsWreBXvs3hvnnk+9sdynkvXzG/Fq3gVr+JVvE/jAdM4P3pbqmjunt+K
V/EqXsWreJ/FG3jm+di+Bs1Sump+K17Fq3gVr+J9Gm+borl/fitexat4Fa/ifRYv8MzzsfWLzeV03fxWvIpX8Spexfs0nv+6pVTR/IT8VryKV/EqXsX7LJ7nGY+3zDSveBeF9nxsO77iVbyKV/Eq3k/FG5imjGd8
fNgzreJVvIpX8SreT8cLPPN8lDLN3fNb8Spexat4Fe/TeKHz7M0nz8f/+Nt/qP/6fDwf/v/2b/9QqGn+9o9/RcRv/+2//es/27/pv/4P9+//7a//5a//0/1n/+ffdPPX//rX/2btP/5Sf/077Pzf3T/+n3/+/T/C
cf/8+1///C/ur3+4f3Xmn84OP/7P4UKjrf5b9w8k/vq//r9//NP9Wzjb/P3f/k39u/3r7//xz3/5+7//Ay7ljyHrXv6/5r//7T/+xfzzv//tf/L//4//+vf/+B9/+89/c/9U3b/8qxN+33/yBvd//BeGeNvv+b//
rv4VS9n0e/t/UEr/ej4avyDhq7iE4Kh5LVDolzsc/m6GQF86inEz7DMN4l0ruGs1Rz70uz+L4Kbzh5rXosbOL5Su/uA1wxnDv9GwVNjrGGeH2+b/HYegUo0j3gtDmj5Mz/D/aUIatenrxbtr1uIz7Pk4B6fiVbyK
V/Eq3hXx5vhjjWnKeOaa+a14Fa/iVbyK92m8HIvkeCbmozvmt+JVvIpX8SreZ/GW9MwRRXPV/Fa8ilfxKl7F+zTeNkUz5qM75rfiVbyKV/Eq3mfxlvTMfkVz3fxWvIpX8Spexfs03qKiMQjFPDPlozvmt+JVvIpX
8SreZ/GW9EzKNGU8c+X8VryKV/EqXsX7NN6iorEIv3km5aM75rfiVbyKV/Eq3mfxlpfGQw6RrYrm2vm9N57pjDXaEK2UkoYrYlQrGuKkEpojITlnSDLBOJZWdNwJy+3zwYww3DAnuRBcqU5x1RhsGu0ASxphG8B1
Fl4rbHut/Fa8ilfxfgbekqLBzZtn5vjojvm9Mx6wDNPGdhKj9vkwUlCEgHgQJ1YpTJGWoqNIEAr/EIpipAX8hBznhCDNGJHYME4ZMQLxhhHNdasskBA1BPx7881g7X4DvANnV7yKV/Fujxe1JctLfeN2aYm7u7TP
PwgPaS1l1ynUCt7QjmKtNFVOwb9wqzvGEDGIOozhb0RAxjwftCOgXliLG42AmISgpEWCYWJIwxw1FMH5DDSO9IwTnhBgHG+6N9EbDwb8xs+0ilfxKt6PwgvtRUh9OxLalEWe+bOU6jwf3aZ9/jF4GjgGeAb4A7Xc
gTppNWak1ZqRrulUg1WjJcK20YIR2rbSYNYQhYFqOt0SDTxEgXlahQhuDaOEY8UJA/+o0B3QinxxTP/MBKLRpLfGm+q8NQ3h3OaeGm4J989LODY2f5Y/e5oYBt7jfq0+JFQnmf+3ZOHIsILf9Pnz15i7Qs4C3vsK
zwfD284YHz8tgbd/sWfLGLlfPfLzUVZOy3nwpR1wng/v1XwKJRzw3mcsHx/u77oHpebze6ZVvO/Ce7UWfcvxYh5oT4CPZp7nd1petPs+7fPPwTNUdV2nMUGGiwYpoAl4V+j5pFEEGKZRgsDfjWOsgfZeor7dQ8A0
jdSYwrbDohGaUYop/NoiL4M6QiURDKilT+E5UdSb7E04b8BHDZfCYngmUCOssIz67djguZEA3y8e6//NZTiqf6KkP8dvvT0f8RlhsVl/PG3Cdfwe9NoTjuQyHI/gCI/TNPGVB7zUcnjBM+9r8InL+Hjg8+SM4Gt6
7XAmlt6zgJxec+xf+nuunHKllM/v8v3IHTm+HyVnLFuZfxXvJ+GF9iK0HS++6f9XwjO5/rX7tM8/Cc8ReN+wVHdMWcIC0wBvwP0wLVV+y3qdyv22Y3CHtaPANl7RAOdgz0aioQIp6eANWXH/vgucxQ0z1AXlG95L
XhzTeOMh0XUjCPQC9WKraVrNoU0miKDpnvEZy8d7vLkzUBd+5xSk2YpPObxW+9/C8+xxULfs09w1n4+Sq5bn2te3sjNK7sfgX8gp6kJO18ssf3wuv3ut4v0cvNBahJYjtCJGgJ6BNuU8RXPt9vm78Zj1tvS3x1s/
Cgz0iECgazraWcotyBXlwxQax+BuMj+pzL+JMt9eAX8Ar2jjg34YwVDTiN0G7y8Hzq54Fa/i/Xy8F9/06ib0poUetBWeYa3Mzxe4Y3v/M/AkJ8IxqQnplEG8tbCjwboVuGklEvAWyn0nTusU7Glcy+Et2OuRgWfi
dOVQ8hWv4lW8e+DleGaYL7B0bmCa3K/3a5+/E2+kSY7hEdFhZQzjDe60EaLRXDvW8kZ2baNa2TWug/srdUM6J4FWOuq5B478o2jCkD+Ioqmlw3sy2PMx/AUmEuO9schoZKQ3HBkCPATWvm3f8z2kq9S3ilfxfife
AUWDEXs+9kY+u2Z7/yPwkLTUWcqAPaSUogVesb77zBpMNUWmpaBi4G/adZpjDWxjgYSIsCnPQHtfyDRlPAN4hUxTxjP3q28Vr+L9Rrx5nvHz18qYpoxnbtE+fyvesqLZhMc1E8RhbhqQLEogya1tuOmk46bl3Eo/
PkOZJRyYxjWie/GNkWyvohnpmRMUzUvPnKZorlPfKl7F+514R8Zono/yvrN7tPc/B09a5YhCRDsisTUdM6qBHRRuLbKd08A7jbHOKeAKQ6lQSLUtHvNMomdGTMMZZxb5iYpGOg2IZI1ngp5x0skOMcWU5YIJ5tBe
RXPH+lbxKt5vxJvjmfA9znljNHdqn78Lb0nR7PKPaiUbgU1LmQKNg5US1gltbefnE3oecZ1WnZMaIwNM47vPTGNKFA2DZGzDGqZ5IxvQM1p5cjDti28yTBMYhjjiTIcFFs6RhjQdiCxuHRnpmeK+s5J0pfpW8Sre
78Tbr2iej/K+s7u09z8Oj2suKJCG4VYrr1w0c41wGhhHwL8d00I3/vM+bSRvuphnZvSM9s+HlQ1vuKZvptGqAY7S1vOGQU45BUwR8UzY83wQRZTRnkAcwQwzZ7DGukPe0Y4IKqhryhXNPetbxat4vxEv5ZlhfYGz
xmhu2T5/HC+vaE7wDxngBRAomCPNQX90TKvWEA4aRCvqXGekAFlhvMxYVDRee1hKCSXG9QzDG9BHjdDSL0GjTeMaZxrSEkAP7BK2hBNuBGKIWYUMgpNxi1vHMMXU6cA5TDBh6UvPnKho5uvH6wt6vbRls2vKTvGW
kXA0WZz3tYm4FK8cI6SwJz1y7N9W1Pl0rfaq4t0Vb6+i8XiYnKdortHe/2I8aoAp3jwD7f0M0zjjTEcZZ9w4Csl0PcPIRjVKgzRqrO5aSAb7L9kNAUqihreudX69V4RBvDDEEcgrBOZ8pAnnMLHEGucYWFeqaI7V
j7gNRlm8wAzxUXGKW/u01Q7r04zZKmWaZYwYYezfMleUoPr13ObP3pfu2v5VvM/gTXnGr09TrGgKeOZy7elF8XKK5tP+lYzRxGzzfHi+sU3fd6b7rWs6AGhBsmBDW95yI1vdauM8YVjkE7ANRdTK0JfmuONdE43P
nKhocvUjZZpcCu0x5yle2FfeXqc8w3nAK8eI/Z5LAW+rZ/l0tfaq4t0Vb5+iCXiYIn6OorlKe//b8Qae6fXMyvzmF98IJkDdMMqAbVzjQv/ZoGta0hLDWmhPgW9UC2as1ze2JYww0y/GCSyyedbZ0fox5ZklvPjY
WB8sqYp5vJRpSnux5vvDcmkd9b7tVcW7J96YZ8J6m8WKZpVnrtqeXg9vXtF8hX/vuzNn276jAT5SYaZZzzdd3wfWhZkBYbxmxDdgRhJIhr4YZvIdzR89c5KiydePckXTREc+HylLlI/zpDwD9W0jxjLPDPndippL
12uvKt5d8fYomgHvLEVznfb+Z+K97rQnAxbfm/Q+DevhlX+xGXimZxjiR1wM8YGMTNvrGhfYBvRM0zYGhd60fq4AnmeaMp45Xj/GPFOCF44d93tN94z9C78sM00eI0aI/StRNGuoW/vr1tKd27+K9xm8mGeG+AFn
KZq7t8+fxJtTNMf9C3fC9DY8L9ZPHeM51ilXNM48H77vrP8uhmLig3JihBH83eDGUE8UhiGBBPwN7SMwEBCGof2W9aMzdNxzFumZUxRNaX/YsqJ5H9nPf4n6o+Ix9zStzzp745VjLPHMO79bUefTFdurindXvO2K
JnqeT1E0V2rvfw7e6+72fBK+ZmFM+qXPYoZJOGdY37tkNoAnB2AViaXpv4qBbcI2Hhr84342s+G94glb4UOFmzAbgMSzAdZ55oz6EbfXw/ywXApv/rlWO51pPPSHpYoipzRys5XDkUN+S2Zkl6CO+/+Op3u3fxXv
M3hvnvHxbM5UNPdsn78LL1U0e/Fe9zVimMAnzwc06o16/ZJlnUVF0/eTUYooMuz5wA57LaOxnuOb0JvmlzWzLW94Y2XPQOyldDzbhC3vg7sS0Eeb5jevpeX6UaJoxrObj9e3Mc/sw8srmmu2LxWv4oW0VdHEeGco
mmu19/fGC+UeesoChwQLHGKi1H/GglLOGeIV5ZhGcMGt7L/YNP1YC0vZJvSlDd9rAn/A/3u+aXjLWyswpEHxxFsfAdmoNZ45p36M+8OOjJdP05J/y2MnZXglYzRb8I6milfxStLAMyE+53mKxvt3l/b5CnjTeJnP
x1okzfTvVMW8GcavbzZKzdQGplniGcUUc1gKKbz+oJjiMd+E3rTcGjQvtkEcAdvAycAwXuP0fW3gHxGtaO1JYzRXrG8xz1zRv4pX8b4Ob5uiGeMdVzRXa+9/Al6sU1Itk+OZoHGG+KvLYzR+iWaHPN8A2/TqJvSm
pWtqPh/pqpovviGcAN+AGdKvA92WjNHcv75VvIr3G/GG+ay74gSwHM+85jfdqn3+XrzxGM1Z880Gznk+POukHBPYJbayWWf++5lOBX0TetN6zbIaJ+AdJUAQQSyTVFJ43Ajg7Yx8Np+uW98qXsX7nXhbFM0UD5hG
HFE012vvfybe605HSmeebZ6PUqYpi7D5R8/siOU8xzM/ob5VvIr3G/GG+aw7Fc0szwz+3b19/iRerGi+1r/XfY9YZ6uiCXpmXyznOZ556ZnTFM2V61vFq3i/E69c0aR4xxTNFdv734X3egJG/WvnKZpIz5yiaH5G
fat4Fe834g3zWc9TNG//rtKe3gHvrWi+uX9tlWcmeuawogG8zWvQLKVr17eKV/F+J16popnDO6JortneV7yzFM1Iz5ygaH5Kfat4Fe934u2P5TzHM7F/V25Pr4Y3KJrv9m+NZxI9c1DR9HrmREVz/fpW8Sreb8Qr
45l5vP2K5rvb04qXw9uqaJyzwnRTnpnomcOKBvB2x3KeS5+ub8urXG7H25oqXsX7brwzFc3Yvyu3p1fDC4rm+/1b5pmxnnHKWNNaITk3+xTNS8+cpmiuWt8GnrmqfxWv4n01XgnP5PD2Kprvb08rXg6vSNEw53wo
TYoR65DD1o55JtEzBxWN1zNnKprP17dtiuYntS8Vr+IFvPMUzdS/K7enFW/elngG2vsX01itGiGNYJKg/WM0f/TMSYpmS/3IraG/tt7/8mqb8YqXPKo74Wr5eJp8sZ7l4gM8H7nzwvWWUeMjx/kt7+ELJZO7zvh+
xFdK18tejoEwlF+KlKbldbmDx3P5Pbpa6V3a++/CW+eZPF5+DRqfrtyefjVea7G0BDVYW+vjncC/LGxZv8X9tvVb5Pqt7rf9Mag/BvXHoP6Ytj+mNda2Fv4mUD9aIkT3NfldUTS01zKMCmQsl4zrlGdm9MwhRRP0
zHmKJjzPy+3echrzT1w/cjy03DaG4/lM/0Hc+qWRysbnTa82h5em0iho7xTjLTNN6lNa3li83nczfoRj4xJd45kYD41+md/fRPtr/IWvwzukaCKeSf37/vZ+GU8brbWSbamF48v8Aybx/IBJ6wQCaum3qt+yfov9
FnX91vgt8JHo/0X7bX9e6/ptf17LYdu0wEZCESvl15Rfnmd6PaMd0lJJI4FplLVKSrpX0UR65hRFs61+rPPMEl7a/oe2dklh9OOhi+/LaVsb2td5/fT2Lz2vRNFM3+D3tC85nvEee7wxo7yvF+8PZ69HZHj7t0/R
TH2d5rfGX/havDWeWcLbo2iuoz8Cezg8tudjuudt4YwS7DfPAJ5ACBtHz1E0kF9SxjTemoZSyXJ3SDJK/f0tYxpvthUSHGyYgBz5VTqbGT2zeQ2aJZ4Z9MxZimau/2WrookR5vpfcscut2L81X8Q99SVRLBJj4l5
Jl9/97WsY7wc06R9jrnyHsqvXFMtl+UQL3WdacYpVxrf3T7/HLxzFM2cf9/DH+V480xTxjNr/o0UTd9zZhUjhDjOHFHpFvgo+lc41lAJdQoEDGzD35JSrGgJz/j+e00tphTuU38ngCAyPMQ5ft0tTXM8E/RMzzSU
ccs4I9oJw3WqZ0Y8Y1vmGTTZQvllftmnaLbWjzWeKcFLx3nyR8b9ObmUMkaeZ2L/lpkml8Yt6772JW27wx6G0/zmSnx5nGzoi4z9O0PRpPk9pmju095/F94yzyzjbVc019Ezf3jGOAv22kJ7H/1rut2uaOD99A/T
BA7pPAGg5e2LbXqG6ZA2A9tI0B+lTFNiHO6vZyPPM56NNOUrsZyNYh3R1glC/YwALtsZPTNWNARKTsG1PDM1vMXCYS6xdi3XWDrE4bKOcCDyOZ5565lzFM18/8vyNm3nx/E5h7bVb5dH59d55o0X0lLf2ZCWes5K
+/9K0xQvZZrwd/Ag+B2OmecZj7es2uLSDWmpLN/9decomu9vn38O3hmKZt6/7+GPcryYaRRnmOjcdsozHm852uU2RQN8pM5UNOXrm3lF41VP81I98zwz6BlQNA0oGuFaoRkymnPKisZoerYxHTPYAdug58OXCKeY
wBYKGPYJLPYrmu31Y1nRrOHlxvxz4w2Q3+h65XMFcnMBBv+WZwMsz2iLsfe2L3HbPddfF64R/z43G+C9P02DfymP5soyxyfx/rn8HlE0d2rvvwtviWeej72Rz3z6Lv4otcAbr69DhvVVon+l262K5vmImabpFGpx
42HI6haODHwSuCVsn4/yvrNgXq94PsGz7Q3U39ed8lomnLGiaDohWecaYRk1HW+IdNRgzUZ6ZoZpoDCEB6QOeV3DMBAvV9iCrumAfZHAZIZnYj1zhqLJ9b+Uj9GM2+5cfcvNb44ZI1VOKIuXm/u7Nrs54KVnh9Z5
WcfNpdS/uPWO9Uuc4l/H5Z27H8t6Ml+Wuflmqa9pmuOZK7TPPwfvuKLJ+fc9/FGOlzJNGc+U+JcqmsAhbaNxS8fb52O6LxwbZjEHVhltV2Y3B/9ijok1y7Lfczzz1jOddq2WSlkmWgosIQzDRjBBsJPGGTwzRgNC
RnKjqUQcuMWXhPLxXLECjlEEOcQlMA0RXtzsVDR76scSz9yr/u5N4/6/fSn+KiU/fy3lkG2zL65ZfhVvW8rzjNczK0xDtyiaa+mZlGf69VVOVDTg35RpNimaY/kNjOLvA6X+X5SW4a1+R9M5YwjjhFgnFEMgVSjV
xvX9f9QYDlcyjltqjQQGaoE9MMbWMIe55eAUnMcJKBrGJAYGYgJ7jSMInfIM3I/dsZznUv77wa1jNHN4x9On8bb2Fc3hxUyzPDcu5Zm7l1/F24Z3QNH0PJP373v4oxxv33c0Zf7NKJrGtZ1Jt/384tapZTzKFaMK
Y2iI/X2Bu7OW31jRhHGY9NgwM83POsPZWWexnhlWBnDEIM2M4g0xwDecOiuBK6Q1XMMeCypFWs0h98AnCriFM4Npr2gAD1jJX09KK4BRnHHSNtxQtk/R3K2+VbyK9xvxcjwT9Mx5iuZqeuZr8Xx/eynTLPOMkFoK
1cD9UKTveWtb2kpJW1fuzdzXNPHz4kdo8Ot+la/e7KghmhvGNBGWPR+8o55dOkqAdRhhfoIF6BTNOfyO/TwA0C+GUDgPaTr6jqZ12k3GaHo9c6KiuUp9q3gV73fiHVM0z8f+WM5f397vw4vnkO3FK1U00J5mmWbg
mBfDhLEb+Js3quPoa8pvyjMTPTMX+Yz4VWmsVlaC5OOOtcaKhmHjeMeQbQRoGtdorvrvNQEv/8Vm4ySctEnR3K++VbyK9xvx5nkG3p+L+85yv57Z/p3dnn49XnnfWcozfximaXFgGLi//ehN6EH7yvzui7D5Z77Z
jljOcysDvPTMaYrmOvWt4lW834l3RNFAe7pjVc1Ptvd7zsormnK8eFVN+JtaEvhkvPXfx/v/G2LNqLUPTOOk7mcPmJ5h5DrDHC+/Mc8kemZDLOc5non0zOZYzqXP85FU8SpexfsavDme8XrmTEVzDf64G56k2krG
iDLPB8uO/Z/t3x5FM9EzhxUN4O2O5TyXrlTfKl7F+514+xXN87FtfvNn2ufjeDlFcxX/vhIv5pkZPXNI0Yz0zAmK5p71reJVvN+Il/JM0DPnKZortqcVL2fbFU2iZw4qml7PnKhorlXfKl7F+514exWNxztT0Vyn
fZ5XNNfxbwce6q1dtzfP+PlwZyoawNsdy3mOZ+5a3ypexfuNeFOeeT62frGZ+/UHtM93xuu5xRBvw/Ix3p6P8P+cLSsaxsGEYcZZFHhmRs8cUjQvPXOaorlafat4Fe934u1TNAHvPEVzmfYZzyuaK/lXhte1SjIC
W2AH2BomO6QcM9HWJlsz8EyvZ+Yin/nIPIK3fkUB0SimlTOu65o1nun1zImK5r71reJVvN+IN+YZr2c2KRqxzDP3a59/Ch5wi2A+BsLIno/pnqmVjNEoao1zfkkA0EeCNKKjWHHjFD+qaP7omZMUzfXqW8WreL8T
b4+iGfDWmeZu7bO3VNFcy78yvA70BnV91LYNFp6Gl57JMo0TwARMcItANTUGsQa3EuH2xTYJz7z0zGmK5nj9yK8vX7KqZrpqcXzkgBenXHSv3Nqe43Tn9qXiVTyfYp4JeuY8RXPH9vmn4AHPYCrHAzCgZ5YHaMDK
Z50Z6uNPGyqwbQVe4Zsinon0zCmKZql+7IlH089/WTwv8EnKFfM84/HSqGb70xXbl4pX8ULarmjeeOcomiu1z96miuYz/i1H7Fz6exrvMxgwTUvJOrOkPAPvGxvmNxvimCFLbAP8sXkNmiWeOaN+xHzh1wsqTcux
lQMqlF8B05Sv0n/v9qXiVTyf3jzj41Ftjny2wDNX44/fhZfyTIme2aJo+vg9f+Y3r/BNAc+M9MwJima5fmxXNAFvOcJ9Li7xHM/E/XVnpGu2LxWv4oW0VdHEeMtMc8f22dtYHXzKv6U1o/fgvfrONqagZ7avqpln
m+ej5xtmrGJnKJpz6sebETxeuaJZ55l3f9jyeaWK5u7tS8WreD4NPOP1zJmKxvv3ifa54s0b8AxnTffHQC80JVaqaP7omZkvNrPqhhqj6DzPAN6OVTXzaa1+bI2wOeCV9J2V8MzQX3eWorlq+1LxKl5I2xTNGO+4
orla++wt1haf82+fosnjTZmmzIKe2ato4tnNgW0AL8c3uxTNWfVjYISAV65oYnZIR/CxyPWH7VU0929fKl7F82mYz7orTkCWZ4J/n2ifK968Ac9oJoZWGvRCW2ZlPBPpmZU1aFbUzYtnej1zoqJZrx/bxmimeDFL
5LZxinkGNXH/WsnZ6+m67UvFq3ghbVE0U7yjiuZ67bO38XyuT/m3R9Es4XWtbjl6tdqkwOB4eN9AZymaP/PNAt9gRw0e8Q0HvuFGwGVkqaI5r36M54eVK5rl9Hzk+s7SVKJofkL7UvEqnk/DfNYzFc3g3yfa54o3
bx3SnNswHjJZnz9nGM5YWetsRs9siBNgkCMGCWnhP02N9tcD654P09nGtmcpmpL6sWWMpry+lY3RxP11Z4zRXLl9qXgVL6RyRZPiHVM0V2yfvQ3a4rP+bVc0y3gd0VYMLX+qQ1Lz68k4Ic9TNG89M/6OxmrXWt1n
lxljrOk823C/6mdnbZ5n7lDfyhVNGd6ZqeJVvO/DG+aznqdo3v59on2uePPWUUMl89vnI/y/bLvOMxM9symW89tc480/bpBfIaxEtiGGtqY9qmiuXd8qXsX7nXilimYO74iiuWb77C1oi0/7t1XRfJV/ZymakZ7J
rgwAj5t2oLxE57BwwDY8xzM/pb5VvIr3O/H2x3Ke45nYv0+0zxXvXLw1nkn0zE5FM8xsBrzdsZznn+etNaDiVbyK9/V4ZTwzjwdMszMezXe3p0sW9Myer/SP+LdN0WzM72qETcBLYmweUTQTPXN4rTM/P3tbDVhO
P6f+VryKdw+8Q4pmwjNj/z7RPle8jPXc8nykMTaPRNic0TOHFM1Lz5ymaO5Q3ypexfuNeCU8k8Pbq2gu3D5jry28njlT0ZT4t0XRlOBtibD5fKQxNo8omkTPHFQ04XvTLTVgOf2k+lvxKt498M5TNFP/PtE+V7x5
8xE2gS+TGJtHImxCe7/xi81lnvmjZ05SNPeobxWv4v1GvHWeyePtUzRXbp8D3t6VlI/4V37NMrzyCJvPRxpj84iimdEzhxTNsH7Olqd6Kf2s+lvxKt498A4oGhrzTOrfJ9rnijdvfn3MNMbmkXg0vZ7JMo02Wmmh
WmmlkBieIuqkE4671nbWKAL7G9VIIlo4Dik20jOnKJq71LeKV/F+I94azyzhjZlmmu7YPufiVX69f6VRNd/z4XJHBSuNsDmNh7ZP0SjkwwOATvHrYzaO+W8xPeeITjrJhXEd8E7jlHVGSik0R6WK5r0e6LbnOpe+
u75VvIr3O/HOUTRz/n2ifa54Obz9sZzneOalZ15M42w/otNvX0xDQM108LvseEecAy3DrLPEUWtM1yEnLAcGIraVBoQOH/QMPG7EWEcdtt0RRXOf+lbxKt5vxFvmmWW87Yrm+u2z356naMr9K7tmOV5ZhE3QM0mM
zXVFo7FSSsPz0ZpWcYUVsi1Qju5MPz5DgE86KwyDE5ih2urWtZYb2VHQNMJIbeAsIhl3misurNRAQ7OKJo5vsPXJnkvv5zmsSsYX36TCr7kVntfW+0/j1SxHsxnjpb+Xp3H80NSzXNy2XPQDnv2eLqwTmivFXDzS
93U8XlyyZ+PlchSvSReX9HStuml+Y7z0iQie5WLnDf6dme6Ed4aimffvE+1zxcvh7Yt8Ns8zf/SMBv3hpQy3rUVd1x9j+7F+CrzQaKpbZQ0yjbauAbbxW2e1kcA3/qmikrvOEf99aIcdtwj+hYwyWBPpmQtpsUfR
bK8fyzwzXu8/bVdy7VRI4ci4NR/8i1uitLVf/nXsX+6XcN4yV03Zw+Mtc2BATUsrxwuDf+vMUMYze/Fyxz8fuXJaXhU1d53x85IyUPzGUpLuxB+laYlnno8tswGm6Z7ts7ezFM0W/0quuQWvhGfm4jsvKxqrLbUM
/oc17kJSfgYZMIvRCvQRd8Sh8INFtgFOQgBkwh4nHHMYni4mecectrJnG6qU7ISB7CM4MuKZcby27c/2NMX1Y5lpwv64NUrbL4a31rc4DvRcLIGAl2vVl9Mc9y37F7e/yxGqQxrikcbt8jEFEvDOUzQpXgnj5nkm
Lb8c05RF+L5Ce/99eMcVTc6/T7TPFS+HN46xeSTC5lvPDH1noGqY4cAjyignHXYYeIZr2vkRG66EosrzizX+SGOkwtJJEdjGtM8HHE2dArXTeg2juGlhz+5ZZ3vqR45n/P53f1OuXdnWuxWNh0bnhWunqPHf8xHZ
5vO7j58GvFwbHqf0mHleePt3jqLZjzfP6fP3I6Q9ima9/LZFj7gXf5SmPM94PXOmorlH++ztHEWzzb/1a27DW4+w+YqfPIqxuRZh01qvaFQnnWqs8tFkLDNAEnCw8M8L/NoC/wh4cugoorOFY0SvcUzoTbMU9rVW
wh4MPKSE0UJjFSka8G93LOe5NK4fOaaZRl3O88wQnzO3jd9vU6RwhbAd4n3G3oS/y0dqYg0W0pb2oIRnBv/WmWYNFb3wyvvO9uLFqCVjaTEjzJXf1j66GHXw76x0Df4oxzugaIjnmbx/n2ifK14OL46xeSTC5kjP
aIM1Au0hnHOdH9kHpmgNNsQwDanXOBJ4hk14ptc1oS/t+QijN9YrIv8VZ+No1zpprXKKSrlV0eyrHynPzPVv7GtXwv6hzQ94aQuKIqRwbFlfVi6/KdOUpbi/bq3vzG/Xes5i/85QNEfw5tJofPoERVNSflsUzd34
ozTleCbomRKmyf16z/bZ2xmKZqt/a9fcircWYXNmfUyyHmFTC4UU7Vz/K+3ZhlrfRWafD9WoxrXwAHHFVCP9Ic7Hz/RbP8tMta++M9zPFQCechgwOfCJgav7eWid/BOPptczJyqaaf1ImSZtxXLt17h/LU1p+5Vr
h96jxNP5UiWz4uI07Tnb1h6szwV49w/FKdYK6XlLcynmy+9svICRMlN8nflZHh4vN18jLYfl8lt7Xvakq/BHOd4xRfN87I/lfEZ7WvFyeOVRNZcibI71DCgapzvTaquUspoA65D+yxmhtX9mtNVNP5dZ+NnMwCgI
WAY0Thi78TMFQM+0muhGGTgLuw5wmEKaaQxnS///bYpmb/2I2/F8f8nym3I6My2ezTr2L/0lpJKWazy/aTlHZW/1Obz1+c3jFHsfWuVxf2J8Xsn877Px0js0xls+I3d/8/cjV37xdjndjz9K0zzPwPtpcd9Z7td7
ts/ejiua7f4tX/Nz5Ve+MoBhmmsJuoT085WJaQ32CwWAsrFe3Riqje5Hb/wXN8BBWrfKKd21oIQ0KBrtpPbH6nRlgJeeOU3RpPUjZprtPTLXqb/jNIx+p/Ov4rRVLV03v/fAwyLgnadorp3febwjiub52Bv57Lvb
04o3b2OemeqZMdNoDnxCOuYZwSLgEeewpZYDgzDHgIeMNsAwTPveNWpJv96mH5Ux/co11m818pS1d62z/fUjfVudw9vS9z+Xvqs9KHmzHr4P/Q7/fhte6RjNT8nvXJrjGa9nzlQ012tPl/GOKpo9/i1d83B+JxE2
3/E0UytXNJpKJZ3vE+vXA2CeH7RWShmLjTQKGKXt156RVllkPPNI3eoWNJBwrxWdlfDrCnhecnSkZ3bHcp5LV6pvFe834m2b37yOdw7OZ/H2Kxoovw2zAb6mfa54WbyeXY5E2JzRM+NVNYnnAi29rtEWOAMkDbCI
Jxup9Ot7TuoXEtBEMcX79TY712nh+UZphYBj/ArPfJ+iuWd9q3gV7zfipTwT9Mx5iuZm7TM+qmj2+Ze/5j68fITNPp7mJMbmkQibwB+TiDTGaGcaI0HBaOP82A3wUKfbsng0vZ45UdFcq75VvIr3O/H2KhqPB0zD
zlI09+Oja+P5GJtHImxCe787lvNc3LN+fGZnLOc5nrlrfat4Fe834k155vnYNL95lWfu1j57O6Jo9vqXu+ZevFyEzXE8zdS2KppUz5THcp7jmZeeOU3RXK2+VbyK9zvx9imagHeeorkjH10b7xUnYGc8ml7PnKho
XvPNTlM0961vFa/i/Ua8Mc94PXOmorlf++xtv6LZ7998vMxpvM+Sv4PNxz2bxtPcEst5jmf69QVOVDR/9MxJiuZ69a3iVbzfibdH0Qx4Zymae/LRtfGORNh86ZnTFM1Lz5ymaO5c3ypexfuNeDHPBD1znqK5Y/vs
ba+iOeLf3DWP4M1F2EzjaaZpi6J5rZd2mqKJ9MwpiuaK9a3iVbzfibdd0bzxzlE0d+Wja+Ptj7AJ7xub5jdH85o7IVhjCKMInh/GcWMUAz6C/1tmcGuVbBg+qmjuXd8qXsX7jXhvnnk+dqyqucAz92yfve1TNMf8
S695DC/lmbl4mlsjbM7omTHTtAwj168czZyThnSwZQR4Av7mtmEOoxzPjPTMCYrmmvWt4lW834m3VdHEeGcomvvy0bXx9kbY9Hpmt6JpGXrxDHdCYuAZCXgdMA2SjoDiWWKaMp65e32reBXvN+INPOP1zJmKxvt3
x/bZ2x5Fc9S/6TWP4k0jbCbxNFMriLA5o2fGTNNETAM0R5wTQr94RhjHLG7neab370RFs1Y/SlYwfkeL8XjpqprLa1ema9DHxw/rX+V+L4+tGdLzsRydMk7LEQXG8SrLI1KmaZzf8siX8Xm5dNX2tOLl0jZFM8Y7
rmjuqheuj7cvwmbQM7sVTcNaZIFnjGDAM47470M5SJuu7ztjYaTmiKI5q34MPJPDS1d3no+PNWWEgBeOzcXNSiM9538tz28Zz7y+f8swTT5f7yNjv9fWv8+tfr0Wf6E8fstaun/7/FPwhvmsOyOfZXgm+HfH9tnb
dkVz3L/xNY/jjSNszsTTTK0gwqbBvKNOg39UIKUZVUhrSQ1sDXXIaMcaYBrcMw0BLaMdFQxb10lBsNFMDfMCgroJfWkWnpf+/4Q7os5QNOv1Y1nRxLG35uJf7oub/I6z6fHSdjRG3RItJuDlmCbg5fhkPlel7Uup
opmW3zIrriua67anFS+XtiiaKR7GxxTNffXC9fH2RNh8PtIYm2NTHaVIdo2WQjkmMcUOC04a2CLM+i1yUmIiXeP1EVawr8XSWUlwB3zj/9erm9CbFsZuYA+QzEvvLPDMefUjtJDwfpW0dWkrnLbIuXf+1fHQ6Lxw
5RQ1/nuuvymXcm13HNvzz/dvGabZ2mu3tv59rvxyvg7+lfSdlfl3FKHinZWG+ay7FE2GZwb/7tg+e9uqaM7wL77md/LbCs84SpD//rJnGmsFJsYKjrG0ijOsrOYCtoZzyJDmBIOYgT30xTZB3XAhgZmEMKR1SnQE
+e97/Nw0PxcaN8cVTUn9yCmaONrm0N7F/WHNa9/6NtY74xY34IVrhG3qTRxlei3FeDFG2PPWZUNa5pkhvyX5KuOZtPyOKZort6cVL5fKFU2Kd0zR3FkvXBSPc6j5e7fwfi+G5yHLNJZiJHqe0bYThipgGEe0NaIF
znGCEOca0DidtYBnCQJiccArSDD4iUm/WgGXCLZAN5Q6JQVlrlMt5eHLmzzPnFk/fAvp8eK2Lm01c2/k87Gf3/7FLXy8J74aipDCkTHe0H9V3juXXiHmqgEv5rXSfOVy5fHOVDTv8jtH0fyM9vmn4A3zWc9TNG//
btM+T2ybotnj31KpHpivN8shPV4x36zwjKGgP5BwnWeawDddq5VQsNX93wa2SFuhPd/QxvMM7pyWlvKOmEbYjpo23vr1KMK/wpeeRxVNWf3IaYi4lR3Pv8qNcqQp7YF6j85M/YtntqVXKBmpGfDi1js9O+a15bkA
Q37TtDzrLDe7Ya5/8oiiuXZ7WvFyqVTRzOFhtF/R3FAvnI4XSj/chZIyW/XvgKIBvAKm0Y4bakDXIATk4vvRdEsZkhr/mR2gAtsAXq9vrOEK234OGglzBcLctDATOnx5E77ztFhSnp11dm79GOZLpS1vnPKzo6Zn
jfubUk2Q259rcYf+tdy10xQjpQppqL/TWQ7r+cp5n85fy52Xm9fMs/0lZyian9I+/xy8/bGc53gm9u/q7b02Wmsl21ILx5/n3xzPHMpvtj/sLEUzO38tmt8c+Caom743zfZjN37umSYozEwbz24GvJ2Rz3LPc9lx
8Tt/rscINfH8sPJx+TP8246XfpWSpuVZ21/rX8X73XgvnumTcN50423MM/N4+xXNFfRHYA+H5+z5mNsbzjjPv/2KJpPfhDe6zhLGukxy1BI4YtS/duQ7mqBufF+a73+xmodPN3E/90wC0/Qzofd8RwN8tDuW81wa
z5faOsYwh3eeb/vwYp5JOXOMt6w3StL357fi3Q1PRCapN028GeFt6eyUZ8b+fQ9/lOMtMU0ZzxzzL+WZg/P1IoZxRvZ40Fp3Vvt9jOV4yBmnAt9gtcwzs9/jREwTetO6RqvXXAHdz0yzjklCcfjuJuaZl545TdHc
ob5VvIr3G/FihlG9aeOt3+hlvL2K5gp65g/PmD6G8Wj7inec/LJX0aT+DRwzZZr47x353TguE9iojxfTs5Fs5CFFE8Zu/PqdnmkC38TbV8/aZkXj9cyZiuYn1d+KV/HugRdalqBiXhzT95qFpmbp/CnPTP37Hv4o
x4uZxg8lEJ3bpjzj56U9H2XRLucYppnhGV9+prf3vk2luHm+2atnDfl+tKB6lngG2vu1vjPLNe3npiERZkKHL2/Cd54GcUftm2f+6JmTFM096lvFq3i/ES+0LKGfzITUNzK29baMt0/RXEPPDDzzek+Ptn17OtkX
tvsUzeBfzCvDntJUmN+UT1zgE6dkMzNII/zGzzfzWub4GE0wKL/dsZzneCbomfMUzc+qvxWv4t0DL7QsubZrCWHMM6l/38Mf5Xg5pinjmXL/8iUY95j5+X/zv0wHyop4xoX5Zi+OiTTL3llnf/h3lWnKeCbSM6co
mrvUt4pX8X4j3hrPLOHtUTRX0TM5nunHu09SNO/70UV9kHFvWdgvkv1N9u/F72Hj8RcaeKbrNHCLEjrDMNP+taOKBspvdyznOZ4Z9MxZiua761vFq3i/E+8cRTPn3/fwRzneke9o1vybY4+UW95/+/JLf2mSv9/c
s8wz/nvJt6J5z2Oemw3gZ52FmWnDrLOl5+WcVPEqXsX7TXjLPLOMt13RXEfPfC3ee3w/p1nm+WZN78T9azPXXR7zn0neP/jVaReYZjzbfbsN3/+eZRWv4lW8n4SXbzFLeGaej76/vd+Ht77W2TpeYIbQmud5Y9gz
zP/bwjozV925vtn6tuJVvC/Hu2x7UPE+gVfGNGU8c4f8nov3Zokp35Qx0Hg74GWvuLFuD+ubnbWteBXvAN4F62/F+xReCc/k+tfumF9va4pmK17MFVON4/8e+sNSjilQMbG9au3W9c3WthWv4n0A77LtQcX7BF4J
05TxzD3y+9V4+VkC89tN/m2q25foL6l4FW+Vaa5Ufyve1+Ct80x+vsAd8+ttWdF8v39Z6+vrzfpLKl7FW+SZC9e3inci3iLTkHJFc5f8VryKV/EqXsX7LN4azzwf+2M5XzG/18PT1G+htBvONeUc1/k5FW9i/smw
2FdW/3T4p+Ra/lW8ireGd46iuU9+r4pHqWQWUzqUrP/XlfyreN+Hl/LMtfyreBVvzZZ55vnYH8s5tuEb/efjSLTLI/kNq1cr3Jv2pqW3q9yPWNd4lqH0GN7Z/lW878Tbq2jumt+K9/PwzlA06/5ti0Hm41/uj3Y5
NqaZfj6Ypq03xr1x6S2E52HEm6G9WW9770fTeFWSKy3PHTlu9ngx0/j+s3CsHvFNUDkeLSif6f0Y+GnqX+iVi49Nr5Dz3mP284f6o3It3rb9S89LOKN/+mZKcV7xTfGW8jLkZKksQ37fbJ/LXYyRlui71N/zaeKj
4ju+fG+mZTKdn7P0bOXL+J2f52ONuZaZblreb/9iz5Yxcr965Ofs936+nlAan7G3fhy1irdu6f2In5ctswGWLLDGfPzk0miX+fxK601Jb5p7U01vzBuR3lifuOgZhlBGGVIYntBWoAY1HHPCQb8p7i3EhCvPXagj
/tnGozZwfD9CbcxxSOg5C+WKX6U7rYtD/1o6klPSEqY66T0fxOOmrVXw0NflgOe9X+ITeF4yv5S/i8fHB/4dnxFa71wJLefEl987L+Vlme4J5RraU48zvd5yuccME5+bvx+5UswhzT1/5c+LL5Hg8Zjp5u7vkWdn
7F+ulHOlGK4cPwnb68eyXaF9/jl4S0xTxjMl/uWjXebiX5YrGhSM9ea8YYU11q1DBBHfXvnuMtIQSyySmGHWYm9I+C0c5y/U7wnXVMabbXo77X7kn/Xn63umd43N1d4y7OejtJ3PMWQ+v2comuXyK2kT3vMmmmbQ
g2V5KSlLX35zTBPeAfSLV5aUZ/5+lN+VPNNtxdvyvMTad1nT5ct7X/9fPteez7dooC35PcPu1d5/F16eZfr7e6Ki8eMz+6NdpvEtfX7Dv3BIpreeMhBHFFEs/ZYS1KKWuZa3XChPHrqBPY2VtCGdwSCfDKJt93y0
nSACkmq96d5CfLgz7sf73Xfc91PyBj3GS3vCQtr2JufxlvupQorfGZf4xOOdqWj8+3PujFyZLeUktFfvvJSXZYrtfxv6E8ccU5Lr+Tb6fX/Dv/3Zvp1fKvfc8XPP37J/sXoIKWbRuft79NmZ9teV1oPc8W+88vqx
pf4etd+Ol31I/B3E6zxT5l95DLIh/la5osHcG/WkAgKGONKxFhlkDPfLiT4fRjWoaYz2PhsRPMcSC0tJS2APnM0IxxRToft5CCE0S98HF0KSlt2PXJ97WufGeOP382nvfdriLbfaa/0R5b8O7Z9vEcOb7VrfWcn+
teelJI9z/WsleSnJyZx/8bGS+WP9vZzrz8n7d+SuHMMr8y+e9aj7nMUzU8pZ4E9/dnGJL+d6rr+upJzK6sdxq3hllmOR0P9cwjQlNsw32xvtcjm/WBNEWmZ6CypHAIe0BvXcghvWEEMa3UhjgYGU9azUWEEk4dbS
ljZ+voDXN5JKIwdeQZEt5i7mhUGxeP/Wem+W+6DH850D3nJffdwjHvav9dcNz8B8T13KgOM+pDcD+vkC7zGm8S/bZm2v9Zcs5yufE/++O5eXkrKca9FC/1rz2je9d8st3tzIyvL9iMu95D5t6Z/07zWeOadvNeHO
BdSQX023lPjSs+PH96dnpE/KFmYK/WFb60fertI+/xy8HIv84Rm1xDOl/pUqmnf8y3JFQx0YEdgb971fIE8YZdRI7N+HWqtIg53VpCPWeR4yjoIEah3nhKMOc8O1bJhjTlhgmpk31LX7scwYOcOv+pvr6c/pmnje
QJzG/TnL+qpk1pmv8wPeHHPhvpclPiN4mfZcvL1ff162jdHM91/N52WO6aZlOT8/bFmv9TXllcdpqU/nhx2ZdTb0J9K+RS3J3XoZv/FSjNi/dIbXfHm/87vcR5zmIaTpuNB8f+zyk1JWP0rKad3u195/F156P+Ln
ZZ1pSv07Eu1yLb/CCA3/haDCRFCwxgcWtph1zHUNMIlyneCCdVgSiTsulRSdUY10XaeMAn7T0v8ihMfYWobpG2q+/yW0xO+zvvb+bukfOmLn4a31lyzPOvsa/76m/+9ryq8MLx1fyY1fhPL+0x5sLPer5LfifT9e
jkVKeOZ6+TW+60sqpiDZ7vmQTtqu0wzkjN/SzmmhgYT81hl4qyS2061uNOnnSKNlRVPi3/LXNOP6/PXlt29e5+f8S215jHn8nnzV7yXL+v++pvxKbCjj4N+yHorV+hrPXK89qHhXwZtrDd/69xxFs+TferTLPfk1
1HgZgySWWHO/GoBuFAJz/bc1XsWYMKsM2Ed6PWP8OdQ2pjObFc2Z96PiXQ9vbb7Ud/tX8Sre9fFyLNLzDEI0PxfgwvklAc/onjea9fH8D/tX8Spexat4vwhvSc+sMc0Z/m1XNNcqv4pX8Spexat4a3griiY7u/m9
/tW98lvxKl7Fq3gV77N4S3pmmWnKeGbNv62K5mrlV/EqXsWreBVvDW+fogl8dMf8VryKV/EqXsX7LN6SnjmuaNb926Zorld+Fa/iVbyKV/HW8PYomoGP7pjf78IzzijDtFFKqudDM2kEUk441ikpFNMayZa3WkvB
uWkVEuTe+a14Fa/iVbzBlvTMUUVT4t8WRXOl8pNcK6W5UFpSThSVDTfPhxKSSqwJEIcywBe2NZ2xwC6wX2mhmdXwO8daSsaZtlJy2AkI1CDpuDFMtdwZobBf1+BK+a14Fa/iVbz9eNsVzZuP7pjfs/BYo4ww1OsR
SY2iglGtGoGplJ1oKZeaOyGBf1hQKf44EDREoedDNIYCo3RGwnnIYDivgb8JbK3isMcpJcQW/0piSgZbj0Lo1ztMr1JyhbX4BstW+v39G2/5jFKPPd5562mF+Ftb12JYWvdsuj7X8h0Maekb/nvWt4p3b7z3s5nq
mWOKpsy/ckVzrfJjRGPZMh82rWFIWWGfDyaUg33oxUBCSEFAsDjQKUj4xaMbjqwBruGmA30jbQvnaeAW0DovLeOAZ7BttFBtmX+5uJ359de2RiHMrc8b1i8ui8BZdj9yZy/Hfcx57NeT3h8zNL2CL79p5JaSuI9l
z19aynNrPC/d92vVj4pX8caWY5Ecz8R8dMf8noUnuAZWABlDJALR0kjgTM2lYEZDe8GBQ4BXOgltlfXaR8Fv0GD08UNbI63UUgrrOYkD32h/GjAT8+vmiMY2hmm37NcQ7crfjzje1djKV+mfW59ra9TK7fE0184O
eYyjPgb+yJ2x3eM0nuayT2vMtIyXu4853hriL+TuYCibLas337W+Vbx74y3pmSOKptS/UkVzZvn5K4L+SGJ2bvlbN0ZoB7oGdAoT2rd/GP7PJeVYa6lNazrNqJWq7yezPdMwzljLqTCEMDgY9A9oH+AZJehriw3R
k3iLOdsWIWwar3JfZMm594347X2/ovH53RP3MRf1Maz/PJ/KPZ4rvyOx5Oae5+N4Qb+Fo85YW7ns+at4FW8LXrY6NnM8M+ajO+b3XDzFDdacMim5pQ5YxTEnqVIM5Irk1PrZYwprozgwkhPd80FArAiDFWuEwL7h
hGMkFdoio82GmWZr6+nHR5W/kY/zezxq5Zb7kZ6dRn0Memt73Mecx/n+ur3ldyTa5TG8EnVz9/pW8e6KN8cfS0xTxjPl/pUpmnPLL+iZrWtGz5ngiiiNCLT3PsqnAr3SCqMsEEuniEHwTm7kK6qOoNJCO6BFoyhx
HP6FO8b9nGb4RW/P7xZFk/aHpeflohDOjdEE/9aiKE7HFfIW8LbHfcxFffTj8XviPuaiPr6/T94ekTif35IztuPlxtS22HXbq4p3V7wtimbKR3fM77l4zCmhOWG85U5oJXWnGm2tEJ1uTceI8DEKtEbQQjjp46tx
jmSrW9oJpBhhrJOSNNRyrZy3ct/W5ku9jyqfNeXvby7eZ0nUymkMRf8+njt22df5qI9hPD54syXuY87jaX9dadzHXKnP9/8t38elMRqPtzUW9lxc5/LneZtVvIpXanP8kWeaMp7Z4l+Jojm//PZEwZn1Hivi23tg
DaEtKBluO8UMsloSTSzinXRahmMFAkUjuZTQDjDQN0oSwbToSMu0H73xtiW/5YpmrX9te/mddSfGeFvjPr6e0dezeIf4oXm88llnqfIc8JbnqV0rvxXvt+HlWCTlmZSP7pjfc/F4CyqGcyI7jYQcKxrbSKw68+IZ
rvz8IY2ZgOMMFdwqTAhtoXFwpCWEYW/l3pXNb9ryfv3d9yPmmbk3+BhvS9zHq+Y3trnvaEJ9yynM3GyO3PHXym/F+214S3pmn6LZ5t+6tviK8jtL0Qjr9YzuGJWd8ttWOi5AuSCuVKstaBWsXkzDNEdcUEodEyCD
EFUkmPTGibevym/Fq3gVr+J9J96CoBnFPZvjozvm91w8zQw3mhHfg8aUEv6DGMU1Yxx4puVUgYYZ8LT0Rn3IaEP028Ke8OvV81vxKl7Fq3h78EqZpoxntvq3pi2+pvzOUjQDXuAboYE2Ou6U09r3oAF9GNvYNj0r
sMoct1z/eal4Fa/iVbyteCs88+o5m+ejO+a34lW8ilfxKt6n8cqYpoxntvu3rC2+qvzOUjR3uL8Vr+JVvIr33XgrPENblZ8vcMf8VryKV/EqXsX7NF4J05TxzB7/lrTF15XfOYrG40nkjWlvBnsLY/uvEf5gqjfR
Wzi0nwZAo+Q/o3k+Xp/TvOy8/J5dfhWv4lW8irfl6HWeyc8XuGN+z8J7MYx5WyAX1rxNd96ejxzfUPE2FqyAZ35G+VW8ilfxfhPeWYpmn395bfGV5Xdc0QzrpY2YRniLmca03gLfpGwz5hkfz4aN+Oa8/J5dfhWv
4lW8irfF1njm+dgfy/mK+T0LL3DVywLPKG9xz5nvSXs+YJvhmxlFE9kW//ZH2EzXr5vGRCm/Qtn6aznbHp9zT4RNn9/1qKBrV3ivFTctv+X113L2XhngvT7cgDf/pf9SDId4VbcQz+Y8+yn1t+J9Gm/mMf2Tyr+j
2etfTlt8bfkdVzTDemmxmZB6vgnq5kU4/dhNyjbxGA3gyd5WmWZsuQibQ/zLdOWrfRE2z4hXuXZ/j0TY9HjrUUHLPR78W46RUx5hc+153hphc4x3JLJpmX8Vr+Idw1vkGcDbH8v5mvk9C4+53iKeeUkT0hsO9nz0
/28ja7zxzhsLJhPL8kzs3xBj80iEzRjv6+NVrp2di885jrF5JMJmen+PxaPx+d0X+Wx8FwfeiuOHlt3B5Wv+nPpW8e6Ot8w0ZTyz3795bfHV5bcvqub7717PuMgSdROP3bxMJ6YGAzyV8s1yntbWq18+aluEzXPi
Va7d3/0RNqfxL99+7fN4qfz29LXt7/8rwzuqaO7UXlW8e+Jlq2Oov+RMRXOF/J6FN+KZ3qzpTfcmvQGe6C2QD+0tnI96a72ZztuLcxZ5Znt/yXI7Oe5vKjk7/nV7vMplm4vPmcbYPBJhcxivWI4Keqz8jkTY3Iu3
1v93llW8ircfb4lpynjmiH9ziubry+/YGE3Ae/V7xUwTUsI3a2wDeMA3b30z8M2yF2X9JeVtcT7C5lnxKtfu794Im3H80MHnIx7H/qU9V9sVyPLzfAbeMUVzr/aq4t0TL88yff2liJ+laK6R37PwWBdZ4Jmutz9s
A3gb+Gbam8bUmn9H3nXD+P7c3d8fYdPj5eJV7omw6fVRet7+CJv+eV6PCloeYfPdX7f1rsT27h30fJ7OLtg/RvOz6lvFuztenmnguWVIrH1Hc8y/VFt8ovyOKJoBb8Q0vbnG25Rv1tjmD14yerPsR1l/yZ3mI+2L
sDmMH109fuiylc86G8+Hi0trXzncrb2qePfEy7FI+D4AmIaXr0Fzh/yehccbbyOeQb292AbwNvFNOldgzb8jiub7yy/na2gx/XzvpXf47RE2r5ff2PTrfWMcY9OnfMTMaclt6a/77vxWvN+Hl2ORvsav9pwd9W+q
LT5TfvsVTTQfqXnbi2lwbyO+WWObfr5A7046N+28/J5dfhWv4lW8irfFlvRM+fzm++T3LLyYZ4I52lvPNs/HNr6xIp0Jfa38VryKV/Eq3n68RUWzsjLAcf/G2uJT5bdX0Yzmc7W9RUyjHVNNozWDEtOCcT/GwChs
MSOwbRhqGmX98LRStIOtn79r4f+EmqZJv7w5L79nl1/Fq3gVr+JtsSU9A0zTbo3lfPX8noX34pmIbUzLgC882/jy28I3nm3S7zyvld+KV/EqXsXbj7eoaJolnjnDv1hbfK789imae97filfxKl7F+268JT2zxjR3
zG/Fq3gVr+JVvE/j7VU0no+Oe/XWFl+S3/5bSIklEh3VlNIWOywxxhoTZLDALdLYYI4RUYSShmkmGDXGL678Xfej4l0Vb9s3SffPb8WreOfhLemZM8Zovie/2vp1+DFCCiHMkUOEtPB/SyxBWBAOh2CsgEf58+H3
I0wxkdgRA79z0gHvkLDo/6fvR8W7Kl7gmfB96N6vX++U34pX8c7EW1Q0WZ55f09XZtDua61km7PnY7onnLE1n1JKLolf/wpJ1AKXtIgRP3tOEQFqhhJHgGGASQj8BmwDcseButG0JawPGwN7GKKWTlbpv+/9rXhn
4W1RND8hvxWv4p2Ht6RntkQ+W/MvsMfrm8YCC8dvzy9HzDLh+aLtsASeAf2CXAvMAZoGSAZphDFFBmHPNf79FJRM92IgiXjbtUx20srNHDf4tz/a5bR0/XpkR6Jd7l//6oz4jSVebon3uRwXLWBMv6P3+U0jIsRH
xSu95I55Xz/c3/lSya8imi/j4N+elZ7n13bz92PPc5G7gl9vLvzyjik6Tul6c0tPdehvn4/huseu155WvJzNVJk/KcczQ3tQ7sEyzzwfpUyzZoKIhhvgD4E6RJFDHCFuqMONkgI4hRHqqAA66hAHfmGooxw4hlBG
DPH6zba0j7M8Wju57H7kol2mq1YNePuiXc7FWzwS7XLueVk+O7TdubVfUi+H/KZelpfA3Hr6cZu2zONp6xbflbn4oWkulte9nru/y1YeUXTA2/pc5J6KfP/fvoii4/Xmtj7Vc89f+bNaYhXv+/Hm+GOdacp4Jvbv
xTTGWbCC7RzPlORXYdVIyyTtoH4BjyApOoEY1VYoQq0CkwJxyRvZQfvChYOq1DEGTGNB0xBkgZjsttGZIdZlWB94b7TLtw01Ml7/fnu0yyPrX5W0CSG+/dyq++Ve5u9vjmn6p7LRL14JazjPrwa2Fu9zeySaI3hz
ZZzD2xtR1Jffnuci92uIH7onMtu2/O61K7anFS9nORbJ88ybj8p9iHlGcYaJfm+fj/hfRKdMUxL5MpjmGt6vNJFEGC9cmKB+XgDX2CgNVNP1yRLbGidbIbijlhKiw1wAqimhSa7OmY+UX19+W7TL9IZF39e+7sqW
aJfzz8uRqGpTL5P+2MjLPSXwjve5vOJkSQsZ9MccK6aRskviwIX7m3/bWPZvPqLoML8zjil6JKLoUn/dnoii83gl9zT//J1pFe8KePn2oH9GDyiasX+BNzoNpkq2qaIpzG+Y0cwkEo4hKogD1WIFNgL2W4NAqRDH
nXDy+YD9QiDQPQ4x3jLD+L6ZZmXzkbbHg1w+e1S6BZEjtzwvJTwz1792xMuhP6zEJ8lCXLT5/py8f+V5nCu/s97t8/4diSg6V35HIooOeEdikObjVxy3incvvOyL0MAzkygBMR+Ve5HnmeejlGm259dQQwzhhIO6
oR1nwhJDHRdaGGobIQUTrbIKxM6x+7Hl/T/tD8v1+s9Fu0z74oN/e6Nd5vJ7JAbB2Mu4/HJelpRAvvya19lTvlnOwzCy4t8PxhFfcmW9XKJD3sL7xvsKZU9NPqJomG8xjilaOkYzV96h/yqXi+0RRdP+sK1P9dzz
d55VvGvgzfHHhGl2KZqpf0cVzZ78Gu3licKaGaEobDlTAknJuXDPhyJaaKl3rcY/trL5Q0vRLue/Z9of7XI+XmXu2HJfx/cjbce2evkugWE+1ziVcNJ47MafEfTl3FyyFLV01tm0PzGNxllSruPyS/H2RxSdn++4
P6Loe77jPh03farf7UtJhJ2y8jvTKt5X46XP2Tul39GM+ajcj9x3NOn3M8e+oxnnV2PgEqu54ZZoZaSFp18pbVjDW9GCsJFCbsHLWfn7/12+9zsy6+xr/NtefmX9f19TfuU56uvZqz6l4xcDXjziUVLuZ/hX8Sre
eXhz/LHENGU8c438am0QsEvnhHOWusZJqYBnBAN+Y5x1xH/L2R33rmw+zZ2+91v7jmY5/uXX+Le9/I7M8D5WfmV4cSkv66G1iKLf/bxUvIq3ZjkWmeOZ9Hu6a+dXCeU0VUw3WnMpqGw54U6ArGFQY4kAnuGmM36a
27f4V/HKbfv3jffOb8WreD8Jb0nP7FU0359fzx3GUb9WJkMKYdS2vG0bv1ZAg4zXH9pHg8FEksYo43vVPupfxat4Fa/i/Sa8ckWT8tHV86uIaqTpeUcLLfwaAYq2RHHNEfNbwjJa5jP+VbyKV/Eq3m/AW9Izvo8C
ka2K5mr5BcEildBYdUprrtHzoSzvuOLYILAdM6ivnd+KV/EqXsW7Gt6iool4Zo6P7pjfilfxKl7Fq3ifxitlmrK0jLc9VbyKV/EqXsX7yXhvnrmmfxWv4lW8ilfx7o6Hum2K5u75rXgVr+JVvIr3WbyBZ67qX8Wr
eBWv4lW8u+NtUzT3z2/Fq3gVr+JVvM/iBZ75Wv9kSxRChjCKOsMZx41RTMHWMoNbaShCM1Et8nhn+1fx+qXnVKNb3M6swLgdb2uqeJMkGsFIYxrDdYPAdCFef2xrWytUC8Znoj6f4l/Fq3gb8bYomn3+mZZh5Dqi
rWDOSUM62DLSdn69TUO4bZjDaA/yOf5VPMQxx4a3YT03hIigpsENa4pY5+v9+0V4nmE6KHmmeePf/6RWbdM2Eq3wTf+r36gWCyycIw1pOo5a1Apxon+jVPEqXmnyPPN8bJvfvJam/gHToBfT+GXIMDCNFB0wDZKO
SNOt8cxafonz27nV0KcJi4An+hqbXjTsCb+mWyzeR4a/w/45/2Kk9DrB4/QK4cjBv7NS6fNCuXCqYUwTLXDDOwKiE8N/e/HK/YtLc3kbSi5OaVkO5Rf/EqfwpKRIOS8+U3/hxatjGrjdr+H8YhrPM17XaNtC8osr
JWwDewBPt6Y10kJt7hzBDDNn/MLmHfIfOEBV8+pmsdcgfl6H8ku3bPGbvBRpDi+uRbk7sZyu3J5WvFwq/45mr3+miXiGAcM4J4Qm8P7cM40wjlnc7sP2aeCZEv/itgRl9g81IcYLx8b1LD4jTXM8E/CWGSiukWvp
C54X24pWc26QlKwxiDW4lQjuzSzfnOdf7q6s4S2fF1qxPM+keGlLuCUdux+eIwSnhBLjeobxzzPoGy0bv2CsaVzjTAMCBUn64pvQTyZbKRViiFnll8FwcM9w6ximmDodOMezkFjpH19+LkOKSxSt3I+0FNM6NOaZ
n9GeVrz55OMZbv1iczml/gHTtAjeq7QRDJjGEes4CJuua6UhLIzUbMGbppyiCc/0lE88Xlqfwtklb2xvpIAz71+u3i6rL3/k279z0tbnBUmikRQYSAfPsc1XPM9lTDNN4W5N79nbv9y7QPoeHd+tOf/OTFm8njd8
v5fsKCTT9QwjG9UorRvbWN15XWM8kWBJW9YyKVrgy9bZFmEQLwxxxK1GYK5BDjmHvU5Szfo4z7sEvH/L9yCUePoMz9ehpfLbo2iu3Z5WvFwqVTRLeIIQUP4aU4GUZlQhqB/UwNZQh4x2rAGewT3PENAy2lHBng9s
XScFwUa/ZwYEdRN608LYjWZw9uLbdHhO3/ElI7+S3pZci5a+ha2V31ZFM+CtM00Zz3z187LGN2f69/+39y5LsuPYdmCP3cz/4Yx7IJEAiIdmMt07vJpU9ywneFG3TFmZ2ZWnulomu//eAOEMB50ACD4igozY2Jk8
HnwsAiCxFxcIYtfwTAqv7KfKPHO/1TJNXTroeryxzf0W+MY0Q9+ZGpa26Ztet55pdNeylmnRqlZp6/nEIJ8c23SoMyL0pT0ZZil/NYom3nPsD4vbzFpFGF+/r+JPAS+Ht34OmtckXYtAwj2ACS7vN0uFk+0Wc0Ya
t0ROu/slskJgImzDLJZujXsos0YQ3Du28f8M6ib0pYV3N26NIex+W1I8Kd8d1oRnq9h7+Pb7XDdnmvIy1XOWux5bFU2cvyPSzv6cGdu4+2VHb1ouf9sUTYpn4vIeoWg+qf0GvhFYOLahHXVsYxsb+s/edA1piXbP
awPfDGPMtGmtVzc+tKyQNaPV4hP6NN7PNddg/hSXajfx/TxvResVzfn9KeClUx3PlPGk7QjigWmM4ZhowxnGwkhGsTSKcbfUjGHqfhPspIzTHxx3D75x+gYPvWmOmTjXpLWS9wSFsWlhJHQp+fvU5y/23uF38DTh
zg53c86jvd7xr+WNmSukdYrmiXeMovnY+2W9ulmXv+WxAM/+xNgrpfvOUqhx8nXv8Y5UNO90Pd74RjbEEKP7MDLg8b4m4hvfj+bUje9NYymGWc5fvaIZ8ebXo8wb8zb03P/r+FPAy+GVI5/VJGk6HHjG62nTc91J
xzGWKKO5awbGckKsbZzG6Y1hhiBHK9axCuLUbaCi7YhlArmlI5uus1Lwjtpetvdbx8KXN6UU++7gXWI/HlrN2F9SMxpgnnKjzsb+g7mvy/FJmWfut/19OFO8Y3B88mzj8rejNy2fv22KJq6r8XrE2/crmk9uv+Ft
v1MpovNvXNwjmGmNbgddY/3S6f3Gj37W6NGbNry9WadlxlOF/NX3nZVHYjYPvPi4/aPOruBPAS+danhmCU/6by657Z2iUYOucfJeSS7dUg2/tVsiZbjybNM5PM80uLdKmI71RDfc9J1uU8vwnWfp7OP4ofhd5Pze
jbfmWtO0P6w8qnY+wiY3Wnlaf0coms+8X2rUzdr8LfFM/Xip3DJO4/jEcCXWHp1K73A9Asf0bS8oJphoghFGusONq+TOj1DTFHHkHun8jtp/lNY7nvFLOrydmeiamvzVKxqKy/27udaQa5Op8X/7EuCdEW+/omG9
cztGGqc/HN/I3vejqbajSETjA2Tgm6BujGYSm2EEGgljBcLItDASOnx3o52e8V96eu3TFp955l9SzNN0vNnaZ+d0usb1fR+8vWMFpnjbFE0pf6+o5ZTm90+5Hm9fXjqGEVjo4asYt5yxDeWufXDD/CA0zQbFE5Yc
GdeSwmgAWqtupuMd68Y37y/vOkVzpfYBeK9pmWf25i+wTVA3vi/tfiNmeHvjR58pgsLYtO344/ih3HNTnGp45mtd3/fES7ANE+h+wwz1uH6o+MI7mun3fvX9LDmeGccnHvWO5qDr4bvAlB+lfL8Jhi22jlEUdo1j
zjehN81/+y8Ra1hjxMBA9KF0PNuEJfN9bQ6vgm9qlF24pMfdf6nxf/vTedoH4MV4+xXNFG+egroZetOUUSx8uomHsWfC8cwwEnoN3tH5A7x9eA++EQZxoTqtFGNOhzqdyzDH2Tvr/fNXr2jq8PalxfHyjk+4Gr7Y
dFRCWk3nbBP60gJrjP1rfl/HN60jFY5dGhVPvPRfdbIFb/4Z998aRXPd9gF4PmFU5pn9+Qt9aX0z8Ezvnk91p4axacZSQVxDGr682Yr+2fUHeCERRDhBht5vhhqqtTa692zDekQRIwuzpr5//s6O57+dYZ3w389w
Szvc4SnfhN609Bw0b2zjzDUsd7BjGK9xCPb60v3rx6PRjTMeTNNZ6w/wzo63xDRr8eZJGv/uJjDNfBl61tbgHZ0/wDsOjzBvhnvjRiDTYONU66yb8quU92g8zxicOHno2WZQN743bT5meYYX8427BI5vnOmKWc7W
5a82AR7gTVOZZ47I32OswDAy7X4LY6HDlzfhS88wr8A27M+vP8BL4eGeoI4wyRtDMMaMbXwHd5XyHo0X9E3oTQtvb6oOD9/dMMy4QM4ojOcCvNPgHaForlRewAM8wAM8wPtYvBLPnCF/gAd4gAd4gHd1vP2K5lrl
BTzAAzzAA7yPxcvzzDnyB3iAB3iAB3hXx9uraK5WXsADPMADPMD7WLwcz5wlf4AHeIAHeIB3dbx9iuZ65QU8wAM8wAO8j8VL88x58gd4gAd4gAd4V8crKxpKSna/lbevNcADPMADPMD7Wng5non56LGv2GMuf7uO
BzzAAzzAA7yr4gVJEzPMf/zyh/z7/Xa/+X/NL39K1DS//PkrIn75t3/8+rP9Rf34N/vbP3785x//3f5z+PmLan78lx//1Zg/f8gfv7mVf/nHY5+fv//4+e/2x5/2V6t/WvPjX+yf//Pn738MG/9TOJOD+1fz158B
w//6czjkL6lD3o74F/urO79b2p82HBl+/5k/3Q/5m/khf/31LXN/Dmv+2+9/+5v79883aF+ox8pZuQacx8axbOWM/uv/98fvf/8Z1VJYUcqnw5W/+bMO+Qvl+vF3+z/++ufPv/+vH/1ff7UP9Hipfun/RPzHX/7X
nz/t3571rx95/f2Pn3/9/bc/XRb8fmT5Gv8/+n//8sdf9c///cv/6f/94++///Efv/zzb/an9Bngft0/WYOHH//OWsGGNf/jd/krFqIZ1vo/SMObH+6xpXX31uNmw1yK4W+XEHr+bsYJuVQUv2FcpxvUmlYz2yqE
7rdwFMFN73fVj+ltWv+ffMNrxiPGv9E4qeRjn2H/8Fjlf06mnOyQbxaaNMPEwuO/dck/phl8nN1vR6IBHuABHuAB3lnwUvwRUnp7nK5YXsADPMADPMD7aLwyi5T0zJGK5rr1B3iAB3iAB3hly+mZYxTN+coLeIAH
eIAHeB+Nt0XRjHx0xfICHuABHuAB3sfi5fTMEYrmjOUFPMADPMADvI/GW69oXscLXKu8gAd4gAd4gPexeDk9s1/RnLO8gJc1FFm7bA6vYq96AzzAA7wvgxd7k8G/rFU08/ECF/OngJe24f7Q/f2me2dqMD4Y22MO
b9fxgAd4gHcJvOAtQvI+pI85J6dn9iqa0/pTwMtYuDfCPRNoRpHBGm+yn9r99rpmnwEe4AHetfEe/mLwHQ/uCXwzYZo6nkmNF7iWPwW8tIUHkfst3Cey8yYG43Yws8Xut23HAR7gAd618IK3CJ7jwTbDP0HX5PTM
PkVzXn8KeDkLyjc8lTwYpvHGQupiu9+mf+81wAM8wLs6XvAXwXcEPxJ8Ssw0dTyTHi9wLX/6ffHCfVAy9/yyuM8aAzzAA7zvghc4J6ib0J8W+s+ePJMO0xG80xZF87X889fBC/fD/nTFMDGAB3iA9154tUyTSsE3
lfN3Tn8KeGkLd0N45d+rmcn7bfaKT8yMz4wNRiPrgjk8/y8ZDEeGBmufVns/r20BgAd4gPf+eHU8k8ML3qmEf05/Cng5vCWmqeMZxx+VTFPHMw6vkmnq0tdpv4AHeNfAO1LR5McLnM2fAl7ayjyT0DO7FM1Dzxym
aK7Q3gAP8L4jXg3P5PGCdyrhn9OfAl4Or17RMMqoQX6gohZWWeWY4sEzMz0zYRorrOgRlVQaximnFi3xjNczRyqar9R+AQ/wroF3nKIpjRc4mz8FvLSVeMb5+wfTUJe0aWhDFWtEI5T05KDbB99kFE1gGGKJ1T3m
2PGRtaQhTc+YYcbuVjTXaG+AB3jfEW+ZZ/z8NLmj+8FK6Zz+FPByeGVF4+8PIxrWMNXFPNPoRivjWUMjxx/SSscVEdOENUQSqZUnEEswxdRqrLDqkT9xT3jHO9vMeSbomeMUzddqv4AHeNfAO0rRlMcLnM2fAl7a
8jwz6BnltYfpOtIRbQeOYf4AJfwUNEo3trG6IS1pNQnc8mAYRpjmiCJqJNLIHYodf+DWUtzhzqrAOpRTbrqtimZd+wiTXXCVX3o8WuwVrkHCb0PFPR5j/hexWzHG5NcM71dn+25HvYq/Arxr4i3xTJhvM3d08E4l
/HP6U8DL4ZUVjdVW9x1llGnbuaT7gWFEIxupVGMac7+pvnVJY4II0sRRUqdZa1trWoSdeKGIIWYUcmYbZJG1mBhitLXUWf/KM6OeOUrRjO0j9sK5KZYCL+T2CZ76fsuxQTgi5qo5z4SjYoRp+51jNM3rEfMUozo+
r8hZffpsfwV4V8U7RtEsjRc4mz8FvLTleCbomfEdzSvfmGboO1PD0vruVN22uMW6a1nLtGhVq7T1dGGQT4beb6hDnRGhN80yy/pmzzuate1jiWdivOCRA0vEKayp89cBb840azB8GvNdLu9a1Cv5K8C7Jl6ZZ8b4
Abmjg3cq4Z/TnwJeDq9+1NmDbTjljm1oRx3bWHf/2dCDNuqalrRE04FvZOtMm6BuCCVUDxNxOhbJjjp76pljFM2zfdQomvmesToY+9dyumKe5jyT6l8rpzg3ufRE/Xz/AniAF9IRiqaUv3P6U8BLW5pn3vRM4ovN
MNJs4Jt+6APrw8iA8L5mwjbOtCAu3W+6e3DMId/RrG8fZZ5J4YV95yxRXtKJ3s8xTQ1GnO+xvy6X1qJeyV8B3jXxSjzj49kcqWjO408BL4e3dmaAwDMDwzj+8O9cNPG3jG4HXWMffONMo9CbNowVwDU8E+uZIxRN
3D7qFU0T7Tnt9Qp483f7IYX15Xc00zXz9jvHqFE0I2rOH8xR69IZ/BXgXRVvv6Ip5++c/hTw0pbimUjPJPrOhu9iOkww0QQjjNzvBje681ShKeKIu9/OPzr+cXShu7a/39y/dHg70y31ndXwzJb2UeKZV7xc31n8
zn2eUv1X5dEAJYw4L8/xZrm0DvVa/grwromX55kQn/M4RXMmfwp4ObwaRfNgGEcNjlUEFnr4KsbdL2TON8OYZeakTKvZoHfCkvuAejqMBSDpsQCO3zbMqplPqfFcNYomPPnPvfaIF3v1eDlXOrnRzdPxazmM5RHZ
r/mrz1lNOoe/Aryr4u1VNN5flc53Tn8KeGmb88xEz6ihp6zrUIc0xRZ7LaOwivlmZJvQm+YnnTEta1hjxMA/frxZ0Dqeb8KSDcFdSXp88xLPbGsfeZ6J8crjm+vSHG+bnw8JjfN5FBXNmnQ1fwV418TL8UzQM8cp
mnP5U8DL4S3MDMA4M2L4XlMP71re2MY9P7/xTehNi7/YHPimYS1rDccujXonXlJnWo48M+iZAxVNqT+s5n35El5NKvFMLV7NO5o1eLUJ8ABvH94+RRP8VemM5/SngJe2V56Z6pleSSqpxYILbmmHOzzlm9CblpuB
xrONy1/DEEOOb9zhjmO8ygl9bYS3vDUr39Fcq73tVzTXKi/gAd6Y0jxzv22NfJbe42z+FPByW2re0fgpmi16sM2gbu630JtWM6vmQ90QRhzbONNkmAe6jd/RPPTMYYrmPO0N8ADve+LtUTSjvyqd85z+FPDSNuWZ
Vz0zHXUW1E3oTRs0C1mKR+Pw3uIEcMKJoaITnZFbR51dsb0BHuB9R7wUz3g9c6SiOZ8/BbycbYmw6fhjcyzn1Hc0Dm9zLOdUOlN7AzzA+5542xWNxwveqXTWc/pTwEtbzDMJPVMdyznFM0HPbIvlnOKZa7Y3wAO8
74g355mgZ45TNGf0p4CXs/WKZqZndiqaQc8cqGjO1d4AD/C+J95WRRPwgncqnfec/hTw0vbkGefvq/vOanjG4VX3ndXwzFXbG+AB3nfEe+WZ+217LOd0/s7oTwEvZ2sVTULP7FI0Dz1zmKI5W3sDPMD7nnjbFM2I
F7xT6czn9KeAl7aRZwY9c6CiGfTMgYrmuu0N8ADvO+JNecbrmTWKph+snL8z+lPAy9k6ReP4I8E02mprBZJIqiYsw5plnnnTMwcpmvO1N8ADvO+Jt0XRPPGCdyqd+5z+FPDSFu6Gh55ZrWj8IVb6+csUHr7kbAgj
TKn7zfONu6eMNpbvVzRXbm+AB3jfES/mmaBnjntHE48XOJc/BbycrVE0g56REceomGOeS9UTTrhSA9vYB9skeCbSM4comjO2N8ADvO+Jt17RxHjBO5Xwz+lPAS9tQc+sGQ0QMQwZZj9rh2XjY9BIi4b5hqVJ8I1L
lm1RNEe0jzDfWJh7bAkvnm1/PofzfHbOcb7/gF6Tj/L80GP+yvOA1keUdvqyiLQ8o+iYpvE+42W57LkIP6n8zbeXo+3M5+W+tn/+KnhPnrnftsdyLuXvjP4U8HJWr2j8/JimsdpHlplwTOuJQdpWt1rqsBxYJ2Yb
OWGbgWcmeuYARVNuHzHTlNPo1wJezAZlfxg8df4MAS+ORJCbbTP2rPPzoMfZ6v1BTSyeMX5oDb/WlT3OX8yvc0Yrb51ej3laGzs1lb8jEuBN01pFM8UL3qmEf05/CnhpC3pmiWkihgmxadqwHBimb1WrHMOEpb7f
3vhGzfhmVDdKK0vreOaY9vHkmVe84NliD5VTNGHPV0/4ilfmh3hrmpM8XtiyPvZyDm9t1Ld5zp5lL77/LfJQOqLca3nn516naK7un78K3sgzXs8cqWhexwucy59+ZTzt37krTZSUUmgmiZat5w9iheSKIS4Yo0hQ
ThkWhvfMcsMM1dxdbmrLiubBMM7uN8cx2t0wDe1oazCWmGqMKXYbB44xU77xbIMZxrrBCjONKKXItF1LjBa4xY3Hc7tI2x2jaJbaR07RzLXFNP5l7JdrZv3P7eOvh/83Zo+cX67pG1vjD2p4JtVfF+dgbdmn+Zvz
K5ptjX/PeX+8HvO0TdGc1T9/Hbx1iuYVL/i2Ev5V/PPXwXM8Q5U2vcCo1YJ3CDniQYwYKXGHlOB9hzjp3B9cdhgp7jYhyxghSAU9k2caxBBThCra2o5zxvt+vox4xjg9E/ENE7S3Yn4EI5TZHgkk5EKEzaPax8gz
8/6c+XN2TtGkfO08fzmPPPfdKYUU91/tf6cy4q31xXP2HUtVvh7zss/PHLaGJeZxf2KMEdfTGkVzff/8VfDG8azbYzmneGY+XuD8/vnL4CGlhOh7iVrOmq7vsJJeL0gr3d+4Vb0TE0SjzmLsfiPihEzXE6c1qFMW
ZZ5pReu4oBWOP4Z/3dK2spXj8sE0/reJ+SbwDG1oo7v43c24jPvXjlA0y+1jrmhijxa89uj9Al5t39k0zflkihennActqwe/3uPV96wt80y6/y/OwbqyP/Hm9R5yEPeWlc+Tr78Yb52iOa9//jp4axTNHC/4thL+
ZfzzF8JTjmUc01DUMktZ1ypMSasUJX3TywbLRgmETaM4JV3bCo1pQyTGzt83/ZY4Ab2Y8IxtrRzYxo83i/nmwTQD62z5jua49jH258TskvN+OUUz71Wa5m/5/UYqpfDKz/D1o85S/WFlX5zrOZuON6sfCZEr+zj+
L9dTFiPFtZEbSVA3nnBtArztaRzPeqSiSY0XuIJ//ip4upN93ytMkGa8Qd7fM+Ku4cAojSSOYxrJifvdWEobJpyqcWuQEzULimby/cyUaQZ1E5hm+IIGe7pQCrukqO8VU4gKKrQInBPzjMPbGPksnWraR+yP5s/R
IY1b68df1YzwHcdL5Zgh9/Yo9q/xcqn/ap6WeCbGS7+xTyHlyx7j5cbX5Uo9z+vYvxZz3DwHMN7sbHj1iiaFFzxbCf86/vlr4VkiTad6Kg2hgWcU7dz10G0n/ZIOV5X5ZU9d21TOX3WsjmkyPPN449LpTuuuc/6g
45p0Lmk8jHtGnHJqyJxp6njmyPYx9jfFvmme5l6s5L+u4w/qxjcv7XOd8gLe5+ON41mPUzTp8QJX8c+fi0cNNfcbNc+/tv42XFGOnK7pnb/vTceMEyySEscxljr/6chHDtff6RokmdM4SlNRwzMveibFNLazmg58
QzvZScc67ubShAsuTBfe4Ez0zMbIZ+lU1z7ibzXKY6em3yOueVLO4e2G2IlX/l5zLO8xo6nPUF7AOwNeraJJ4wWvVsK/or//GniCEW6pUIT0UiPWGreiwarluGkF4r17asUCNa2VfPgewrZMHaFoqKLMUMeXgnam
cyKGOFHFKDaEa67M433OWkXzVdob4AHe98TbHss5xTO58QLX8c+fiRf0zJsq2WOE91hq7fBYg3ulOW8UU5a2rBFOHshW9I3te6Ea4occN03fee5Z4pmZnhmZhrdcJsY6T5bSITdTnhn0zIGK5vztDfAA7zvi1fFM
Di94tRL+Ff39l8BDwnTWKQrHHkII3jpWMb7zzGjcqeFr/sa27nfX94rdb1g5vjGN2KhoHM88YgJQv/TjqYe/EsugftYpGsdHm2M5p9LXab+AB3jXwDtS0eTHC1zGP38y3uQ9yx5jinJyv1nMdONEi+RIMGMapnth
mW4ZM4LTjhrCHNPYhvtxagyrMs8k9Ex1LOdU3LOHnjlM0VyhvQEe4H1HvBqeyeMFr1bCv6a//yp4wkhLJCLKEoGN7qmWjVvRuQuMTG+VY51GG8dHVjrG8GPFtimaKc84/tgcyznFM17PHKlovlL7BTzAuwbecYqm
NF7gWv758/AOUzRj/jolRcP9zMpUOpWDpeTGcmVMz/UwxX+vZG+FwsiPSS72nDl/vzmWc4pn3vTMQYrmGu0N8ADvO+It84zzVxsjnz33uJq//2J4TDHeOepwF1T50cZcUdtwqxzfcHm/6c5SxVVjmOj2K5qEntml
aIKeOU7RfK32C3iAdw28PYqmH6ycvwv750/AO07RJPKHNFOObxRmSDHVUyVbTVivWyU7a3stOMvzzKBnDlQ0kZ45RNFcpb0BHuB9R7wlnvF65khFcw1//33x9ioaxx8rRgMs88yoZ45SNJ/d3gAP8L4n3jHvaJbG
C5zNn54V7yhFszV/OZ556Jks0zQNG6Qti+a6YsMn6DTMvj/MQ0DpsBy+D90yq2bN/XxMArxcKs/wuR6vLgHe1fHKPBP0zHGK5ir+/vvibVM07j5yd4HgHk9ghnRHFWNaMsSM7pnkxBCOuDSSy8A3dTzz1DPHKJrP
b2/Xx6tjmnq8IxPgnRfvCEVTyt85/elZ8Y5RNMv5y12bNM+86ZkS0zDPNI5nEMZSIY6VQhgRrDg2RPvYzdzdXH4vKv39cqSiuVJ7uzpeDc98pfIC3jF4JZ6537bHcp7u8d7+GfCW7XG9qbfxfom3hN+bFY3yeIIZ
JFrcSIE6zKWjCtIoigXhShPMO9N55eN702p4JtYzRyiauH3k5qWfp1w8mhFvbZyAOMVzey7FgyzPhZmKOlDjD+JZmqfRB3J4uZn560u9Jn9rEuCdGW+/oinn7+r++WPxjlA08/yFK6EHe1wV5i1mnbBnimciPVNi
Gj/XDTUt75GRDCFMpEYSa6drcNA1vDWIDfPz+7c3xymaLe2jxDOvePWRz+L0jP1Vyl/s53OzSMfnn8arjPOxdrblZyyedP5yeSormhFvDd8spWv5U8BLpzzPeD1zpKK5kr//KniPazzwSRj/RanwU5+5v++3N46J
WGerohHD84boTMMNkpK05qFrmJ+EAFtFMGVaW8aDF1rmGcdvm2M5p9K0feSYJvjreYzHOc/cb9tiOYeUis+Z885xfLb6lPcHNb1fsdaa4tUcXRP18xz+D/A+Cm+vovH+r3S+K/rnz8Pbr2im/WExxwQ+kUQ28rH+
yToj58x5ZqJnSkzj39Fg3XOFqGxbjrTsUIMd6SAWetEY14oNfOTHph2laLa1jxzPjPEv4yf5HNOEo8vRbBib48U5iNkj552n6/f7gymH5PBypV7imYBXUzd16Wr+FPDSKcczQc8cp2iu5e+vjBfqPfSTPVTKYIFn
9CO56+uSQt4mrFNUNH4maI8+X95v/l/RasMFQsK2GDGJWomMpKgNfMOwZtSUR0KPPDPomQMVzWv7mDNN7PljP5r2uM/+oSWmSe/zyioeL6eQcu9D4uXrUSV/UPN+6jUK5xOvRtEs18xZ/B/gfRTePkUT/F/pjFfx
z+fA2xNVc4zPOVcxU46JUvNqrzzzomdUO0SzYUi3tJfG6SPGjZacMKYbqnmn3Y/WCtlYhB3bkAfbaMc2De21n5+aPUY/E8c6llHtpBBtlepM0zPZ9OsUzdb2Mfe14ff9Fvxo8Nthr9yzfU3P2RivMtYpOU+dWx97
7VR559qonOKy5+svF++5zDMj3lGK5nr+FPDSKc0z99v2WM6pPa7m76+PF6uUOc8EPVPDNFPTynI9sk3r2MYIZYb3M51WmPQdUQ2hREiDNbZS4BY7LkLSLblbYrdk7reTUZSqvrPUz37jYDhrqe6M0l3gmYeeOUzR
zNtH7G2D74xZJ3jWeOvU487Hm5VGA6TWT3lh8r1BNTPl9l/yB+sVTYwX52bObvA9J+Cl8fYomun7gHS6ln/+bLx972hy481i1pkzTOg/e/SiTXjmVc+M72hivnE6xZGEw+0F6qRjG9NhxzYdcTsSRKxbNsS4NS1x
zy8KEcywRlRSR1EUO46x7nBqrKbr39Fsbx+xr32ql1e8eHtqfPNzTXqcb2k8V+5NeY4FxvFmdSORS+l5hlL91Sia15HOz/zN62lLuqI/Bbx0SvGM1zNHKprr+fuviPe43o/xZg/WmfFN/aizJ9vcbw++UQPftA++
8eqGdcizjlu2pHMM0zqG4UrTtqWCtJ1mttHsdSyA47fNsZxTKd/fFPvreZp/MYKyeHvSR+OtVTT32zG8Maar1x/gbcHbrmg8XuzD0unq/vlj8fYomjX5e1z7SOnMeSahZxKjzrS0TMtI3SghB3WjFe6ajjsNo8Ib
nPtt4Jim7YQaOAY5jtkx6mxP+4h5ZlQEObw509Sls/qDkWfqvw+tK/VZywt4Z8Cb80zQM8cpmiv6+++F97gTNn5HM8zXLGK+YY3nFaEd3xBmNWZkWMOd1Glaorl1/+dHNw965kBFc672BniA9z3xtiqagBd7qnQ6
jz+9At52RXNM/p484/z96jgBE7ZpHbcYrrXkrOWyvd9a5jimcxyzOpZzimeu2t4AD/C+I94rz9xv22M5p/P3Ef4Z8I7CW6togp6ZmhbWCZrAN2EZ1tTEo3nomcMUzdnaG+AB3vfE26ZoRrzgnUpnPqc/PSveVkVz
VP5Gnhn0zMZYzqm4Zw5vcyznFM9ct70BHuB9R7wpz3g9c6SieY4XeF//DHhH4a1TNI4/NsdyTvHMm545SNGcr70BHuB9T7wtiuaJ1w9WSuf0p2fF26ZojstfuBseeuYwRfPQM4cpmiu3N8ADvO+IF/NM0DPHKZp4
vMD7+mfAOwpvjaIZ9MyBiibSM4comjO2N8ADvO+Jt17RxHjBO5Xwz+lPAS9tQc+sjxNQ4hnHH9V9ZzU8c+32BniA9x3xnjxzv22P5VzK3xn96UfhtQYLQ1CDlTFuKYYlHZZ4WLZ+ieywHPZBwz7I7eO/x0bDXmjY
qx32arXxF8QawlvCeX90eesVzUPPHKZoJnrmAEVzzvYGeID3PfHWKpopXvBOJfwz+PuSKa2UkqLN2f32uiYcUYPtmMSzAyat5chRi1/eb1gOf9Fhif0S9cNSD0s+LLthORzX2mE5HNUyt2xax0ZcEiPE0fUX9Eye
aShzxjXV1qA6nhn0zIGK5urtDfAA7zvijTzj9cyRiuaZv8/hj3q8wB4W11rYvy5/E6ZBWNuuVtE4PLOgaB5Ms2xN07nrK2juKgradaVYzk8zvgY4a1Xny8sbSZW02vZ9s1fROD7aHMu5fP8dkwAP8ABvD946RfOK
l2ea6R4fzx+1VuaZ+62WaRZ5Zug5c/mTlBBiGbVElpdhT90J7mqRS7cMv0XXYdkFnlkqL2OqM9jzCB6uhKBpHhKUMTxc35q+M9kZbS2liihOGt67/DBtJZvzzEPPHKZort/eAA/wviPeOJ51eyznFM/Mxwt8NH/U
4z2YRlvjrGKZ4plc/uZMEzik9wSA8kt3Pdy/D74ZOKZHSo98EzPNEfUX2MhfRrwQjybwjOXD+xTKmUHSCSWNqNNmwnfvBb5ZrWgGPXOgolluH/OZmXPLVPyA+dzP8fyc5dhl0/zl8rEunde/AB7ghbRG0czxckzz
usfH80etxTwjGcVEPZf3W/wXUXOmKUe+fOUZ3x92pKLx8ZP311pQNF71+Ou7Ik5AZ5nuODYtx2m2edMzByma49pH8O9j/Mv6OZlz0TZDcs8H7Lk9TrURnV/xqjNWlQAP8D4LbxzPeqSiSY0X+Gj+qMcLvPHwohXL
uaLJ52+uaJpeohY3Hobklq7+xr/cvkG5BHaJl/WK5n7zisVfJ5yMQoIf10l1jNXwzNt4s8A3xFJNSnyzxDMPPXOYoqlpH2XGyOOV4zfXRGMe8eJ5+PelM/sXwAO8kOoVTQovzTTzPT6eP2otzzNDPJYqpqnjmfvt
wTSOQ9pG4bYrL8OeYRRzYJXJsnV6a3F8c8wwXrM02Tc1Y/2tjxMwzKOZYBunt558c4CiObJ9TONV1iuanDLxyePVMc3znCWe+Rr+BfAAz6dxPOtxiiY9XuCj+aMeb6+iKeVvi6K536K/3L57yuoZxefPX4eu8393
XfmIZZ6Z6pnp+OasuqHaSJrmGYe3MfJZOtW1j3pFM8UrMU0dz4x4Rymac/sXwAO8kGoVTRoveKcS/mfxR63lvqOZfz+z7zsa//3lwDSNbXudWprWLqB2TNJOYix6zO43d33cVVooXaRo4lHMsYWxAP79Aq4cDVCe
GSCwjXt+mfNNp7XstimaY9sH5gGvdjTAmPI9ZwHvOEXzVfwL4AFewNseyznFM7nxAh/NH+fASyiaBZ7J4XGhBJdO45Ch361tu1aIrrVr8hfe+ueupX9Ds8wzMz2T/WIzq24C28R65kBFU9s+ahXNK17MD/N3+Ms8
88Q7RtGc378AHuD5VMczObzRg+XTGfz9Nrzt0S5He/LM/VbLNK/2wjDh3Q3x/WuskT1DR9fffkUzHW9WxTeLPOPwNsdyTqX7bc1ogNcUc0RYjuPXciOUY0UzP3q+/Dr+BfAALx7PeoyiyY8X2Ov/jvanH4O3VtFM
8d44pmlxPD4g9KC9T3nLPJPQM1VznWlsO40nbMMc2/j+P+5OJI5SNPXto45n1ra3nKJJ4R2haK7gXwAP8Hyq4Zk8XvBOJfwz+PttePsVzTinpnt+Vn7mGNwZEhgltdTE6InPDzxjhRpGD+iBYURX6F87ov6OUDTR
9zOT72g0skQjLoz7X3VaKcasM3ci4+ogzzNezxypaF7Hh9W/o8njhXTMO5qv5F8AD/Ae70MPUzSl8QJ7/d/R/vQ6eKJTRlBKpKYLb/6PyF+JZx7jvTcomnh0s1G2NcqTuMsf1Vob3Xu2Yb2yqjdmu6L5/PZWVjSf
nz/AA7zPwlvmGecPNsdyTvHMVfz9fkVzrfIG269oEnom8cWmbbwNNxznRiDTEN21up3zTNAzxymar9V+AQ/wroF3lKIpjxc4mz8FvLTleWbQMwcomnF0cxhv5m43ZQ0XvLeYW8c3bKuiuUp7AzzA+454Szzj9Uye
afrBSumc/rQG7xhFc6LyosHaqYXr+7S9isbxx+ZYzql3NKOeOUrRfHZ7AzzA+554xyiapfECF/bP18Yb2EUTbw+ysCXL8cxDzxymaB7fz2yK5Vy+n49JgAd4gHckXplnxufd3NHBm5XwL+qf8TGK5rPL27dSUOKW
ijK31FT0SFqqx+X95v41w1+P5T5FM+iZAxXNU88co2g+v70BHuB9T7wjFE0pf1f0z18Hz7ELpz4KQqWleeZNzxykaBze5ljOS/fzEQnwAA/wjsUr8YyfT+tIRXMd/+xtv6L5/PL2jaSdHaK2Jex+m6/bo2geeuYw
RRPrmSMUzRnaG+AB3vfE269oyvm7on/+OniOaXAniq9lJpbimUjPHKJoBj1zoKK5VnsDPMD7jnh5nhnmBz5Q0VzJP3vbq2i25K8UsfN+y8fyzOXY8UzbkTSnOD1TyTTLPKO0kveb4rIVRnCB3X3UWWG5ZbY1vdGS
uPWNbAThrZIKyQqecXy0OZZzKp2jvQEe4H1PvL2KZox3Utrnvf0z4OXwSkxTxzMTPZNlGol8gACnU0jfWOq/xPSMw3thBePa9o51GiuN1cLHn+aKoaMUzdXaG+AB3nfEy/FM0DPHKZpr+Wdv+xTNtvzlz7kN79Fz
lkhOzyRTjaKxZhg5MCwfPEPuN6dmereH6FlPHBCz1FhDbGe07ntkuWGOg4hphXZChwWGcbcb0cZ2Fpt+yjODnjlQ0ZylvQEe4H1PvH2KJvi/0hk/wj8DXg7PMQ2jj+9qa+yVZ170zINpFJZSKnd/tLqVTGKJTOtI
R7ljuGMZYnrDNXW7U90po1rbGqZF3w3zU3MtlHZHEUGZVUwyboRyNLRJ0WxtH2FWsjDXZR4vbM/N8Vye7z+cYYpXjmZT3prKXy6VZwyl2fnWcyWa11NIYZbQeGuq/uazksbniev1aLx8PIe4huK6Ls9WNz/PNH8h
Z7l5WWtm6r4ef9SmNM+459PNsZxTe1zNP3vbo2i25i93zq14OZ5x/FHJNFNz+sNLGX9XoL4f9jD+Xf/w/SXqG9WpVhqNdKOMbRzf+KU1SgvHOJ6iOsFs73VNjy0zyP1GWmqsiPC8hRQPPPPQM4cpmnn7yDFNvDX2
FWiyNeCVGWMehzP2NzQRLzC/vTaFo7gKeDm2mrNHmePoY7zPvLbmzBCnPC/E9Vdmmn14uSPGevLLFM/k/GmO0cpRJxiL83dEOg9/1OPtUTSj/yud8yP8M+Dl8BzTKMpjf122Kc/M9IyTJ6Yz1P2DFe5Dkn4EmWMW
raRlllgUVhtkGsdJyAHpsMbHs7bUYnd3UcF6apURA990Uoqea0exyO27QtFsbx9pnnnihS2xP5r7r2UueM1fHAk6F0sgbE372lJ5c8/ouTSN95mPUf1Mc+xXXnjN315FsxfvNcez99M7FU1t/S3FKcrlb286E16K
Z7yeOVLRXM8/e9uuaLbnL33O7Xh9q1qGHr6bjOb4g+Ss5h2NUzXU3RmN0yLSCuvyZ7HjGaa63r+zYZLLTnqGMdrvq7WQWFjBA9/o1u3bWem0Tus1jGTDmqjnzOVvcyznVEq1j5yimT+bzv3XtP+lPsVHhTNP+19i
T7Q29mfMT+v9Qc6DN5P8zffapkDut/q+s314OU5vov3nPDNe33nKnWep/mqZpi6diT/q8bYrGo8X/FnprB/hnwEvh9cjxZiZfClZtJhn5nrGKRrjFY3shZWNkT6ajKHa0YTbnbu7pXN3S+N/6W4SYdO4PZyeGVSO
Dr1ppnNrWyPcGux4SHKtuMJyhaLZ0z5SPBP3D82jLs+flMvLsb8ppDlSOENYznMTfk+ZrFzeWpWVxit7ytw+U16Y52+fotmPF6OO/WG5t2khrVE09fVXxzPX5I/aNOeZoGeOUzRX9M/etiqaPflLnXMPXk+U4eN3
lI/xyMl4zG9WVjQaK+S0B7fW9la6m0X4+Z811kRT5dKgcoRjGvrCNIOuCb1p4d2N8YrIf8XZ2K5vrTBGWtkJ8dAzByqadPuY+/a5N0j7L49X9ithfezz50/qAc+v8Xhh3xivpi8rTk+e2eIPSmd74i33naXy9FpL
Hu9IRVPCK6c0z3i8tYpmqf6OVDTn4o96vK2KJuAFf1Y670f4Z8DL4fWd7gStXz55xvn7BNMoLpHsejvwUDfwTWd8F5mRjWxs624fJqlshN/B+uiZfunHmPnxz4++MzyMFXBMZbHDZI5PtLvh/Di0XlTHo9nXPuY8
c7+V4y3n3v3O0zi+KfZgOU+UG9eWyl+2MNEZcj56ntaMh8thx6MXpuVtIrz6+jsaL6wPqPnxYTmk3GiOVP9kuf5qeOaq/FGbXnnmftseyzmdvyv6Z2/bFM2+/M3P+dH1t6BorPLvWIyU0ijiOIcM85uxnivl7xll
VDOMZuZ+PLNjFOR4xmmc8O5mGCvQKqIaqd0x2PYOh0qkqMLuWOH/feiZwxRNrn3EnjznB1I8E+PlRhHPlU5uPbG58Vxrn9Gn46Xqn+pz5xyXufyFFHve+H3IfFzbFC/nkY/GK4/zTu0/x5sfl6vdfP3F6/als/FH
Pd42RTPiBe9UOvNH+GfAOwpv5JlBzyzMQaOpYko4XeK/nCG61dhPE+CUzaBudKe0ery70e395jhIqVZaqfrWKSHlFI2yQvm91fqZAfa2j5hnxv6rtX3/pfRZ/iA3Ti5OY/9QvfpZTtf1fx+Bt6xovlZ5U+nBM0Pi
7vmKW27dU6mzIxTNc7zAufxpDd4WRbM3f6/nPLS8yKDhfXxbsvq5zhST7vpK0lPPCQY5HrEWm84wxyDUUsdDWmmnf6jyvWudIYP2YUM/meiNXyrkCevJM2965iBFk28f86fVeVr6Pm9/ei+88rek9cx5lfKeHe+o
dzRXKW8q8chE500Rb+5J1FmaZ554wYeVzv0R/hnwsts2Rdh86JklpumEFDb0nDm2ceyglJRSG6yFlm5tO8w8I4yfDwBpzzxCtap1Gsg9zoQ5nSX38wp4XrJdvaK5cnsDvO+Ht8Qzn52/j8CLGcY9n3be1DBgdVio
sqIJX5OX83dJ/4y3KJr9+Zuecz/eNMKmu76zGJs7ImyS8P2+ErKRRBnHGU7SOBbxdCOkenzP2fmpBBSRVPoRZr3tFfdsI5VEjmH8/M5sVDSRnjlE0ZyxvQEe4H1PvOBZgop5MMzQZxZcTXgizuMFf1bC/wj/DHg5
2xJh837bHsvZm3tEsbrRwukX5SCH8c+Oh3rVro/lnOKZa7c3wAO874gXeMb3kjl/wHVIgWNCr32CaZ4peLNy/q7on72tVTRH5C8+5xF4cYTNVDzNPRE2377H2RDLOcUzEz1zgKI5Z3sDPMD7nnjBs5T9VR5vvv01
fYR/BrycrY+w6fXMPkUz5RjHH5tjOad45urtDfAA7zvijTxT9le5o/NbX8cLXMs/e1unaI7J3/OcHq8mkmZthM10PM3tETaj+QUOUTTD/GsHKpqztjfAA7zvibdO0bzivW6fp4/wz4CXs7URNoOeWTlZZCFdv30A
HuAB3v40jmct+6vc0bmt8/EC1/LP3tYomqPyN57zKLwxwmYunmYuwuaSjXx0lAEe4AHed8Ar+6s8v02357noff0z4OVsXYTN13hoYXxAwAiS5zFCZH4mxpwMCkvb+aUf2ny/KWqY5H753J5bWi3c/dLzvjfKMNGI
2VZ//8Xb4yN6pKxo+jgNkXH80TRz/uF74kwOHnhzDBtKZ6U/v6sT+szR/TbNs1tPKC3nqVQGdz0eKa7F5XrKbX0t77YrsYTXc2WxtNrKUFIsJ/ucqn0A3rnw1ima1HiBa5XXW72iOS5/4ZzH4QWOyMfTLFuOZ5L5
i31J7Iv9jAB9zpd5b2SUw5v7ox3+MOCtQZrg9YPPD/7dl1ml8II3fdAAD1yQ98jT5db8vSdeXPY3fsuVK1xf5K9vloOj6/6Sv9139fX9KeClLadn9ima85b36+CtibDp/MvrugfjeAyNvIXR7okzJfzX/ZZ5qo9S
8OR1/jDgbXnyXokXmKaoh56qLSgav6fXM+tysDZ/H4VXU69+PGHEtVHKapkFnvkK7Q3w9uGtUTTp8QLXKq+3WkVzZP6CntkW1zNlPsKm8y+zGJsFCzE5Z8tnn1mmvJt9YG1/Tq0/3I53dP4AL4m3857+Cv4U8NKW
0zNppqnjmTOX9+vg1UfYdHom/MLuCNsz22gbjs6+l4lt5mPO2D8EeCfAO1X7ALxz4dUrmtx4gWuV11udojk2f0HPHKhoiJ+f/zXGZtGIsm7/YZlimGx5N/qsz+sfArxPwtt1R38Nfwp4acuPpx63r1U05y7v18Gr
ja15v03XZd/F5OzFx1yuPwfwPgrvVO0D8M6FV6to8uMFrlVebzWK5vj8bYvr+XH5y27b5HVO058DeB+Hd437GfA+Ba+Waep45vzlBTzAAzzAA7yPxavjmdJ4gWuV19uytniP/B2paGb5C/1hxQibCRvHNIf4nAeX
F/AAD/AAb8Q7UtFcobxfBq8iwqb/HqJow3EL39GcpbyAB3iAd1m8Gp4pjxe4Vnm9LWmL98nfcYom4E1jbC5H2HysD3uORzkE5eeTcXyzepTAB9cf4AEe4F0X7zhFc43yfhW85Qib99tS1M2AsTDXWSJ/TdN1gubu
C0G7LvUU4o9Jjy9hLnWd34Tdcarzf6su7Ju6BdNnKNVfwIvPUK5dv7/Hyx2Rq4E4Z6/nvN+mGLk8vdZTrpZe8cplz9Wlz2/IsR+fuO6Icf8j7udlA7wr4yVupCGFGUp8WhovcK3yeitri/fK31GKZsSLY2xus4Aw
9q/VfL0ZPJD3NDjrafz94n0lY/hxj6gu7Be8lD/KL58W9sePe+rJM8Gn+vI+vbDqwhHY+d0co+XyncILOfN5DXlS3fyIeP+Q1/jM4/UIR3omCPv6Giix23xryEtob3X1tOZ+KZerpubC/p/ffgHvinhlFsltnfPM
Vcr7VfCWImzWxEMLGHU8U5+/uW9KebcYr+6I1/2nfFfOXw7Ps4Lqxvv56dm9P03nqcyy+XN6vCWmWcNMc7xt12bp+q5lpvX3C+B9B7wlninFx7lieb2VtMX75W9PVM1pfM5gayOfTUx68wj3W0fqFU1decOTd9zD
svbZ/rnmfqs7opyrFF6sskKKNVguT00z7U96bR85XVZb6lJ/3Raf/3o/71U0tf11a+4XwPsOeEtMU8cz1ynvV8Er88yinnljmjqemeYv7r+a3xfzvp2l/pd9z/Y1/TnzI8KbkMCGauinCuUJusb703V5Crzl8YIq
mrLrtL9uf6lTeDWWO0O+/rYpms9vH4B3Lrwyi5TjfV6xvN7yiuY983fEO5oYb4yxuSmFsQDOX9X3nXmLGSb1Tnhb/0tePfj7Dyfe/c/fApXzPZ4h4KnOnyOUQg06JuwVuCeg+i2qm+d4+o4mLu8TbaqKAvfOyxAz
XajFVH9dfS0u3S/bMI7or1uTP8D7qnhlFqnjmSuV96vglSJsLsdDWxFhc5K/8lv9nK0ffxWv6Ya/4zvvleOW62+ON+fJJ4v6/M1HwsV481Fnc7xpf928FGMrit8M1fFMuj9xy5UICEeO16u7HusM8K6PV2KR0N9e
wzTXKa+3nLZ43/ztVzRTvHWxnFM84/mojmlGK4/5GvMXfJN/tsdVemNuAcH707XvoMt4TfN8wxJrmdji8QHlEV5nuZ+X8OZvl8rlyu2/tb/uo8sLeGfEK7NIDc9cq7xfBS8fYTMRT3Nu9RE2s/krf02T8+N15V3z
HF2PF3xm+TsQQQOe3ycomjVjibfm76Pwlsb/1R1xnfIC3lnw8izybG9LTHOl8npLa4v3zt9eRfOK94iSuTnC5hCf8yXG5pHl3WNL468+O3+AB3iAtw6vzCLLPHO18n4VvFyEzbd4mnPbFGHzLOUFPMADvOvi5Vhk
xDtK0ZylvN5S2uL987dP0czxerInwqbDO0DFfGT9AR7gAd518fYpmuuV96vg1cXTnC/XzZ15nvICHuAB3nXxcnpma+Szs5fX21xbfET+9iiac9Uf4AEe4AHeOrw9iuaK5QU8wAM8wAO8j8XL6ZkjFc2ZyuvtVVu8
R/5K9XaG8XrxFzH5kciflz/AAzzA+0p42xXNNcv7kXhNw535xBMM8/n5m8+Ccq78AR7gAd7XwEvxRy3TnL28SiulpGjLdr89f4cjjstfmWk+v/5iXVM/o8zH5Q/wAA/wvgbeVkXzHC9w3vIG9rC41sL+x+WvxDPH
lPf5dX56/tNybLCYZ15nqHzmL57fLHWfpPkpnsllzN98FswtkSqf83Plvlo/Op5m+ohy/E0//m9LuXJneM4PVxuBs1yG5/XNzcWdm7N0KV5CbQTOsl3VnwJe2l7v1uf9kt4ep7OXt4Zn7rdaptmSvznT1NfcUnlr
4nDNZzme4sU+KzfbSthn/h4nPx9Zzcyb80iVY3nrI1XWrA/vo7byxjz+5lh/9RE4g+VKlZ/PLReBM1ev4cwBb82sOfMcx8zj+bL0rLKW08/m/wDvo/DKLJLbGo8XOG95H0yjhzkkK5Z5nlmbv5FhUjzDP7D+lp+8
Rx+Tn/8+Z2v8f4y3L1JljHecosnNz5+PwFmOvzno6Q3lym0N8/OvjbawdL+Umav8Bm96zhB/4bg5N6/rTwEvbSn+CCnMulhKZy9vzDOSUUzU6/J+G/+aM01N5MtU/qbs8so0erB4zXvW32usS/98Grasjbr12hP2
vF9yWqfsD5tm2vPyev/Fz+XbFU3tfPpl9fCMvzn2F9dH4Jym11KV+uu2xEU7sv+vDm8dp5/P/wHeR+Hl2kRp63S8wHnLG3ijV85kzTKnaOryF7NKuW5T71O2lXR8n1If7TLYPErXtL8kZo+90X+X42nGW8uRKqd4
RymaVDzNcgTOMguk+utqypWrpRHvKEWzVH/1eEfHc5jm7ygDvM/Hy/u/+fa1vvGzy7vEM/dbLdPU1WGKP177zJZ+x/VaLu9StMtc/a3tL8n5m/F9RfzeIWyp8VCpdxkBrxypch4RM9TZfL1/H19TK685zsffDHpw
TQTOp6VKFfrrQrnqInCWeaEcn7Nc6q14R8dzWGOAdyW8MouktryOFzhveY9RNDV6sI86GeO+srCeT9bHfFTDN2l78sX9tiba5dzjxVvD82nqS878WKe0KkrdLzWjzkqRKvEQTcaXNz4i5HLet1f7Herr+LXlCJzl
+Juh/taVqxR/M1zf1yO2K5r0eMLt72jW9dfVXY8jDfDOgJfyB7Gfm9/7r3uct7zl72ji72fWf0fzyh6h/ubsUv7dzH4/2WapvOVol8HiWJcBb320y/XXY0v038+9X+bvV+YsNeLVR+A8b3ljy406G/tj5/fW2oid
5yov4H0OXplF5utjPrpieY/CK2mWEsPcb0uKZ13thvxtjXb5HvWXGi/1/tdjH96aCJx+6fdIx9+83v289jua2Nb3131+eQHvM/BS/BH7uZzvWvKEZy2vNz9q7H7bE+1y5Jl+SM/+sDlv1KxJrb/C97CAB3iAB3h1
eGUWeV2bGi9wrfIei/dkicA3T8aYr8n3r70uz1tewAM8wAO89ZbijxLT1PHMecvrLeiZfYpmWodxf9hT5bzyTblPLWaYc9cf4AEe4AHeOrwyi0zXpccLXKu8742XUynP/rXt+uWM5QU8wAM8wFuyFH/kmaaOZ85c
3oC3J9rlFcsLeIAHeID3mXj1iiY3XuBa5QU8wAM8wAO8j8XL6Zntiubc5T0f3musyzA/13nyB3ifj1f6MukM+QM8wFuyWkVz3PxcX6v+jsKr+Q77K5UX8NbgbfsG9rrlBbyvh1fLNHU8k8tfXbTL+Tf6R5VXEW/S
4UnsTHlTwts5rseoa7ye2R7t8v3yB3ifiZfnmXPkD/AAb8nqeKY0XqDGXmOQTeONrY12ua68VHnrWm+UeWPCWye9UeJNd4MZb1uvR+nrfF9/26NdvtXiZH6z1PWoi3Y5/+rbl3d7tMtSPMhtcz83zZ74jcsl8eWt
jxxajos2Xo/5VSvXe+mL/Gc8glKtpK5QXfvYOyP38/rW1vhy/19ue31E0a3tY9m+jr//PLzEjfu4Kt5yW5971OVvW1TluvIK400Kb4p5k81g1BsR3uiQXPvgA8eQjnYUST8HWMtRgxqGGWFEMm9aeVtzPbZFu4y3
htY0+tPc3FHlaJfzNjrGn/Fo66NdzqNCpubTL+eg7NFS17cmLk6ufnz91Zalpi59/tLz88f1Oj9brtbH8pbnqZuXIX99a2a8q6/j8X6JY4qWjyjXt/f3y5FSc2eY1+L0fgnnju+F9e2jprbqDfDyVsMz5fECNTaN
den0zI5ol6+GXHmRWyI6mPWGJVZYtRYRRBybSCxJQwwxSGCKaYu9Ie6Xbi9/omFNOKd0+ZNaatMMdtj12Brtsub6bvPzIz+O8RG3R4XMz2+2P5pNqry5WAJ1cTvL7aMc00w9eCVWnoGPauqpbut8/rB98zbX3y91
EUXjeJ/7IqXG+dsS6a22P3HfO66v5O8/D6+Gaep4ppS/5WiX81iXfn7lcHQ52iUOSQ82UAZiqEMdFn7ZEdSiltrWtd+WcenJQzVuXWNE15BeYyegNOravu054S7J1psazAQ74Hq8Rruczxb/jAe5JdrlfO7MUn9E
fO7gQXPp+cTo9cyRiiZdf/Xxtl590qjPa8qS8qyvdfkc/zevp/KMk+kyPMtb9tHhL3+09/P5++GJNz+ifC+m1cNYf3FM0T0RRcPzy7PG1/LGUn9dDVu+XtPX9nGkAV7Jcm3yuXVpvECNxZFhhnhjm6NdpsqLmbfO
04oTMMSSnrZII62ZD3qpZYOaRiufY81DvrHA3HSkJW6NO5YShjvccRX4TQ1ZCL1wekg1+cj1uS/1h5WjXc5jXa6JZ1jTtvN49VEh8/El9yuauv618nnikgS8pZ6c3NkEDXHRcv059fWe70887tk+4NXkrz6iaL4/
cdu9M+1/3lPq9e2jxr6Wv/88vByL9IOV0pr8rY9BFuLF1JQEK4JIS/VgQeVwxyGtRgO34IY2RBPn71UjtHEMJI1npcZwIggzpmu7xrkPp25EJ7QYWQVFtnA9YmaoH6E87YP2/ePbo12G/eNYlzX9deMdUBMVcvQv
cS9SfbTLeZ3k7pdtiuapz+sjXJbrchz/l673uB7m776W+v+2vaNpHkwX1sd45Wh25fobI4qG8s6v3daIooEvc5FS10cUncebqGemfPs4zgCvbGUWKemZbYrG6Zkd0S7T5e2sM8KxN+b7v5xAoR3ttMAYt0aSBluj
SE+M9TykbecEUGsZIwz1mGmmREMttdwIH693oZUmSld44166HsvRLue6Zijv5miX8z3H98nbol3OY116f7U92uXy+KaamiuVZHzfPVpNXZZ03LO/LuSntt5L8Ujn5YpzMI/GWXq2We6fXBdR9Nm/W1vj5Yii8/kT
l0f7lbbWto+aezFff9vt++LNr8d4xUtbn3vU5W/tdzTO/1VHu+SaK/d/PxjhnbOG9aw3mPbU9o1jEnm/2Z4zTnssiMA9E1LwXstG2L6X2n9T49dz7jHWX4+asT+hXYRol89j3vv67nsL+v75y9VT+f3UvBfyXN9L
1vX/vU/91dj8/UrQC6lngW0RRc9VXsD7fLwyi5T0zJaZAd6/vNp3fglJpUumF1aYvlfUyRm/7HqruHIk5JdWu6dKYnrVqkaRYYw08npmvaKZ1mf8bDevv/pn+yPqb/14pH22H2/qA+f1V98zeVz+1oxvWjriveuv
Di+u5TURRcP1OOrtxxnvP8B7L7wyi9TxzPb8pedR3lte3WkvY5DAAisW5gNQjUTO7PB1jVcxOowrc/wjlND+mM40utcViuZK1xfw9uPt1YVXKy/gAd7ReCUWKX3POWWa05WX+KVWA280uff5n5g/wAM8wAO8b4S3
X9HsyV9K0Vyr/gAP8AAP8ACvbHkWGceLHqVozlFewAM8wAM8wPtovL2KZl/+5ormavUHeIAHeIAHeGXLsciId5SiOUt5AQ/wAA/wAO+j8fYpmr35e1U016s/wAM8wAM8wCtbTs9sj+V87vJ+Hp62WmqqtJRCKio0
R9JyS3spuKRKIdGyVinBGdOtRJxcvbyAB3iAB3ij7VE0+/M3VTRXqj/BlJSKcalEx4jsRMO05KITWBFHHFI7vjCt7rVRw3qpuKJGue0MKyEoo8rcb0Iwt9ohdBoJy7SmsmVWc4lZ1QwFH1dewAM8wAO8rZbTM0cq
mjOV9yg82kjNdef1iOi07DjtlGw47oTo7zfedkwoZrlw/EODTvF7OkFDnFppdOf4pNfCHYc0dsc17jdxSyOZW2Ol5HxN/moiHAabzgefuqal6GjpMzz1754vG1PxEmqPKM+/9Tq/QG3cx23zab3Gfay7/3JzpM3n
5ypHBh3LWz9bTF3+jjTA+4546Xu1hmeOyF+saK5Vf5QoLFrqA6c1FEnDDeXSujXowUCcC06cXLFOpThuUY3jHGS0Yxqme6dvhMNr3XHKsYtTOw8tYx3TYNMoLqtmro7jdob8jf4oN/9afRTC53iQ2qiV6+erL+cg
rM9FfczH+9yW4+Dv18d9nF8P/NY+av38PMfz6zetv3LE1hq7VnsDvGvjpZ+H6pjmiuU9Co8z5TjByRgikJMsjXCcqZjgVN9vynkM5jjEMUsvnK8yXv1It9W5DEclrRZGKCG48ZzEHNsod5hyzET9vDm8MY2myi7l
rybaVWqW/hxebtb1pRiKMd4RimaM97k27mMux+Xruz7myTz+ZT1e6iqG/OWYKx9n4Vkzddd3qwEe4B2Bt1XRPPtL9thT0Xxk/ZUjdqZ/32/TLarRXFmna5xSodypG+yWTHQMKyWUbnWvaGeEHPrJzMAzlFHaso5r
QqjzL1w5BeTUj2MaybvHEmuiqmaLrJtPf3sUQl9/6yJwliNVLV/fsnp4jfoY5hteH/cxl+N0f932aFzH9P/V4QU2WtdbdlV/BXjXxEvxR/O4Y1Pb43TF8h6LJ5nGinVUCGY661jFOj6yopOSOsEiWGf8+DGJlZbM
MZLlPXFihWssacM59o7T7SE6rgzSSpP5GfL52xYhLN/ftPYMgQXut5ooijWWio9YH/cxxwLT+quP+7i1/tbWwHF44dkhXI/t81vP87cfA/AAb6uiiccL7LFRN3xs/aXnjN6Cx5kkUiEyRPmUTq+0XEvjaKWXRCP3
TK7FI6YO74RRXad4Izvi+Ii5v3FPmR/V7LaptSVcij+Y2qs+CqEv7+in1katDKphun/N9U3FfcxFfQx8tD7uYy7Hob9ufdzHHC/M+//qruN+vFzZp3ZdfwV418TL6ZljFM35ynssHrWSK0Yoa5nlSgrn73vZKGM4
71Wre0ocE2GpFHIewgqlGEOiVW3XcyQpobQXgjSdYUpab2vyt0XRPPvX1kYhTMdQHPtPy1EU66LIjPEq46Nr4z7mRp35eJqvea7L8fQ+H9+cPPsTj1E0Tz4PuVv7jiaFtzau8xLekQZ43xcvxyL9YOk0HS+wx4K2
+Oj6W6to8ngUS6I6xxpcGadkmOkl1cgoQRQxiPXCKhH25MgpGsGEGPwpdQpHCsKp4j1pqfLvb7zV52lpvNR8r/q+rM+5n+fvV3JR4sb49mGv/SN5P7/9lkedeb583RKPnZsfUVY0n19ewPtueCn+iFkkx0M1PHPG
8h6Lx1opnEoholfIj1d2f0WKxjQCy14/mIZJQRWmnAupO86MxIR0rXMOlrSEUOxtTf7WK5pc/9rn1d80r2E8V+CONXEfczxzvvslj1f/HU2w1GiO0H6P0TJXqz/AOztemUVSW17HC+yx6Xiuj6q/dYqmhMeN6lRP
O9FLv2yFZdwpF8SkbJVxSgXLB89QxRDjXdf58QLcySDUSRJMeGPE2/uUF/AAD/AA7zPxcnpmv6I5Z3mPxVNUM60o8f1njj+k5P6TGMkUpcwxTcs66VTMY1/hrfMhozVRTwtrwtazlxfwAA/wAG8L3lpFMx8vsMeC
njlS0dTU3xpFU4MX+IYrRxs9s9Iq5fvPHH1o05g2hRd4Zc4u71NewAM8wAO8z8TL6Zm9iuas5QU8wAM8wAO8j8Zbp2hS4wX25W/9Ny3766/+nNe/voAHeIAHeJ+Nl9Mz+xTNecsLeIAHeIAHeB+Nt0bRpMcL7Mvf
kYqmtv5qz7mMJ5A3qrxp7C2823+84Q8mB+OK328+KM1gw0CALkqPD2kiO668R9cf4AEe4AHeGsvpmT2K5szlPQrvwTDa2/0W/g30QpunqX6wF74Z2abjT6PBBoZxeJVMc936AzzAA7zvhFevaHLjBfbl7zhFU19/
decs4wWMwDAPnuHeYp7RrbeRbZyeeeGbBNNEfHNceY+uP8ADPMADvDWW0zPbFc25y3sU3oNnHt+bPphGeov7zkJv2pRvnmyT5hn/PWew+tzUxb8MVo7QuBxhc3u8yqXrsfbofPzL5Vqpj7Dp8ebbt0fYTN9/a2cG
eM7XE+YXfU3b53A+Z3sDvKvjJW7SZrxHS99zPvfZl7+jFM2a+qs55xLek2lG0yENbBPUzYNuBra53+Z8M3lHIwaLGKcuf7lIi2sjbH5EvMqylSNs+vy9xtjck+NQf+vjBOTmwJxej7Xzr81zHObjqZu7rIahv4q/
Aryr4tUyTR3PnL+8x+BQO5gZx2d7e4gTMhiOrI2s8cZ6bzSYiM3hvfFNOQd1ETb9fIx1s/++f7zKpetRE6VtKcJm8M9LUUFrc5yKp7lv9uZ5/e2bvTng7YkDtJS/fQZ4gBesjmdK4wX25e8YRbOu/pajar6Oh5v/
fjDNg29mpqc2jBdQM5ORiVdbKu+2yGdh/eucjM/rG2udo+NVlq2kHnw8r9cYm3sibIb+xC28sdRfd3T/356rvLV9LBvgAd5avFx7DHtkm2uT4pkrlPcYCwzj42k+zejB1GBiMD5YIJ9usHA8Gqz1pntvgW0eeqaC
aWr7S9bGIi6fYVp/a+NVLl2P+dFrI2wuxatcm+P19beEt/Y61uEdpWjO294A7+p4NTxTHi+wL39HKJq19bd0zhq8R79XzDMhJdjG4S3yzVzdLOVv27Nu6qiAl4tzcly8yrLlI2yG9zNhrzHGpt9va4TN8P58muc9
ETZr+v9qSr0Vb31/3T4DPMBbj3ecorlGeY8xzzJOf/Qx35h+sCzflNjG96Q5vElvWjkHdf0lub22RNjcHq8y/Y7h9XrMj14XYfMZP/SZ5z0RNuN4GKU3Q7VXJX3/bX9Hs72/Lm1nbm+Ad3W8ZZ5ZGi+wL3/7Fc36
+iufsw7vjWPezDbe5mzj8Cr4Zv7uZil/x/Tef/b995rXpnmNsJnC2xNh8yzljS3WYCNeedTZvLZy9XDG8gLe98NbZpo6nrlKeY8x5vwBa1gzYRo0WIZvymzz0DMTW8hBVX/JlcYjxb5zfYTNc8cPXcJb+x3Nvv66
zy8v4H03vByL9EMq6ZltiuY1f3sVzZb6K52zFs+zzGgPnsGDvbCNw6vim8f4tEWe+ez7BfAAD/AAbz3eEtPU8cx1ynsUXsw0wWw3WJJvlthmnC8t5ptzlRfwAA/wAG8rXplnSnpmi6KZ52+fotlWf/lz1uOxdrCI
Z5SlsmmUosItOWX+HYPjj879iylxy4aippHGv56WsnMcLlln3JJ0umlev7yh+rjyHl1/gAd4gAd46/COUDRXKu9ReA+mifhGt9QxRopvltjG8/n8S89zlRfwAA/wAG8rXoln7rf6vrOt+dujaLbWX+6cZ7gegAd4
gAd4Xw9vv6K5VnkBD/AAD/AA72Px8jzj9cyRiiadv+2KpqK8w7eQAgvE+051XddiiwXGWGGCNOa4RQprzDAiknT3G2moopx2WvvJlT/negDeWfFexxC/fh/62fkDPMA7M95eRXPG8irjZ+HHCEmE7jfMkEWEtO5f
QwxBmBPmdsJY4gYxvxbhDhOBLdFuKyO94x0SJv3/+OsBeGfF2/a1ynXLC3iAdxxejkWCnjlK0QzxJZWSoq01xxRu//XlFUIwQRyDCNQ6JmkRJY1nHMKdmumIJY5fHJMQt805DSd3rFM3qmudnqFD4Bi3jqLOdCvi
jh15PQDvrHhTnrn296GAB3gfjbdP0dTmL7DH4xuTgt1v469wxNryMUQN5Z4t2h4L7PgDOf2CbOuYw2kaRzNIIYw7pBEe2KZxSqZ/MJBArO1bKnphRIbjlstbE9fxUSeP+C5+67Zol/MzPONp7vla/Ij4jelc+vzF
NVEf7zM/n36MMf+S/jUiwvRr+9cv8p/j+edI5RgE6TlES/fLlvk3PV7uiC0RRV/7/9bPjTefb25bDNe0Xc+fAl7aEk3m0d6OVDT3Wy3T1PFMvryc8IZpzFGPOmQRQ4jpzuJGCu44hZLOdtzRUY+Y4xeK+o45jiH3
W0eJJi3qWtN2Q6TlhVn6UzX5jHUZ8rc12mV+fv5t0S7Xz39VPjr47nhurdfxJbW5XBPvsxztMs3j49bAR1P/Vp5LbF6GfPzQ+liYuTqe4oWc74koOl6PtfdFro4D/6Zm/ZxHFK25q6fl3W/n8aeAl8PLsUgNz9Tn
78Ez2hpn2aXTM29/bVM0EstGGCq63rUu6vRMjwTvOaKdMlySzkhngiMmWOOUC+PWNaWeUsczxmkagowjJpN+O1Por6uKdjmfhzeHVxftspy//YoGP+b7zx2dixOQz2X9/VKOaaa6cf7JMItzej6w9fMsl+tvH15N
GeN6HdtYrOly8T63RhSd9//tK3W5P3Ff/NUjDPA+Dy/FIOH55ThFMzxPRkwjGcVE5ZZznnmNb+njJ8+3BFNMUUUE4doLF8o7Py6AKaylckQTymSIabUVLefMdqZzeoaoMBqgUx3pVn8fVDceqTba5Ziez4S+/rZH
u6ydr74mr+l9nvE01+YyXQO18T7zM07m8jffnvPR82eHJbyap42l/MUqbHtE0df5PGrvixzPlPrrttzVobzH2Zn8KeDl8HL+YJln1uQv8EavnMnc8n6L/9qmaB4jmqlA3Me/RB0n1ukWw7HmbovRyGkVYpnlVri1
nCNMkUWUtVRTlhtptnQ9ts3YvxQPsv4MY//GnmiX87OF9zN7o6rF9bcnJme8p6Ch/pom3Z9TU2dL8UP3K5r1/ZPliKLr432W6zvVf7Wn1CMexPsEvLml+KOWadbkr4Zp6nimvry600QTRphTN13PKDdEd5ZxxXVn
Gi445a10+kg6ubOnDuv6D+rb8LRn/fm+e0u0y3nkyJr6W8Oc8/61tblM9TfVvF2Iyzhnm6X+v23vaPLxQ+elq6vjgDeNKbonomh8fdfcF8+zTSOKzvvr9t3Vob8zoC/fict2Ln8KeDm8HIss8cxzfFONLfOM0zOV
TFNfXq28QJFYUc1l55aMSo6EYIxbSRRXQlUzzN7xQ/n+tS3RLueRI8frsS3a5Tyvpf6SYGXP+ppLn7/cuWtqIF9/07c3/phcdJc56nNPj1eu/VyNput1Xf/kckRRn7/XMV57Iop6fz8vRUhbIoq+9ieuvavXtLct
Bnifi/d6Hzz7d49RNG/jX/Qx39GsKa/CjkuMYpoZoqQWxt37UipNG9by1gkbwcUR16NuPM2VvverH3X2ceOHtowGXu7/e5/6q7Exf03zfMMyH6sVrD6i6Nn8C+ABXrAci5R5JrSPs5dXKY0cv/SWW2s621ghpGMa
TlvKaE/8t5z9Eflbr2jO/b3f2F8S+8A41aiio/O3vv7WMNNntN9YiS1FFA14oe7LTHNc/gAP8I7DS/FHDdPU8cznlldyaVUnqWqUYoJ3omWEWe5kDXXtlXDi9T7TvfYD3T4hf4C3Bm+LIrxyeQEP8L4S3hZFM/LR
ecvruUPbzs+WSZFEGLUta9vGzxbQIK065aPBYCJIo6X2vWofnD/AAzzAA7zvg5fTM0coms8urySyEdpgxzmKK+7nCJBdSyRTDFG3vN8YoQdpmTOUF/AAD/AA75x46xXNk4+uUV4nWYTkCsteKsUUkob1TDKskbOK
cW3Xvr6AB3iAB3ifjZfTM/sVzTnLC3iAB3iAB3gfjbdW0bzy0d4EeIAHeIAHeIAHeIAHeIAHeIAHeIAHeIAHeIAHeIAHeIAHeIAHeIAHeIAHeIAHeF8LjwhvFM2MeCPK21cq7/XwhqnnZKNa3LIj8OYJ8FYl3nBK
Gt1ophrkrLZ9DPu2pjVcts5YIurzIfkDPMA7IR4djA/GBqPW2+P3wDefmT/AQwwzrFnrZ4BBiPBON9hdssSsv5+Tv2+E5zmm9w1GsUY0Qsm2aRuBAodkgYatyOGhRraYY24taUjTM9SilvMD87crAR7gvR9egmeG
qJlPnrnfapnmmdqh9VDTWWxajv2Emgv5o4YYpP2e1DwRxhRwQs5iI494n34fpGMkpP22+XmeOZqe55nj+w1PzhGQwnE51FI65vp2PrJCQ6ly10Nx3LCe4EZj9/9e5KX84aFmuFpeEjvHC+ty+/KZdw6z5pPE/ZLL
x9q05Xq0fdtT5ZuE6mKe8brGXQ/TuuQnV5rxTVAxutXCoB71lmCKqdV+YvMe+c8bejKom2R80xjGp3Lt08yXElO8MhKOWt38SuTztycB3vfAi5mG9oMpb2sVzTR/JaZJpTnPvOVv2EIGn+//RhPPGvD9WmLi/eeM
MOLlmCa33qM1Tcw5qfLuT4t4LnetYkwjIWijEW1wKxBuc2xzVP5G/x7w0Orj0keN8TlrmCakuSecpve9Hp4lOOtIR7QdOIb5BqNE4yeM1Y1trG6cPEGie7BNYBjRCiF9R7SRTs+4u9K6q4ZbS3GHO6sC63ge4qKU
l5gdxrqclzfUXK7G4+sxr0U09m9EbJW7EnXpKv4P8D4Gb8IzQ5/ZlGe8njlO0SAd8ufXkIk/nzNNYBA6qImYSZbKu1bRTPPq9UyKFbcqmmOvLxL3G1FIDJWDa/hmf/7KjJHHCz4r95wdo8bp1bt5vNjP7k0br8fA
G77XS/SdS7ofGEY0jj8aqVRjGqN6r2u0JxIsupa2VPDWtta0CDvxQhFDzCjkzDbIImux10mymeqgdP5STJNOob6f0dSeeGFd7nrMU5pnPttfAd5Z8QZJQjs7WD/a/db1tHnanGke6iYaGTC3jnlL5S/HNEEfeC/v
/bXfEta/8sz91vKwb07L5FKaZ575W2KaOp753OuLxBLbHJe/wAj3Wy3TjKn8POz4vJJp6njmg67HC9+4W0E32vGMX9qmb3rdep7RXctapkWrWqWt55P7zSCfHN90qDMi9KYtvNuJTutTfAXy5Y33jZVLWRGm8PYo
mvP4P8D7KLzAMZO3MIFJxGBssMAqIrKBc5yeGbawJm25nrW5724f/iqsI4PFbDBXNHGfVc48XuCh5b6zsTZKPOP57UhF8879OYt8c0T+1iiaGK/sp+p4Ju6vO0LRHHI9AtsILIR/XqOdvyFsY0MP2puuIS3RdOCb
YYyZNkHd+PtNyBzDZMeDDMt6rh/fg8V4NW/ZlnrOruj/AO9j8Drj7aFYAsNQ5599YjOj0frAN2pmwccH7TPonVT+5kwTesLCe3XPIEh7X08eumbKMx5v7Dvza7znf6qf+RmWeCbO3xGK5kzXN8U299ue3rRp8ozg
81c/GiCkUs+ZxztS0XzK9XjjG9n4pybdD7rGPN7XxGzj2ltLnb7xvWmsVsVMT+XTk2eW8ze/HiXe93hhyzHvaM7UPgDvo/BippkomjlvxIrGbXN8pBI6Bg1GvI1M85rmvtv7f/8+NPbkYetze2rUWU6f+LVD+5j1
rIUj5konxyfT8WZHKpqPvF+2qJu6/NUrmvz4pnmPTQ3PjHhHKZpDr4fjC4envE4RnX/noon/Rka3g66xD75xptGjN214d1Pimbr+sPI1iPcc+ydDytV4Ex1RHnV2Tf8HeB+DF/NMsPst/iu2mG8Cn+T2fOw/8Ewq
f7FX9+Z77576JewTaxw69KUFngl40/HNMXsEm7/nifccx6kFPoqPK41sruOZc13fOAW2cdf3sLEC3vfE48Pq39E8ctQ8jx2XMV6ZaWpG9X5Cewsjyvq2FxQTTDTBCDuBjhtXxZ0fn6Yp4oi7325HTZyecfs6pvFL
OrydWalrpjxTzl/QJDk+SY0RD3hz5bJV0Zy3fQDee+IRPyizC3zzMBvZMDbgwRvBF4ees/H9R1My3HubnzP23ePI4PstrQZiDsl9R7OmvFvT18GrUze1eLWKZl15y8/XU7xjFM0B1+Px5SVqHMM4PsdCD9/FuOWM
byin3DA/BE2zQe+EJUcGGR3GAtCa8WbjiX0qX4PX0c17y5sa/3dkArzvhRePFXj0pgWmCb8HPlmfv5hpctojpPidPx76r2qZpi5d7Xoch5fgG+b4hqEe1w9yfRkfVv+OZil/R72j+aDr4TvBlB+nLBi22Do+UVi5
pXhlm9CX5r/8l8j3NN9vRgwMRB9ax/NNWDLf1/bKN6k07Q9b+8XmpvI2WxXNddoH4H0kXo5n/PsZb0HxfF7+AG8f3oNthEFcqE4rxZh11jv+YJjj4neC75m/JUVzlvoLyfMJV8P3mo5KSKupq78Z34TetPiLTb+v
45vWUQrHLo16J176rzqZPVd5fUqN/zsuAd53w8uNFQi/l3jmeuX9nngEEU5Q6MbUWhvde7ZhPaKIkS59zEfm7+x4/tsZ1jnC5pZ2uMMj3wS2Cb1pqRloHN6Tb5w5vnGHO47xGif0tRE/Go1W6ver1h/gfXe8+ViB
6XiBoHg+L3+AdxzeMFCQGW74/WY4NwKZBhuC1NpX/O+Uv7Pjeb7gxLPN/eb4ZtA3oTetZlbNB9u4S+DYxpmOZjk7Z3kBD/COw0uMFYhGDIQpAD4zf4B3NB7uCeoIk7wxBGPMWHY02tco79F4Qd2E3rTw7qYSL3x5
wzDjAjmjMJ4L8AAP8AAP8AAP8AAP8AAP8AAP8AAP8AAP8AAP8AAP8AAP8AAP8AAP8AAP8AAP8AAP8AAP8AAP8AAP8AAP8AAP8AAP8AAP8AAP8AAP8ADvNHi5GMvbDPAAD/AAD/C+I95AKThml//45Q/59/vtfvP/
ml/+lKhpfvnzV0T88m//+PVn+4v68a/mrz9/Uc2P/zL8+vPHz3+3P/5if7X6pzU//vIP9ePf7G//CEBu73+xv/74z35pf9pwVPgdjvvz9bgf8jfzQ/766w/9+9/+5n7/+Qb03+0/f/y3sDLg/Fdj/vwhf/zm1g9H
Pjb++Pl7Okv/6cf/9e/27/bHX/1Rv/71b3/9+eP3/kdL307lDpM/f2j52w9lf0hj7IAl52X6t9//X/vj//4jZMP/kamEH//4Y3rMv/z+z9+WjzJ+r3BctJxdFEbfLkr/J0Jhr/+43/6P/x+EruZamCwaAA==
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
3s+rudXZk+ZOlvDw8PDw8PDw8Lr/HjrWUdp/GU+x/iN7Xfss2t/fKM9B+E685v6/8Fo+1U5N/uz+TTvZ68TiLbltJvP83dVf5svB2lozJV7N66eK3Y8pidtl+Qvbvsgxdj+1mWTz5Q45mmZq4ukhR9OVP1uyk/w6
gP/6QV6a2/czHh4eHh4eHt50PHe813o6XtRr5fc6yvIn73Xs9veY576+cVj2GDWdmvtPfeOq7GSe3fruB00/3w3HA/74UhJt2FvFjoevZ9W+J7c7Ps+ONuRHott/aedpSK9jk7/hqYkHw2MQU6NZWbxl5iAcOXbr
L/VouuLzIUfTlb/hfchdz71+bsLDw8PDw8PDw3O9mt/r6O6/lCy+/Mljx5WxpnkWbZ5Xu8prnjPbW4ST//6/8L2ZsvNdyR2r4ftV/e+XvH6q7v3A+ne9P51LvVb4Hkd/vGofidR+qtj9mPZ24eTvr5VfVzBz5Lqf
Opwn2Xy5w3sdm/h3yNG099C9n3V4r2NKf22TQt86av7nMRc8PDw8PDw8vM/ptede/fM1+VhHd8q9/893bt54vnsFw2esrvtPwzGbeUZtvuIbZekaDyaJXnzlacormSfH3rPsflY7mWXUhrlnnddu/BGeWcVOviPX
9G/ZZfHVezhy7F6PkCfzruSuJ986ffxl6tG0k/96ieRo+ufLzTuadkli8X5uf+1YCQ8PDw8PDw8PL3dLd+R4qfylzpPj75/xPbPC128SfgpDd/6X8NmteQ+jb+xk9/4/M0mezmGmbrzlK7WkB9dM3fGDZq+Umcy/
+vbjf96E7dmzePpKErsf00y5z3PIm5u28fLy5KuBbv2lHk37WHbHN+okP5qu9/OQo2nnNb2/Npym832Kh4eHh4eHh3fLXn6vY3r+wpFj9369vLNol5eafFGB35vf+a49E5DLsyOCaxyPy3hm2fz3P+uUN47S5Un6
FVM8nSRH0z6W/ufj5KVpHV88PDw8PDw8PLyxvX7kuFyk3rEaTt38hZ8f77uPz++NnT+d5E9Y1yn3+RCSdCnPjDbCo+rCkeNcyutLqe/I8eLVMTydzGPp6h80U+p1gLkfXzw8PDw8PDw8vPG8nF7HOZc3nmLPDxie
8D6rl9frON/y4uHh4eHh4eHh3Y7XHd+YM0+OL02zvHh4eHh4eHh4eHh4eHjpXlqv4/zLi4eHh4eHh4eHh4eHh5eauuMbx+l1nHJ58fDw8PDw8PDw8PDw8NI9aa/jrZQXDw8PDw8PDw8PDw8PL93T8eLuWS1Dex3n
UF48PDw8PDw8PDw8PDy8VE9Hi4fT4o4cb6u8eHh4eHh4eHh4eHh4eOlePHZM88ZJeHh4eHh4eHh4eHh4eNPxzverbtvI8eWPtFy8jJrw8PDw8PDw8PDw8PDw5umFYsccb2jCw8PDw8PDw8PDw8PDm5rnjhynkz88
PDw8PDw8PDw8PDy863vVXi05vY7zLC8eHh4eHh4eHh4eHh5eaur3Oi4XqXeshtPUyouHh4eHh4eHh4eHh4eX7uWMdZxzefHw8PDw8PDw8PDw8PBSUxs5Lhd58+T40jTLi4eHh4eHh4eHh4eHh5fupfU6zr+8eHh4
eHh4eHh4eHh4eKmpGd+Y/3QOO025vHh4eHh4eHh4eHh4eHjpnrTX8VbKi4eHh4eHh4eHh4eHN1dvdUpPpyTz9Lp6u2H5S50nZ181Oa6qlZH2VVUtF93cVJVa21zruNJxq81O/fby8rzfrrSnX9ns9N+bpD0lh3Nj
evr1573e/2anX9HrqfL6ttiu1DZqr+pv3XKtVu6tQp6k7K7jMWbCw8PDw8PDw8PDw7st7xwJPqzqVRmOIONrpuUvHjn2vSba68dpKipS8df2+F/zFTP2U/GU8nR0ZsaOOrbSWzf7UYqOttS/9474Ub3WeP7IzVTt
SK+//+WiWbe/J9d+7Nf7ZV8uzNJ3y+47KqE0h/czHh4eHh4eHh4eHt7lvFBUmBZfpuQv5+kcbk9HjqFeOn/k5urP88WfZvJFbpud2krp6udm18SDKn/9LaQxqrnVcpFaIn/02ZR3zISHh4eHh4eHh4eHd+ueHSFK
Y8ac/IUiR6ln3uupY7yU+ztDEZVSteaKHN2ezo2KF5to0TR86+v7Y7v3qsbvWA2XR/c3ymJHSZrn+xkPDw8PDw8PDw8P73JeGy0uF6tynJ5Gd/7yeh3bHkHV/9aMuWzju9RIS98vqvsH9XjJpgdRratiQHekZXv9
WFOV14wm96f1JLGrdvTdrm0uVTyoo0lzLT1CU+corddxmu8/PDw8PDw8PDw8PLx5eGZP42X6G3VyR44hzzc20V4n/f5OfYepOVeNew9t/syt96f8qChOR43NnafmPaz7c57t+M2eJ8cXD1anu2DN1B9Nqby0O1bD
af7vZzw8PDw8PDw8PDy8cb1uf2PaHas5+UvtddS9bN3+wZzcNMl/f2fa1s38rG0UZ/WvnvsHY/Oc+tI03y94eHh4eHh4eHh4eJ/NC0eI7r8OzV8/cjzGb5HY0TerTDNDjeo3bNeO5y+tL67vdWNHPb4xdG+r7k1s
Zzlt+0PHSXN+/+Hh4eHh4eHh4eHhTdvrR4XLxZCnc6TlL2eso/Jczy1s7++MG03y398p3bqJB9sRiKHy6nlg056QMbX3Cx4eHh4eHh4eHh7e5/R07CW/F7WJL5v5afJTGzkuF0OezmGnOR8PPDw8PDw8PDw8PDw8
PDPpaPFwL+t1nH958fDw8PDw8PDw8PDw8FJTM75RGjtK0pTLi4eHh4eHh4eHh4eHh5fune9YfVZLKHK8lfLi4eHh4eHh4eHh4eHhpXuVemjh/jzTzcBexzmUFw8PDw8PDw8PDw8PDy/V09FiKHK8rfLi4eHh4eHh
4eHh4eHhpXvx2DHNGyfh4eHh4eHh4eHh4eHhTccLRY5TyB8eHh4eHh4eHh4eHh7e9T07dkxb1PysYy54eJ/du9+6l6nkDw9vBt5pFP+E84eHN8zLeIfPurzhxVkbE8rfnLw/6nKi+cOblLfarM5puVD///3x2+7X
5WK5UP99fvy+W69Wj9/f1nV1/PnLj7f3+7t/efr65R/vHveru3/7+fX73fF/7z8fTq8ef9m93/32+vZ2tz/cPb9+//a2+6/D893pL4e7Px++//X967c/dXbxt8dvX94P//n++LJ+/G//VD++7/a//+3x74+vHv/3
9h9v+7f34y/HP3778vrl+fDlfXXa4j/f92r1339/fHn9h021enx7rdcrZ37//PXH/u3wD//89vr01yYrp9y+vB7enu/ev959/XbQL//dXw5vh6f305//7liA3dvXn87ZdeXzf73+9PP7XQB+ejvsfj29/np8/XEf
r9y//Njf/evhy4+7/7n75aDq+B87taxe1bV8fKGt4P3h7etv7f53X57vfvnx/V0dhR9fXv/9x+Hu5avOx/dTAY+bnA/GaWfnIj7u7/5y+Hb4dff+9dd/Ohy3OGfgz3o/dzv1593pz3f/dCzX/rTOiVX/b7JuY//j
5f3wa9jaqVV8lPnz5f7x5ft6bb72+3Lxf/z/G8zNPmfoEQA=
"@
#endregion

#region ******** $MenuCommandsrtf Compressed Text ********
$MenuCommandsrtf = @"
H4sIAAAAAAAEAO2dy7KluJrfPV4R6x1y7Ah3gwS62CNHdw/bA7c9y4lunFPRdarKlVl9HNFxnswDP5JfwfoQbMQCgQDtvYHUp0iSvRb8l258+qEL/L//83///evv35vyq/jl20/tRv32pxLV6Ks2TVN8/eXXP35S
v/7lN/EdPvhZ/PKnssD43782v/7y/bv82e4UX5tffvr5a6P+LH7/Zr4XX/6H+POvfxH/5W9/ez7+/et//Pon84v5XXz/9fcv//0n9WejUfGlLP6u+LuSUoL/9vXffjJ//defftHV1z9U+eX5+Pqb+F1//SZQUXz9
9jOixG7/8sfP38uv/0t9le3PfavYV4gJ//LP5pc/vvzDr3/5i/hFf/sq4TtUgcLzsaTUHvCP5tu/fv/1t7HGF/G7+fL9z+bLP/1vo/74LuTP5tsXG/V/Ub//9Nv3b/Yr8b095mfxxy+Qmi9//bP5pT2jk/jy07cv
38zPRn03OhCTquhj8uV/2BObn37/9v2LGk4HNZvZwh7x9nH7w/Y708bL/u7fz0RhlCTd/WGL7xc4U//6h03Nf1I//6T+1ei/W42bze9///rbT+o7FKL9/7fff/3tb1//+hfzXTQ//WwYfPZXjkgBO3+uMS3bT/70
q/i5RrX7FP7ARVXbci3Koih4AYZrJMr2b/hDDftF3f0vC1QUL5+pAjWyrJBCFVbPhzurwkUDhyrVHSTtCeZNr+jP6P9GrBPtjoHjwVz8Svb2qwWuKlRge0RVmPbI7v9X0xjC66dWb/T90fB8pNHJelnvvHpNAeG8
8ct6We+YXmwNv0t6Y3PjnPE7l16YNgbeuFN6s17We0+9/bRxzfRmvR9NL76G3yO98blxxvidS2+JNnreuFN6s17We0+9I7RxxfRmvR9Nb0sNv0N6t+TG+eJ3Lr1l2nC8caf0Zr2s9556x2jjeunNej+a3rYafv30
bsuNs8XvXHprtAG8caf0Zr2s9556R2njaunNej+a3tYafvX0bs2Nc8XvXHrrtHGv9Ga9H14PWT30Fsrjweq97RsNIZ1e6vhlvax3TG97Db92epeDaSB0vuQa/u8T9WJo407pzXo/vF7nX1TTBtkG1ga6Nzwf/Z7B
EPYrveqlCVkv66XS21PDr5zemeC8RWtGQujY4405Tu3/PlEvjjbuk96s96PrOcro/YuDDVm1oYAgmj3h+XD/O0+0T2NOL1XIelkvjd6+Gn7d9E5D5y1az9GxV+tT/B6O8/q/z9SLpY27pDfr/eh67p5EqucDvIWo
IfA2MNMGvS88H7AVJYS9GlO9dCHrZb0Uentr+FXTOw3OWzjPoQkEd8vS9XCc3P99pl48bdwjvVnvR9dz92Zwd2J5o+o4o4BAndV7w/NBa0Yg7Nd41UsZsl7WO663v4ZfM70zOdB6C+c53L2L8ylj2jir//tMvXXa
aLzwfDRFypD1sl56PRYd7P3MhqOzXtbLelnP8Zbr43Gc4cZT3PzZz/d/59Xb0rdxD77KenfXcz4hzobn86exrJf1st5d9Zxn6Xo42lEVf375a9/GXfxpOj3Iw2Fvzu6V3qx3fz3nE9ySk0ZOwsukL8vjouGTwCaB
toF4ofZC1Qbc2PjBtg2oDeUQ0vu/rJf1st5H6W2njTv403R6kIfD3pzdK71Z7/5622ij5Y2EtOHxRhLauLZ/znpZ7z56e2jj+v40nR7k4bA3Z/dKb9a7v95W2mj4DG8coI033khEG1f2z1kv691Hbx9tXN2fptOD
PBz25uxe6c1699eLpw1KKNEIlrI9H4rDc3osMUTQhuGGN4gIIjSFGWMGjWmj441ktHFd/5z1st599PbSxrX9aTo9yMNhb87uld6sd3+9GNog1pQuSEEkLXjBpeUNwARVdswRoA3HGZWpjGoww8yYqqiKhlJNtfFo
o+WNhLRxVf+c9bLeffT208aV/Wk6PcjDYW/O7pXerHd/vWXaAB+heUELKmufNgpl/YuSGuhBISOMsMzg0Yb7pBKVUBIgwlSYYGIUllg2CH64qVjNalP0szY63khEG9f0z1kv691H7whtXNefptODPBz25uxe6c16
99dbpg3ohdB1XdWVMi1nUDhccnhsOTxftDCFUUVVVqWqHGF0nEErqhgiiGiBFLIn4xKXhuAa10Y68oCF+Loe5oi2vJGMNl79H3IeUC5tSfC69vWWlbC3nJhS2FbmVQl1ejEaztwn0yPH8YuPWYxdr33LemfSO0Yb
V/Wn6fQgD4e9ObtXerPe/fWWacMoo5qaUEKVqa2pBjjD0oYohLS8UehCy6a0pnCFKqQqCya1oqUpjS4RRlgTRBHVEtlgCmSQMbjSlVbGEBsaf0WK5Y2EtDH2f35LjALHOzoIHYOZ0wu13e4Mn1imtOFTQ6+3rFF4
8Q7xQq/q9GJiFmdXa9+y3pn0jtLGNf1pOj3Iw2Fvzu6V3qx3f72YeRuvzKGLQhVKym48xcCj71RZ4hKruqQlVbyUpVQGoEEjMMscNao1d2MrhhraFP68jX7Whs8baf1fDG04c62yIwXf4BPQi2+1p7ThPhkU1v29
H+/l3wHVa7VHWe/Oesdp44r+NJ0e5OGwN2f3Sm/Wu79e/JqUjjkYYZY5SE0sc5jC9OMpfQ9HWZWVIi1ztI8rVtr1c1SkIqp9kZsliZc1Kf6KlIE30vq/eNrwj/T7Cdwnz0f8iMSUNqaqa/4+hjZ81Su1R1nvznop
aON6/jSdHuThsDdn90pv1ru/3tbnbbhVKC1zNO2ISAP9GzBj1M3hGDGHDYpX1lTdccbM8zZen7bR80Za/xdPG4V35JQU+vGKmLkfIdoYb6d6vkY8bazFb/tIirPrtG9Z70x6aWjjav40nR7k4bA3Z/dKb9a7v94+
2mg5o4JZGKoq9fNRalW2PRymYw4bFHJjK+0cUhxPGz1vpPV/x2ljYId5/+yOXaaN+Xmjg95UI34kZVB9jd9UdZtdpX3LemfSS0Ub1/Kn6fQgD93foXy+V3qz3v31to6ktE/PqHGFK1VhhJHdL7D1L6oGXFAEMcTs
vm0lLYdYaFB1uyXtjI16fSRl4I20/u/4SIo/w3P2+QIRa1J8jXH8QhoxtDFVfZmvt2tNylz8UlnWu79eOtq4kj9Npwf56P4K5fK90pv17q8XP0sUAMGyBcdctU/PsFuPOZ4PoA7VzuvQFNa7Ktr2fbgtQxpp5WaJ
VuFZoj5vpPR+qL/fip4lGmrfx+s//JGK6UrX0ArYufWsTs8/NmbNbljVj980BtvtCu1b1juTXkrauI4/TacHuej2Q3l8r/RmvfvrrayAhXGTukY1UgQbDL0aEss55qj08wGjK/Cwcl3SghaatxxCuj4PYA63pZWs
pGWOyQrY8frXlP4PFd391oEVsK+2Hr8QbWzRi+nb2KK337Je1os31vFGKtq4ij9NFVx59Pvzdqf0Zr0fQW/lWaKUUc3bp3updv7FDHO4sRV4qhe878Q93atljoKWtNQMW3PjLeMtsUGJpTfApvN/a8/T2jePci1+
22hjXm8/bZy9Pcp6d9ZjHW+ko41r+NNUwZXHsD9nd0pv1vsR9JZpQxBBDOaMM0NqXOMxc7ixFf+55ZY3vCeXd8yBKLLMYU+3nAG9HW7spWIls95m+X3zZ/an63pbaePq6c16Wa831vFGStq4gj9NpQR56M8XnbM7
pTfr3V+v7+9cnrcBr3k1qGOOtp/Dja3MvZOt4w3vrWwdc1S0ssxhg6rat8mWy/M20vu/rJf1st5H6fWzNhxvpKKNs/vTdHqQh71eKI+bHcH6513nZb2sdzT0/Z0xa1JcP4cbW2n7LgLvm295Y/LGeVaxShNe81qL
9TUp/oqUs/rTrJf1sl7IHG0wwoj1L6R90F/paMPgNmgIn+3/zqsH1vNLKI/vxVdZ7+56fX9n/PM2OsLww+R981bPo40u1F7YRBtn9adZL+tlvZD5K1IsbyTr2zi3P02nB3nY74XK407pzXr31+tnbXS8kYg2Gtrx
RiLaOKc/zXpZL+uFbLz+1fFGKto4rz9Npwd5OOzNl8ed0pv17q83zBFteSMZbXS8kYw2zuhPs17Wy3ohe33aBvBGOto4qz9Npwd5OOzNl8ed0pv17q/nr0ixfJCQNlreSEgb5/OnWS/rZb2QTZ/t9XykpI1z+tN0
epCHw958edwpvVnv/nrj9a8zvHGANhoy4o3DtHE2f5r1sl7WC9nck0Q73khEG2f0p+n0IA+HvfnyuFN6s9799V6ftjHhjUO0MeKNBLRxLn+a9bJe1gvZ/HPLW95IRhvn86fp9CAPh7358rhTerPe/fWmz/Z64Y0I
2lBGGcORQEIWbus+cZTxxhtJaONM/jTrZb2sF7LQW1IsbySkjbP503R6kIfD3nx53Cm9We/+enNPEh3xxiJtwElGwLtPJG6f+lVUtKJSAnOIRmmlDXvjjUS0cR5/mvWyXtYLWfidbI43UtHGufxpOj3Iw2Fvvjzu
lN6sd3+9+eeWe7wRoI2WM6TPGcNWNhWrWMccBpjj+bDUkYw2zuJPs17Wy3ohW3oDLPBGOto4kz9Npwd5OOzNl8ed0pv17q8XekvKG29MaMPjjKp9c0rZbgtkgzDtVk+Zw/oXa4amoY3t/s+9q8S9t2RNz39z+/RN
sKH3wI+1Q/Fz8Yh5y+z4d5ye/3suljE2F+OpXswb6cJpXy4P/7xpvOe+DZXHsnY4R8/Q/v5Yesvvm7f+KiFtnMefptODPBz25svjTunNevfXC7+TreMNjzN0oQujkEZ6xBklwIEwpSqVUG47YQ5LHM9H29PhmOMw
bWz1f2u04euFaGO5zXSt9fAL8/Hz32kfelub//vD7wx6yPu9GJtvj1/j58dsmbHm0w56ofz1GWsa7/lv58tjanG0cYb298fSW6YNXXa8cTN/mk4P8nDYmy+PO6U3691fb+kNsC1vvHJG3b6PrXTbljOaUpbScobb
DswhX5nj+XgbXZFKGnKMNrb5vxBtuNatfx+9+yxEG+7Y5Vbeb4/H8Zu216G22X0+/Z297UeoPZ7Te2Wm8efLaX8+lknMbafU4KfX/+W58phaLG18fvv7Y+mt0UbHGzfzp+n0IA+HvfnyuFN6s9799ZbfN2/1HGfY
YDlDWbdRkJpYH4EFJgpjgu1XLWfoKXNgirEqsMRUIUIIAv9Sl5VWHJe4kLU9RJh6P21s8X8h2hj3Mji9EG3EvD9+fIwfP/eZ316H2ubwSMm+9iPcHk/1Qn0YcWl3etOjpoyFJt/6+/230/KYWjxtfHb7+2PprdNG
yxs386fp9CAPh705u1d6s9799ZZpA9n2A1FZEUlKUzNGWdNMtx5tjJiDctIYPj7++YD/aUWoaRBHXDRHaCPe/01pw2/9h5YM9NLRhh+/aQse6i+YzosYtqAXP8/C2VJ7PJ9/05Ge2LSDnn/U9Lfdt2477eNx++Px
o3S0ca/2/Nx6MbTx+f7vvHqQh8PenN0rvVnv/nrLtFHykj8fooH/u62BV0f32442YF9PmYMUpFC1P58DtlZvNN5yjDZi/d+UNvx2zbXc7pjnI9VISh+/UGsZ+ny5ZX8+pr0ky7bcHs/l35Q24tPep9fZNN9dDPzR
k+XfCeefrxdLG3dqz8+tF0cbn+3/zqsHeTjszdm90pv17q+3TBtu1sbzMV0BO6INUxoxwxwdbbTk4a9/tXoJZolu839+qze9o/ZbQMz89Rr7Z4kOnzu9UEs91VtuXfv1JPvWpMy1x37+hdK4Je2+XohSQnNSp2Uz
Lo/QHNOl+b+vdpf2/Nx6sbRxL3+aTg/ycNibs3ulN+vdXy+GNl54w9FG28/haKN90gYGZJASW5MExkgkIpxwxR15jJ+20fFGItqI8X9+mzS9o3Y2fDuMV+xdATtYP/4RooNQa+kzh7+F47e1H+t3/4NeaCbnVGkp
7a/jR9O8DqV6GlfIh6E8QrkS06sxF780lvWmFk8bd/Kn6fQgD4e9ObtXerPe/fXiaGPEGwNtdLMxalUrVdesZqqqrSncroxFjDCiqzna6HgjGW2s+z9/lWWoLfVbsn59xbZWbH/83lMvZqzh+VheAbvV7tBeZr0j
elto4z7+NJ0e5OGwN2f3Sm/Wu79eLG14vDGlDVMbRVrmILWohSUP62JUxTjjunYjLNMniVq9hLSx5v982lie6zh+/lUq2vjM9iPUIzF+ttf127esdya9bbRxF3+aTg/ycNibs2YUrD8tUoasl/VS68XTxhtvTGiD
SEI1IZzUuiaMVLoilGBdWdcidTfDY+655SPeOEwb1/fPWS/r3UfPeRbo32REgBMoHW0Y3AYN4fP933n1wJZp47N5KOtlvW16W2ij4w1HG6xkYmY17GgrrHIRpo0RbySgjav756yX9e6jt7Vv4x7+NJ0e5OGwN2f3
Sm/Wu7/eNtpoeeONNrr3y5N2W4e2rhck9E62N95IQhvX9s9ZL+vdR28PbVzfn6bTgzwc9ubsXunNevfX20obDe95wwtsEmgbiBeCb4DteCMRbVzZP2e9rHcfvX20cXV/mk4P8nDYm7N7pTfr3V9vO23M8MYh2uh4
IxltXNc/Z72sdx+9vbRxbX+aTg/ycNibs3ulN+vdX28PbUx44yBttLyRkDau6p+zXta7j95+2riyP02nB3k47M3ZvdKb9e6vt482XnjjMG00qOONRLRxTf+c9bLeffSO0MZ1/Wk6PcjDYW/O7pXerHd/vb20MeKN
BLTR8UYy2riif856We8+esdo46r+NJ0e5OGwN2f3Sm/Wu7/eftrweCMJbbS8kZA2ruefs17Wu4/eUdq4pj9Npwd5OOzN2b3Sm/Xur7ePNoqCNs6/UO89GbR9aCVxbygV7Za0W3u9xNBGU/q8kd7/Zb09esvviNuu
l9Ky3nn1jtPGFf1pOj3Iw2Fvzu6V3qx3f729tMHsNcAZ6HFMkaqJpFQJiqhWDRWs0hVDTGjBhGOOONrweSO9/8t6e/RS0sYV0pv10uiloI3r+dN0epCHw96c3Su9We/+ertpgzra4Mi2R1hIxLCUCKMKS4Z1pWRT
MWZdDBwH/RyxtDHwRnr/l/W22/h97yns3OnNeqn00tDG1fxpOj3Iw2Fvzu6V3qx3f73dtGFbH0414iW2/kVwVGMmLDBUhSSYV0yqCrNa19AHAmMr8bTR80Za/xd6w/nU/Hv5+ffNg178G+d9898NN2jP+/vld6mF
3l8f1nPmv+n19T32czZ+3/u+VG+J3x7LemfUS0Ub1/Kn6fQgD93foXy+V3qz3v31dtNGY2mD6JI1SAv6fCCEK6GQwEoijF0PBys1osbN59hCG4430vq/47Tht/79+IJvBK//gt/W++372N/7MZj+DvJ+LWRz7Yf7
7dB5IeZwv/98hPo2YlIdF78jlvXOp5eONq7kT9PpQT66v0K5fK/0Zr376+2lDQ7zNmpdMI2EqEpt29+i7eGgwvIHNrLChCplKHNt0TbaAN5I6f0q4/SmraJrLX2qCNGGO7JvrYPPa15kBP/bcVx8vWUuiDNfL2bm
hd/r4lt/7nJ5rPe3LMUvhWW9s+mlpI3r+NN0epCLbj+Ux/dKb9a7v95u2oB5G1g1TCIiypIh9XyIGhXYwgeiblSFMiWpvVZg3cpW2kjr/6AtBb0pbUzv6UO04c4djpyP3+tRfgzGBPHaQnvz6za33XM26IVIwrdQ
qofP18dnQqMxa/FLY1nvTHqs441UtHEVf5oquPLo9+ftTunNej+C3jJtWKLgUK/nt7xUmnGEuCkxogI9H6VAWhBUOuagWFGi+9Wy82tll94Am87/uXbw+fBpw2///ZY4ljaWxium7e6UIMZ9Jb5eaI6Ev43p+ej1
YkaR/L6XUE9PuDz20MbZ28usd8RYxxvpaOMa/jRVcOUx7M/ZndKb9X4EvWXaKAtuG36KVEkaoTUV1PoMwSpKVUEUq5XdKQ0XhUHYMkf1fAB1WOZQljkK0ihMaLc+trLkYShRnBaklLLWRUNF0Sy/bz6V/+vb2+l4
hWtNXdvtjoobSQnFb0oVoXGMuc/98Z5Q2z3tJQmb00tFG+Hy2Ecb524vs94RYx1vpKSNK/jTVEqQh/580Tm7U3qz3v31+v7OEG0oaZjqmaO0zKG51AXHtZK4aupKFhWpuNBYYSM4LrFtzwVFAlPB7BbbLbX7EklC
ZFMbyxmitjKMlkTVWqp6mTZS+b+hvR2eV+W3vq599fljeZbo3PhHaL7kHKUMNqe3PM9i2zhL7HqcGNogeFoeR5/Gcd72MusdsX7WhuONVLRxdn+aTg/ysNcL5fGd0pv17q/X93cuz9vwmYM0FhYU56rhqBaWOXSN
LXPUlT2wQpURzfNRFZW2n5VVI1GFKVaICGIxhWDLGcaeTrRRZG3eRkr/57e3z4ffk+GbPztzaQXseEyjX68Ras2X6WBKAn16/XY8Zq1qyOLW48TQxnh9ir+d5tOW+B04OeudVG+YIwq8kY42zu1P0+lBHvZ6oTxu
doXnY995WS/rHQt9f2fMLNEJc8iWOcqOOaCfg9YIyOP5sP+XVW05o7ScwaQiZUl4VdaKmkLRuFmiKf2fP08yvL5i2r7HtaLn9Pe9hdfj+BaijTk7d3qz3hn0nGdhBMLzIUoIjjYMboOG8Nn+77x6YD13hMrjXnyV
9e6u18/a6HgjYk2KEoYqMWIO0fZzKInromYSVRLmR8C8jpYzirLmsuUMZDljw5qUlP7Pp41+fUrQT+64Zz+jv+8tvB7Hty20ce70Zr0z6I3Xvz4f6fo2zuxP0+lBHg578+Vxp/RmvfvrDXNEW96IXgHrMwctgCy4
ssxRUaMwreCT54OwshZFWdm7Gftv+wrY1P4v62W9rPdReq9P2wDeSEcbZ/Wn6fQgD4e9+fK4U3qz3v31/BUpljc2vnF+xBylZQ7NlBKMlkyUJfRvMFNbzoh+4/zy++bP5k+zXtbLeiGbPtsL/EE62jinP02nB3k4
7M2Xx53Sm/Xurzde/zrDG4u00TEHN0Rxxxxu6z5piNUjb+EwbZzNn2a9rJf1Qjb3JNGONxLRxhn9aTo9yMNhb7487pTerHd/vdenbUx4I4I2GjYJtA1kxBsJaONc/jTrZb2sF7L555a3vJGMNs7nT9PpQR4Oe/Pl
caf0Zr37602f7fXCGwdpw+ONJLRxJn+a9bJe1gtZ6C0pljcS0sbZ/Gk6PcjDYW++PO6U3qx3f725J4mOeOMwbbzxRiLaOI8/zXpZL+uFLPxONscbqWjjXP40nR7k4bA3Xx53Sm/Wu7/e/HPLPd5IQBsdbySjjbP4
06yX9bJeyJbeAAu8kY42zuRP0+lBHg578+Vxp/Rmvfvrhd6S8sYbSWij5Y2EtHEOf5r1sl7WC9ny++atv0pIG+fxp+n0IA+HvfnyuFN6s9799cLvZOt4IxFtNPWINw7Txhn8adbLelkvZMu0ocuON27mT9PpQR4O
e/Plcaf0Zr376y29ARZ4g1AbmCLKaHSMNka8kYA2Pt+fZr2sl/VCtkYbHW/czJ+m04M8HPbmy+NO6c1699dbft886BlsGC1lDccKIoVRpmmKPbTh8UYS2vhsf5r1sl7WC9k6bbS8cTN/mk4P8nDYm7N7pTfr3V9v
mTYaYflANELUWhlDiKwkqwrW1FhQZQTdShtvvJGINu7ln7Ne1ruPXgxtfL7/O68e5OGwN2f3Sm/Wu7/eGm043jDM8gBhVCPBSaEQKXDJES475thAGx1vJKONWP8Xenv7dNu/n9238Rtkh63/uW/u/Wfu23H8QvGI
t/u0R1nvznpxtPHZ/u+8epCHw96c3Su9We/+euu00fdvNELVhqqaYV0yvMIcC7TR8kZC2ojzf34rv+V96svnOapYpo2xnjvWqe61u7RHWe/OerG0cS9/mk4P8nDYm7N7pTfr3V8vhjYG3miZozJEVSvMsUgbTdXx
RiLaiPF/W2jD1yN42C6r+jamDafnv9H9qN2jPcp6d9aLp407+dN0epCHw96c3Su9We/+enG0MeIN9ya2ZeZYoY2ON5LRxrr/20Ybg94rN4RVfZue9XykpI17tEdZ7856W2jjPv40nR7k4bA3Z/dKb9a7v14sbXi8
4b/9NcQcRGlBlmij5Y2EtLHm/7bSRq+XijZQp5eKNu7QHmW9O+tto427+NN0epCHw96c3Su9We/+evG08cYb0zfOh5ijVkrU4XeyjXjjMG0s+7/4WaLj8Y80IymOcEAvHW1cvz3KenfW20ob9/Cn6fQgD4e9OWte
gvWnk8+OhKyX9dLqbaGNjjcCT/daYY7Z55Z7vJGANpb83/a+Dafnj39M53Zuow3QS0kbV2+Pst6d9ZxnYQSCKCE42jC4DRrC5/u/8+qBLdPGZ/NQ1st62/S20UbLG4vPEo1iDm9FyhtvJKGNsP/bRxu9ns8coa1v
Pm2Mz/XHU/atgJ2LXzrLelkvjd72vo07+NN0epCHw96cJYkfgiAoBGog+LeFVD8fVFMtCAR37FXyL+udT28rbTR8hjcmz9tQ2NQKj5iDWuag1tc0io/Xv3a8kYg2Qv5vL23Ej88s28Ac120/sl7Wi9fbRxtX96fp
9CAPh705Oxi/lh24gMAkBMmlkEKrNnAIspb18yFrRhhllBMIR5njquWR9Y7rbaeNGd4IPN1LIVMpxLi2/2StpHT0bH9IF7oc5my0vJGMNub93555G0t6U1XfQiMp/fPDVpOwybJe1juf3l7auLY/TacHeTjszdkW
PUsS4NDdFkkqqeULzYz7p2pTKKmMsQxijGlsUEbbf8JwY/192+lBWRu6fo7T51/WO5/eHtqY8Mbis0S1NKWWmkBQymJzA8RBG2lko/UbbySkjY/zz/F9G3F6ey3rZb2z6e2njSv703R6kIfD3pxt0nM9Em1BKK0r
XVNhkUMpDIEwye0dEmGmtD7ZSFM4H6ypqbXQTcsbJTCKZG68xdfmpI9lXcNfsH0N2N6BydrFm9Lng9K6/Wsuce6bQbkPoABKcJblp5rSdOXhtPsYTeszpbiLE/zuazzCMXM583zUNSfTlEJe9eW4rDH+Fvqbxt/7
+TuN8Z76dySE9PbRxgtvRDy53BQQXG1nmiNdVKouVd/DgTreSEQb1/TPWS/r3UfvCG1A/73z07jrJ+xtiw/9DH+aTq8o9tNGMH41BEUg1AqCaYPz9qXhDFc1lgWp3MSNQvIC4VrK8vkgEqb16m5eh6+6TBt+O+6+
hU8gfqGW1bWcuEvj8O1Se7y/PIAD+jwGTTz7/hkXJ/d9PG1AjsDoU13D9eHrudpb16Dm8nALbUD+9d/HsN56+JjrYy9tjHgj+j0p1uVIoxlnjcHMWOagwxzRljeS0cYV/XPWy3r30TtCG+A5nw/np3sv7fyz4w//
83P503R6kIfD3pyFlBSHiRf2/teoSlVSKXtXJ7m0rldSKaSEd2tK1oKHNq0RLTWVZcUrJC1OlIYUwnKGNS7AUZvGiOfDIAjxtOF/PrTjfcv5fIRaVhdcq77cp3CsPELxW9OLoQ33CdRS3PXSrMVvG21A/1DMefHh
I66P/bTh8camt7KF38lm9RLSxvX8c9bLevfR20cbfgsA/ur1Xs3diYb62j/fn6bT61O4gzYEzOJU1j+7/7U9UjGb28jme6FLRWBLBaw2cf0cqjFcV4Y0leGNbqdtSGM/LSo4rW5kTRply9dyS+Fce6jM/BJzd/bT
3qi+fYT6Em4hQy14UcyPv0B7vo1B19rpUPnG08Y4rtPrze+/2UobffxS0cZHXB9HaOONNxLRRlP6vBHl4FbsWv4562W9++jto4218eljvvVKvAF5OOzNWUilpY1KKNE8H6Jh7XwBJgv7P/PeIskIYojxAoL1vdx6
Yd8M/LPMYUtKSF1KBG79+WCNYBD83/NpYxrLaa/BUIbQv7GVNqZlP/R6wfhC/FjbOrnOl288bbzGddBzvwW/7dhs60jKoJeONt7/+jhGGx1vJKMNnzeOeL3BruSfs17Wu49eCtrwx6eXvO55/Gk6PcjDYW/OQhpK
2W0thOUN/XxwiWipuUKybLgscVEJZreFRGVdIG6LgnbM4fo5jGfuE/dtuyRWt/0lLytgl2cOTHs4/DKE9B6lDf/4tfGZ5V+IK9898zb60ur1QuNERasxHSkMkRFcH+lo472vj6O00fJGQtoYeCO9/8t6WS/rfZRe
GtoYxqfjW4jP9Kfp9CAPh705Cyl0tMEEmOU162Br3iBRNgKXqEAtZxSqKGVBdUNrgiVlgiHGaEk0we1EUlSrWtiCauC13kAbPWVM0xszSzTcNk/7r1zYOm8jbnzGD/5MoGkPTLh8t69J8VekuOtjyg2+Rt1qzpX4
kLt97IGv5o4943zq47TRsBneOEAbPW9s9XJhu4p/znpZ7z56x+dt9L7V91dH5m18hD9Np9encAdtGFjhKpCobFAVse2RFqXN7kLo0vpVaUpmaaNBrDBNAc/2aqishIUK0U4IlRYzGiZqjhSCBSttL4kKp3eZNlxb
7pfYWv/VnjUpfZsOv9Ov/4irG/6alPk1HW79zNKalM+rL2vre/aE97s+UtDGDG8cog3HG+n9X9bLelnvo/SOrknxe6Bdf7v7Zu+alI/xp+n0IB/73Ji30Nnt8zTg3TTYBoY0snpClnVBFCqlPa8uRVEYUSFUN0aV
smoaJaS2Wy5ZA02BbRGs85cKt7ShhBHNa/yGsDxvI0QNw3ev9W/5eRv+eaGzjq1PmavPS7T0mf1r28ePPjZ+Y719tCGVFJKJkmvOOLaexPKVxWIGz4DRjVaist8UouAVK+2RSGykDeCN0DW2z7Je1st6H6l37Hkb
sPWfttHHb2//8Ef503R6RXGob4OIon0XHrO3bUjy56Os7BkFsmoGlbwoGkZUTZvGEFPYbaEtZ5haK7uVBjVa17asKqtVCHj6KHqN39nz7/30to6kXD296fT20YZA8KL5hlhmKKC2agbzhzhjDTecMmUayx6WnrVR
nHMmKdpKG1fwp1kv62W9eWMdb+yjjev601RhGA84SBsajlRVYVo9ASMpTTtvo2kYI7JpdCVN0ygihN1W9r6wUQVvGikaeKI50IYsZTVlu3PnX9Y7o14MbbRPzHfPzVcdbVSihBpp92lTGWOoIdrWZ10BHVs8RoZp
akmk0iVXzFD69nSvSmlTG6ybNdo4uz/Nelkv64WMdbyRjjau4U9TBVcew/6chc4d0Ya3fT7sFrXjK3Ub4M2vyt1EWqIoHVW4Z39JIqVUljYaXUoMTyy/Vv5lvTPqxdCGxEIIaX1EqUpbP7FAurTgIe0ZzLJGpRvN
lMVkSZ4PVUstS1NqqnhTG2G/4VLZsypOqJG2fjPNbdWlq30bKf2fe58JzG9fOop6q9Gn74mde+t8Nx9ODr8ROiPu233pDb9xzumRgL+aSxFs52Y4g1XG6YW+n76Lbvo7fr6m1kOFXx7+1s8hvySW33Mz1pvWCBez
0Hv95lTPzAdp9VjHGylp4wr+NJUS5KE/X3TOgmeXMEvUMcdoC+tX2//tMXW3bZ/N0T8PDEpk/BwwoA2F4CHn18q/rHc+vb6/M0Qbth5Cpwb4BtQ07RG6nQNaWzYoLAeXQtu6WEhtCg3v8wEeN1oqbqkDQKXm1DTQ
w9FgQzWy+0gJhWXFgV6QZMu0kcr/9bQR0pu21yjw7Ss1gJ47dtqm+61O7Lfb0uvOC/FMrzdliGUOcqpTBoAYg1462kir15fv9IxQPq3Rhp9/oRoxpRCfWl/tvHyQVq+fteF4IxVtnN2fptODPOz1Qnl8p/Rmvfvr
9f2dQdqQutbE/odl/6Q5AetLLF8oKQw1lUHuY8vGheUSpJrnA4ZS2sfRMUMMtsxBOG2IkZq3zFELwRumNLFHqzXaSOP/BtqY13Pf+G3SaysW7iEIx8+d4auGftNvb+PSu0RA8/Hz22A/ZiGbajsFWK82f8Ye2kip
5z55PkL5sYc22vmOk19azr9l1bPyQVq9YY4o8EY62ji3P02nB3nY64Xy+E7pzXr31+v7O5dHUhQ8U45amoClUNxggy1rUFk3MIuDCiZqYSlDaQVHKng+v8DccOaYQ5X26NoIAz1zSDJB20+iRlJS+T+fNsZ607vU
UCsWbtND8fPPc789VfX3+29j0hvqf4iLX6gdXz7G7YfHo/bRRjq9nutiysNZDG30elP+DOXfsupZ+SCtnr8ixfJaQto4sz9Npwd52O+FyqPZGay/331u1st6e0M/a6PjjWnfhoa+DdFwIwotLEloTZRFBXuw9Rr2
u9IyCPiP2n/aBowP2mNY29+hLGUY6COxNFJqbj/BlkUEU5JJLCL6NlL4vzFt+Hp+u7FMG0tb0PPvdKdK7hfc9jU2/f7QDq6nd7m/5dVe9Y7RRih+e2kjld6gOox/hOZwOIujDX+8bDlmMapgZ+SDtHrOszACoZuf
WDragLsVGzSEz/Z/59UDG7hjvjw+kYcotXV82LbrXV4+O7LNenfUG+aItrwxoQ2FJZJVw4yBdw7b2xOuS4VVpWDGsmx7O7j1IOSFNoyyeoq70RU3o0ND3wg88ato32jMtRZG1JzH0cZR/zdt3/v+dr9NWJoPEG5b
+vEAv+Uf2tGxts8IyyMba+ndRhuvekdGUtbGo/bQRho93+b09tMG6KUaSQnH74idTa/r22CVzSNe1K1e17chqb26dQWl+9n+77x6YANtzJdHkAXgUaHF8tbyRsRR3XaVNlq9hLk3r9cwCQPzEzPK2E/hGCy26KWO
X9Zb3vorUixvTGhDMoFE3Zj2iLpljlrDkIkWhShMafmDCiIKDgcY+0W7hRUocD/TjaTgdhappRWDrSa1VKEa0cAqlYbTWNo45v/mehOcnt+WhVqx5dajb8P8+IVao9Cql2n81tK7ZSRlqrd/luh8egtPLz7/Uuu5
z/sS9fX8Xwophebxzo2/LedfDG2cjw/S6r3SBuilpI1z+tN0emA+bcyVxzJtGClqxP3t+PPnI/TN6+cxtKGtP02Ze3N6jjZsi8MkGX3e6IoQ2zJVjjli9VLHL+vF00Yjp7yhjIR5F1oIoWUFT95vn7DBpGzXaGtZ
tKtdGax3tVQBT9UXirv5HMbGz1QG1nAXQtmzsIEn7hOBJJEWUSWH/+Np44j/81vzoS141Vu+Zw6tMx14ZdB7/aa3aZ/H0i8vpXd5VcS8LaU3bgXs8C3B0/EK/7zlEYz30XstoVe95TNC5Rsuj1D++dslOxcfpNWb
0oZiHW8koo0z+tN0emBj2piWxzHagPe1paSNz+sfMooX8MwyyxoSPiHkXPHLem77+rSNCW94TxFVRFLJjTDwhI1KlQrDg0VF4fo5VC2V7OZzAJ9IKUth4Pn8TWmMkfCyH8MlHC3jniWa0v/5tOH3z4/1Ynrol+2j
/X1oFY1va+txjljWm7O4vo14vXg7j15HG7yqLG2UdenGUVreSEYb5/On6fTAXmnjtTyO0gbi9n7wMG2YGrbQiw3PW5r2PLitPwriH+P6JWZGR9qeinH/kP9Lo4ORrrRsmKON9n21/i97v9D3t/u/se8XHOG07web
/9XJqE8e75k+2+uFNzzakNRSRdUQ4AKNLE0Yg3WtqaUIYohlESWV5QwiYawFyhF6QWg7HwSwRMNWIsCW/bSR7vlXc3rHaeNz/H3MPfaW9S6p4/ej6cXTxj3SO2fdLFFcWafMGbzTSrUG6+OprYy6XqQN47y+EbxY
9tjn8qfp9MCmtDEuj63zNmRNtN028KqZfvt8+H/Nb+NpA/pzXmmj63loXKv8yhkz4x+u7BGUvesfIsSvD9o2OK4P46VlZ45khnZ/7he6/qbRb+z5hS5V8D7SF9oY58c8e4W3Z+pfS6039yTREW/4tFFzwY0bSbHM
YRlBSngXMTyDTgn7adk+r5xroZEC+uDwLFwjLD8z070XVjB4EinQian30cZ5/GnWy3rztoU27pDeOXOexXGGYLWxHodAUF37tkwbM+2E1xrMth+n8Kfp9MDmaMMvj619Gx07MKb9LehJRprpN2+fb6ANYdvfvn0d
feO14LEjH24L8evb9vl+hOm3S78w39+08xdY2/8ypo1FpfXtefrXUuvNP7fc4w3/fWwVEIHk0MMhteUGaYwRBpCDC9ndfNTw6FFZCSJg9UljGslkaetfKaRAljPgLbH0SN/Gfv+X9bJe1vsoPedZJCUE7pCJJS+3
8lVjSlp/ReY90vKdYYMEc62Iow3XipzHn6bTA5unjaE80tAG6KWkDTee4j5rmXHSH+X3dkzHUDrz+hHs/eoinwRZIPALb+Mp076Krb/QfgLpTUcb5+lfS60XekvKG28E3gHrB6WkUYXikkupDMznsCzSyLIhQ7B6
m98Bm9r/Zb2sl/U+Ss95FjdqohpaQesHwfVpWH8Voo2N95jn8qfp9MBCtNGXRyrakJaH0tDGpD2H1nwyLrFSxk4POXqBdt+o52Nvz8P8L7j+pvFvHPkFiF862jhL/1pqvfA72TreiKAN/0kbXaBt8GijqUe8cZg2
zuBPs17Wy3ohc57F9zXuqVVr/mofbZzFn6bTAwvThiuPzfM23FyMliBet8N4ynS7tW8DPh/6c0I9HKF5G26OxOvxoBc6I1Qrln7h+Zj+xmpvzALPAG+ko41z9K+l1lt6A2zLG8loY8QbCWjj8/1p1st6WS9ka7SR
avz8XP40nR7YEm20/SXJ+jaAKeb0pBGCVXtoY+jPWS7RmTUpL+Nk/ZHwvk93xuvc4em4SMwvuPjNzRkJrZOZmyU6pGotfjFrUl7Sm7D2nUFv+X3zlg8S0obHG0lo47P9adbLelkvZOu0Me+v9szbOI8/TacHtkwb
C88f30UbYz2LGbJq3Ddufytt9P053XqOQJlt2X5ef1Ncf4XTS9O38bnpfR895xPS+JcYy3pZL+v9CHoxtBH2V1vWpJzJn6bTA1ujjSBv7KQNp+fYQpW2oaSm4gZV3b7PHAHaeL2fb+dvBPoc9mw/q78pliDW189c
I73vo8dWA7yPPmXIelkv6/0oemu0EfRX0c/bOJc/TacXRxsB3tgxb8Nu21GTfn2K44yOVdp9/6j4NN+jvyl+Huo90ns/vXnvEy5lowTjH1i+rtd262jbsfyL4eJj6Z0dbzx5fUlVEh99fcTU8M+M38fqhXLjLPE7
l14sbaR5v70/ggLPf97St7G2vU9/U9a7rt4+X3zd9Ga9H01vbw2/anqXt+HcOEf8zqUXTxupecMfT4mZt7G+vUt/U9a7rl462rhGerPej6a3v4ZfM73L26XcOEP8zqW3hTbehzcgxKxJidneo78p611XLyVtXCG9
We9H0ztSw6+Y3uXtcm58fvzOpbeNNt6PNwJhc5rv0N+U9a6q13S8cdb4Zb2sd1TvGE9fL73L27Xc+Oz4nUtvK218MG/sSPP1+5uy3lX1mo43zhq/rJf1juod7b27WnqXt+u5ca/0HtNbp41mEvr+4lQh62W9rJf1
sl7Wy3p31tvet/EJ4ylZL+tdQs9dU+eNX9bLekf1+jp+1vh9rF5cbtwnvcf09tHGcvxYxZWoSWn/L2O3z8f4M17Ca7/Pn3+xgVJZawyZjG2OSnhfGz1T/LJeCpXB95wzflkv6x3VS0EbV0rvcojNjbuk95jeXtpY
ip8ptNES3gthTPz2+fD/csxx/vyLDa+0Qem54pf1Uuj5vueM8QvrufpZ165+aszJueL34+gdL4n3jV8a2rhOeSyH+Ny4R3qP6e2nDV09H6qRXBPFWKUZPBRRC6VZo6UylhSk0ryAT9yWGc2Vslv4FnVbriQzikpG
yfj98cdp41zlMaWNc8Uv66XQG/ue88UvrIcLqKFQL/HuluRK6T2vXoqSeM/4paKNq5THctiSG3dI7zG9A7SBNbK8IS1nKF5pYdtQ2CJh2q3FC9UIoqnSotC1EpxrpIgljFJVzLKGKhlRUhqqJRGUCMMNsfHjob6N
ufZ6mpq65gR38fbHK+Bc+B6uZT91cE27NLojxsFd+cPRMN92eob71WnOcQJ3KH7sizb2Y73psX4A5bmyqa3h4vUOCMrX7bljpmcs59/H17976b36njTjb0OteX1/1LQu+vU8VKfG8XNn4PaMab3wa1NIb7jq2vno
E43plbt8LQ/fPh/j77fW7derfsi/5evepWiaXv/34a/no65D30+vWfi+nvm1Ia5QHtOS8GvBVGPpW9BbPntbAL2ttDHv+Qb/t68Oz6dquN7259lrepdDfG705bu1DVorj5ThvfWK4gBtOD2iODMdbXBdCGmINpIY
yx7CGKSpoKbQFW+00gWnXf8Hs2dRXamKalVLQqkRplKy79/YSht+qzzQBoxXLNfdWL/S18dx/oXOdr8JHtDFkpNQ7MPxW06v4yDn09wvyO56c0rTeyP3qZ83e+rL0XBvvanv2avn12e/LMd60/vgbbQBeu6XQh7P
j8dyu9C3HyHfvoc2cOF4yH3S/1JM3Q7lQ59/Mde9f3VNc8OdOy4P9/00fjF3Su5cuD96zeUjLSfopaMN0ItvX0N1eKy3rw6HUjUejzpKG+vXb3xuuBr3fPgp2nq1bo/fufSO0oa2+acU51rqyuad0EiWlioq0dj9
UghNlRFY1/YYqbFivG77NnTbt2E/lYpKaURDsf2cibIpYf7Glr4Nv8Sm9zg9b8R4tun9xNxZLv+2jq7G6fnf+34v5L/83+8VHG/Ep/Rz69+99OZ8z1a95XJPnV5oL12rMO9znY+EKwvqzfxdN8QRdx7T3e8XK21t
PG04Ht92xvLxoettmiJIO3w+5EyfG5Af7hi/fygc4vtlQe8oEbxnfXl7ft3iUWt1+P3i99F6MbQxvnOdlq8r9ynbnjG9x/SO04Zqng+hLG1goVvmIG0vRWmYKaQwRCuJDdZCSFNoIirdaMRVO28Da6Ykgz8MbSyL
UF7374+Ppw3/3sxR8qvXgfSGuMD9hbuaEEMb0/7JkPn3Wmt6oXiERoCc+TV04A/X//ya0r20ca36/Ll6875nm956OaVJr6sdrr447zeuL37Ncy3u9C7UfeLuygaf6cZTBr1jtOHGQ5fpPvQL88cvXW/TFLn9Ibf6
T4dzX9eXvY6/9hZqd31tF7+9M0PnQ8rro3+ewvJR23zNea7f7XoxtLG2HnG/Z/749B7TO0wbtS6l5QPLGYUotdZUCssTTHK7X0s0msNBlOJGV4rZqwl6OBplFGJ1O5IiZCMRlf36lBjamI52hLwOtL+p+jZc/i1/
/+o/wiMpcXrTEO7b8PufY1L6ufXvXnoh37NFL+ZOJ0V6/XZ1Tm9aw/zW1x3jt8h++z2uf0dpA/on0/VtuPybfj+lK/8qduMuobSP+++3XmN+SaQr39T1xYX++U3LR229Wz9vetf09tDG63rEo7Rxnfw7TBsQCs3a
8ZRKG81lY7ShShhpKlUbbkppDH2bydGYUlNLHsbWQaO1anht+YMyoiqYvdEYGzQpn4912hjGcPtxzrAPceOD8fM21mqAy7/Q2aGYFa3e3PHO/8XPF5rO2/DTA/V5fvR3b52+Sn3+XL2w74nXiyunkF7MSPC0XZ3T
m9bhpfv7PpbuO3f/1t/Hh1ggdDXMtVX+9Raa2RBih7mr3o0f+d+Eejv8OeD+qMqYEZbHZ6bzuMIlsbW+xIVUenHPr9vua3y947MZPi7/9tHGWO84bZy3voz1ktAG1hTmd3J40oZQlUFaqdLuc6ksVRBJ2nEWWAHb
CNatUnE9HEjVrFFaFczmsiCEGWW4bvrnffm/4ZcJ+DPnc+LGP7bMB14euxiO7+d3zq1JmVKAH7O69bevx7/2P7sQ6pX1R2mm5eHuL+fWySyf9/H17156S75n0PNbbVkPoxTuu+X5kGvxi59h18876M+Zzh933PA6
ew93M6Roa69XzxDrvj7P3QMsXw2935mur/BjFlO3Q9fyOH7u2NBs2dB9+uvnw/hHaB1ZiJJeS2J//VsKafTinl8XW4fn45eCNj4q/7bP25iunzk2b+Nj03tMr0/hQdpgygjoX2uAMJrCCI2MMQxgwxBFDTdIFYbq
RlJTafnWw9HYvNXtkzlKhSSm2B7PdOHGUcL9TW7G2tYeiS35F8ObVyjfbSn6zPjdQW/Z9/R6MX0EfosVmsE5N58/Jkw5Yi5+r96xDz7/hq5AN/7i9NLNQQiXx766/fn1JVQSZ4nfNGx5fl1MHfZr8BnTu6a3dU3K
eLwsDVd9ZHqP6aWiDV3KSmsbv1oWBmujmEFaq7a3Qxqvh6Np53BQTSxhNO0qFaIahZmUUhha6lppwfpZG9P+pqIjjde7GP+YtfGPmHCsP3t/ebyf3o/TX/d5emu+Z7qeKUQbLiw/vwH6r7bdD4VGC8bxW77XWl49
OB4b+Kj1Fddbb7VWEp8dv1DY/vy6tTrs17LzpXdNb9vzNl772dz1u/95Gx+f3iNh6L8/OpICcy+00FZPFE1ptBZ2K3RtjKHKGGUqRbo5HERrWberVHS7SgVrrQsulJSaFZoqxfUwR/Tc+XclvRS0caX0fobeuu8B
Pb8k4J7GeZuPmI++/GyN98q/NDVvKX7XW2+1XhKfG79QSP38urOnd03v6JNVr5beI8Hx1bC/mzYqG+A55Jrb+60GG6OVpQ2lqWkM10U7nsKNNBhWxupGMlN34ylE1NpoxN0TOCrXz+GvSDlz/mW9rOeHGN9zp/Rm
vR9NL93z666R3jW9489xv1Z6jwRHE8N80d204YLWWNQ1PN8HVcQoUytW46qpYGVKIU23bzlDlt1+qWtRuX1tj2ZKF/Dsr/EbYM+bf1kv6/khv386691bL8Xz666U3jW9FG+NuVJ6j4SeJvr5ogdpYxQ/LjiGZ3ZB
2Lp/lfzLelnPD/n901nv3nopnl93pfSu6aV5R9110nskDDTx+r6nY7Rx1vRmvaz3nnr5/dNZ7956KZ5fd6X0rumleiPuVdJ7JAw0MX2/5DHaOGd6s17We0+9/P7prHdvvRTPr7tSetf0UtHGVdJ7JPi0EeKNZrf1
73NNZVkv651Vz9QQ0untsayX9d5Pb72G3yu9ywZ58XxsveKX7czpTaE3po153vjM+GW9rHcNvT20ceX0Zr0fTS+mht8pvcvmcuO88Tuj3ittzPHGZ8Yv62W9a+jto43rpjfr/Wh6cTX8Puldtj43zhq/M+pNaWPK
G58Zv6yX9a6ht5c2rprerPej6cXW8Lukd9mG3Dhn/M6oN0cbr7zxmfHLelnvGnr7aeOa6c16P5pefA2/R3qXzc+NM8bvjHrztDHmjc+MX9bLetfQO0IbV0xv1vvR9LbU8Dukd9nGuXG++J1RL0QbPm98ZvyyXta7
ht4x2rheerPej6a3rYZfP73L9pobZ4vfGfXCtDHwxlZNLZ0yFjzYX1IUkhAy1g6d54zbz93x7jhI7/QMLeE49z0v4Hv4FM50KYFfdd8SIon7tv8e8g/OT6X6fLgjnKr7HjS1nKYOCwhuH/LFpVS2ak6PkKE85n/P
Py8U17nymJ43NT8e01T15eGnbqq6Ne3vVb5+nENx8s+bntWn1/9rH234KQw/X2/fteLi118tx/Oyj5+fK0dUn49pGR25Vp4Pv5aGUjE9LxTXufKIuVbi/J9fUvDbLqV9ylw+LKdnnH+hmMXX8LX2I76Gu98M1+d4
3+DM1f8+flvbiVAu9noxuRiTG+H8W06d+034PUn8WIJeGk/f6x2vI/Db8i1+02vWj6Uz33fB3yHa6K+P5Vz3bZpm3/f05eHHyOXnss/y88KvS1Cfl87b2ho5fklHG1j0+Qfn++cte9YQbQzlsV4H4/yu0ztOG/23
oNf/nq+6L+0fV76h1hxiy4O0MfYvW2lj7lp5Pvyr5TUV268V5w9celLUaldfUtEG6fhgXEZHrpW+vmyjjfC1MvVX+2ijz5NQexRK79pV7Off+Mp5jUFcDV/mja01fK48/NoRE0uX9+7zNX8QaidSl284N5bzbxoP
P/ZzsYTyTePp3fdDe76/jvg57fRcXsOx8Nl82ThrPw3ShtNbznU/XstxH5cH6fIJjlu+xwnlJ/wm6KVrjZy/T3lH7fIPzl+u07F1yemt18HYXxv4wP9+asu0MVznw/3MnthMfeZ7lO9yW7bNhvoc74uXrpV5f7X/
WhnqS5paDXrpaMO1R9O07L9Wer0ttLH0a6CXjjZC5buXNvz8i6f7JVtqL7fTxrQ8QrUjJpbh+jL83lxuLeXinvJdyo2l/NtOG5DeVJ5+uF913x/3go5f+p4O36b9S/0Zy7RRrPavOVv2K77N6S33wIdKyaXE+b9U
rRHcD75P//00FT6PxZNrXP/aco6Ox3uO0Ib/OVjfn4PFcipi0v5e5Tvt7Vu2UE121tfneF+8Nr6wfPbWa8X15/RXS+rxwfcZnzlyrfj9dXG0sZyjceMVvi3nyVz57qeNIf9CLVCMxdW/PbTxWh5+TmzN1/H4THw7
kWI8Kj43wvm3hzbWx3viPX1//+G+P+4F5/zzcv61aV6kjbj5IPG0Mae3v28DPnfzBablt681eq/++3GuD6NfU1vrJ4vpX1vO0XD/Wqh8Q7Th6rr7ZdiTpL//DdW7+LS/T/n2POk+j69toZzp63Mq2li73rZfK66+
vM/44PuMz/jp3X6t+ON5W/s25q6V0HhFqISW82SufI/Qxtx46PJ961oND9W/fbQxLo+jfRtL9WVP38ae8l3LjVD+7aONtfGeLZ7efevuV4/VEfetuzKn83PmxzXiaCOGN7bQxlRv77yN/izoH5/m95TeYphwrv/+
qGo/fy1s8WOO4/6w+POW7ioGvVD8prQBOcU7hYE73DHAB/HX7eeX75E7LjDQS0cby9fbnmsF+Gp63v68HOpLGtXY8bylNPp1vu+vC6di27UyP16xr4TmyjeeNsL5N3/l7Kvh8/VvL2345TE3lj/Q5Nq8jT5Vgz/Y
N2/jNRfh+piet5y6pdyYz7+ttDFuP9J4+kHvSB15jQvUvxTzNvqyX+ON2HkbQ3n4Y9EhDd+m9WBuPj8wGxz3qhGiXP9bX3XcP3RcdW58ZmoxvYNwD9f3R4R/L3R26Df7/rVQeU1pA3iCkNAd1Xh8Zl/a36d8+/Jw
/4dmY8e3fb1emnkbr/Fzdvxamat/R/IyvD5gn+p4fPD4tTLUF9nV0WPXypb1W+u08Vq+8bQRSs84/3zbV8Pn/P1+2hjKY5oTy7HsUz1cH3P+2beYNSnTXJxb77dsy7kxl39bacOP5evzNvd7enf0OH7xdWTa0zj2
B9M7qfg1Kf1vhfLv1dbWpPgpm66vOGZnWE98Fb1w/1rojFBtDvWMxo3PbLEz5d/U3Psgj65Jmfa3+37g2LVy7vw7r9729VsxtHHe9Ib1jtBGn38h2kgRv4/VW8uNqd4ybaSOn7NwH8Vn5F88bWyN3/J4a39/vjVN
S/bZ9e86euH+tdAZy72R7pgxbcSMz2yz8+Tf1I69f3r+WhnuZ5b7CWPtzPl3Xr3t67fiaMOPX5pVUu+df1uftxGuz1t7DuPid9S26a3nxqAX87wNOG59vHarra23Smnreu21EEkbn12+WS+VXqgOniV+19PL75++
q9729VvxNtf/fGRN9vvm39Gn5Z6zfPfqxeTG56d3ef7FR8dvG22cIf+yXtY7n15+/3TWu7vecdq4VnqXLS437pPeFHpbaePq6c16We899PL7p7Pe3fVS0MaV0rtssblxl/Sm0NtOG9dOb9bLeu+hl98/nfXurpeG
Nq6T3mWLz417pDeF3h7auHJ6s17Wew+9/P7prHd3vVS0cZX0LtuW3LhDelPo7aON66Y362W999DL75/OenfXS0cb10jvsm3LjeunN4XeXtq4anqzXtZ7D70t75/eZ1kv632uXkrauEJ6l7/fmhtXT28Kvf20cc30
Zr2s9x56298/vd2yXtb7PL3tz69bs3Ond01vO3tdO70p9EKMEWfT97FkvayX9bJe1st6WS/rZb2sl/WyXtbLelkv62W9rJf1sl7Wy3pZL+tlvayX9bJe1st6WS/rZb2sl/WyXtZLq4cZbFnwDVNb9eIs62W9rJf1
9upVBTZYMUQN5QxTTeuyKJrClKwkJeb188EMs3/QmiDcYIpW/Fvq+N1Vr+Q2iEKWuKQp9PZa1psz2s7apm1dp235UARbYtpt+74u926l54MEV5G9X/xiaeOU5VEXNSpKUQpht88H/O8+S2EnTO+d9FjBSFWoQtlr
A9kQW//aY0tdaiag5GnwneQH45f1Tq0nEG+4akhTWcSwzlQzYggn1t9SRrRpDH8+TGGENopzziQ97BTulX979RDFFCtaylpjhCpWqwIXNtvPEr8fW49ZguBMY27xWtVEUqoERVSrhgpW6YohJrRgApjjc9IbSxun
Kg/HGaY0AtdVXamiohV9PqQsbUjFHCdK7530gDMa66HsxVDwgktRFmXB0Qpz2G+tnoSDRIkZZsZU9g63oahEJWMJ47fbst576dkiBmu37hNRiZI3jWx4Q5vKGEONhQxdmVor1TTIMG39gSWRSpdcMUO79tB6DVVC
P4gpxHqMnG/szw3Fz33vPOjU67hP3LfjrdPDk7rrn7Hl248rj5oyI2yLJStpGzhbALhQ2P7bqxdrflvV599czsK2Mq9nu09CR/Z6vrmSnSqN4zFsx/bx1xujHW0gjIVEDEuJMKqwLSVdKdlUjDHN4Cjo5zgeP7/m
j8tjmmfOQjnHvP6Y3k7gr4AjSp8zhq1sno+KVcwxB2/2M0d/RS/X55i+qLGv8fXo4v1AnMcJ+atlgvS1x/nzvuVbNmVDpL0PorL2aQN6OKSGloTjGeZwvRmqVFw/H6hBjakwwcQoLLFsEDxaqqnafo56KS5zXn9a
vtvLdKrnl0fIX4U1fAU//2I83JrqCa7fXXqsopIqRW0lKDnl1pvqUhnrPlXDLGtUutFMEdlIomqppXUPmirewPNkhP2GS3uLJypOqJFUUAsiiph6sbY4G9PGNH7TMkGBb+evYdCb1ji/Vdz27YeVry5ZCXfOiHNS
KEQKXNoWrlxjjqPx83O0z789541taDNf9UJXb6hMX+2jrzeIF6ca8RIXgqMaM2H9ZVVIgrltF1WFWa1r6AFxYyv74+dyJlz/Qsyx3DI5vfD1dtQ26A2cUdW4xvYWBbZtYyRMu9V19XwAdRxljsFrQ/xCZ8ff0wz1
ckjva86OLdbjzPurvbTxvuULpMBoS4em5QwK/RySW7qQUtm7TaPgLhbxumMOxxm85FwggogWSFnesCfjEpeG2OKvjXTkATTC+FJM5lM9719CZbq9/Zj6q3UNX+H1+g15uFjVq/EGZtjenWmqS42axtKFbLQlDNrU
tjIVspal0AqpQmpTWOaArdFScUsdjWiE5Q1OTQM9HA021g/bfaSEBdWKS1sfxbJneKWN1/j5PndaZ+Y98nJ6hzN81dBvTr3HR5Yv4pVE3N42lwzHMsex+E2pIU7Pz9Fl1bny9a9e34vE2Mdeb6yxtEFseTRIC4oQ
roRCAiuJMHY9HMxeR9T08zn2xG+5ben1/PYr/uwuFZ4X+wR/5TjDOpwRZ5RwrywMtDNCuS00T88HUMcbc4g9zOHXKdu+LR4buu5DNXyc3lD7EO9xno/pb++njXct35YeYBTE3nZaU03LGbwQhZCy0IWWDfRwKIAJ
zOuSlIQz4Etd2iYHa4Ioos+HlsgGUyCDjMFtLSjW536EUh3299N83d5+TP1VjMZYL8bDxateizcsEXAkpJZY4u7xpaIhTW35QklhqKkMch9rpAtlNFINDKWAGWaIwdYfNIJw2hAjNW+ZoxaCN0y1oyqL836mtNHH
b9ruTWtW3B3wNP/889xvT1X9/Y/sn5zaVuY4Er+5PooYvVAfxVR1rHecNj62PDjM26h1wTQSoip118NBhaUPbGSFCVXKUHak/yDEEWO9UG9SDG2Mc/0D82/gjLpGNbKc0W7bFqZp52iobjswhwT/7Ho69vZzjP3H
cnpDYx7hGr5cn4uJ3prHcXrxZbpMG+9evi/MoYt2JEW2W1M0RWPL19KGqktaUsWh5JSBEtcITBNbvrYaaO5GV+LmmG4bPwqV6fb2Y1q+sb2wQ1z88Z6QbVG9Fm+AVQgLLC1NCCUMN9hgyxpU1o2CeRuc8dq2bxVG
qMEYl8jwijW2erWmyufDHl0bYQpdKiSZoLb24ZhVKnO04eLnl+sybSxvx/1NUyX3C247jY3bfy31zyjfLcyxP37zbdi63hba8PVS0MZHlgeHeRtYNUwiIsqSISVse4cteiDqRlUosxcO7tet7Imfy42leQDDeEAK
2viQ/HOcAfRgb4JrpgtSEwtr1usQW4EJRgq1nKGnzIHt/S/GqrC3Q9TWe0KQLuuy0orbxqoUZJ05XvMqYn7OZJxqqYbH1udYjwN6vs85RhsfUr6OOTjmljls0WqYt2fceMpbD0dVVoq0zNGuP1Ha9XOU7PkoGRex
nNH/INiW8aNpmW5vP0K0sa7hxxv0YmgjVvU6vGHZgSPBC9owe8uhlNKaKAsPqlFMUV3bG5ECa6zwaM6nY462t0PB2Ar0h+laaVVqi6eqHcSmGjfWmyz2Bk2vtr5/1y+NUM1abuPc533/pP+Z/3vIU3LH+npx/afH
LVYvljn2xi80d6kvD38bk09T1XH80tBG6vLg3OlxPre1N2Ga2ZaOmxIjKmyDh7QgqHTMAQuKwNmO18o6PX+1bNjWaeO1P/Yobbx/fYY2RlREktLUjFHWNNOtRxsj5qCcwPtN+fQMWhFqGrdmdsmmeRUzP2dLDe/1
pvek+zzOeP30Udr4MH/1xhyiqLTlwcbNGO3mcPjMYYPi7dgK7denbIvB9vGjbQQ5336ERlJiNPx4j9u3qW1VvQpvKCyRrBpmjGlgxqelBVsnlK0R0lrb28EtbcgX2mj7OdzYipvPYXmD2r9oY92sqZvScK2FETVf
nOsT6k2ozGg+Urvd6lnHV77TC/mM0Gyi+b6XQS+dbdGLYY598QvP9tzX/zxVHeuloo205QGzM54PilRJGqF1O+9ZCVZRqgqiWK3sjq3gojAIW+aoOuZQljkK0ihMaLc+trLkYaj1qxTaj1JK6GgmK2mLoY1xf2zo
mtgy3/B96zPMDRSNtzUtI3TbjjZgX0+ZgxS2jtf2/teb0THZbh7jD6U3VJOXazjBfn0efzNsfVvzOH78lss0pr58kL9y80CNvTZqmIWhKhg1U2Xbw2E65rBBoW5spZ3P4c7aGr8t40ehstvefizPEl3T8OOynN6t
qlfhDckEEnVjGmVD3TJHrZV1rloU1p2Wlj/szQW3HtgSBsbIbd3YSjeSgts5pHD/IQxupOUNZLVEA6tUGr54Ffitebi/fblmhe7HX8lw6L8Krd2cXrGfNd87xtaYY0/8ltaWrOstr9h6vXaWxsvWz55auvIotdMD
6qAw9Uhzy90c10riqqkrWVSk4gJ6/Izg1mVaHkHCbpndYruldt9CPCHSXlKWMkStCtt+UAbPTVmeyRRLG359Xl6nNc3FT+tvn9iINmB9ygxzONoorX8G9tgTk7j1C85CMzmnSv62H/+Y2n6PM4yX7S9T3961fB1n
NGXDiW0hKlXB2gNV48K6ohpWryiCGGJ23x5oKcQeacsUtqSdr0Hb/o1EIymv8Vsu0y3tx9YV+6H7qL58lz1cbMyG+KW099AjRV3WWGguuJaVJY+qfcIGk1JYYJBatrAKzKG45QqkDPR2uPkc7RzSUlrvK5Q9x/K9
aYQQRCDKKaGogjGYxU5OnzbC/bsxfYWx6U1pZ9BbYg6rt9E7L69kTTE+s6a3t28jpLffSt31H1jmII2Crl9uqz2qhWUOXWPLHHVlr5EKVbaVrIrKXitVWTUSVfCANkQEsZBiPR2lTUsZkevjY2lj6I89ck349vH1
2fVzONpo11Ji3NgbFmnvaLAkiCMuEbE3O252IaxP2ROPuPULy6slY+wM/uDD9VrOgI3lDI65ap+eYbcT5iCM2FYEFqgo2vZ8uC1DGmnVzhF9Pjg5PkvUj9/xMp3TC41wxNh4fdThKI3sWno1q2zbZYSBJ2xUtvix
sFAhCtfPoWqpZDefQ5WWQ6QshRHS3pQYI01j/3FYH19bjxv7+1N6m4tfKtq4WnnE2wxzUMscFJ6fgzc8Qnv52VBxz5daVvWt7y9OMZLi7D3Kw/V0vDGHbJmj7JgD+jlojYA87LasassZpeUMJu1NW0EZPPfItqlb
4hdPG3PrF47ZR9dnN7bS0YaqlaprVjNVtSsqcbsyFtlGiujK9XPsi1+418yvzymeNH8Wf/ABejAkAuuFLFBwig02lioklnY7YQ43tgLPCrX3oRa8NW8phHR9HsAcbmv9AYy9xDBHTE9oP76Vyub81VYb+7cTl++7
63HGSlY3xFYCC5yWJozButbUcgQxRBGYPGo5g0gYa6m16wWh7agJbzRsBayHLfiuO5D1+GW9ZeuYg2vEuKwtGlJqLI8b2mBYJbQ4g+Y947c0Cnmm/FvSmzCHaPs5lMS1pXSJKulmdbScYQ9iquWMqP6cFPG7pt6I
NkxtW52WOUgtamHJg9ZUVQxqdO1GWK6e3vvoAVMw6Z6/pixQVKUiU+ZwYyuF93QvONIyR0lLzaAHq+/56LfPB/wP9YIeaNMHS5l//XjZEdp4tbOW7/vriZoJZtxIimUO3GAphRBKY8WVsJ+W7RPLuRbakqki9jsk
kBGGGdY+EYxyzm3947gcHoGeMH5ZL8YqVLEKaQIB1hg9HwoGvWA6DUG0injC6/vG78p6A3PQAtiCK8scFTUK06r9hBWEl4XN4zI4hnWl9L63nk8bRBKqCeGk1tDrXumKUIJ1xRSTmrsZHh8dv6wXMnjCBq0tCLLn
w5C2F2rEHG5sZaaPwmcOGyxz2JMtZ0BvRzvyYv1VBatVyK63pUztnPmX9QoBz55lwpJnTRsiiLaVoihLBo8j757oZW9BlNGi5pSzgsPxtYQRV6qtv63cm1Yuk94b68F7rWyhMAjPh0VEBCuZKyQTdLufMb0fqecx
h4UKoplSgtGCc2Svh+7bz4zfdfRKVjIxsxp2tBWsaIqBNq6c3rvpATUwuL+01GGZA2beKDe2sjIW4jOHdVSWOWxQ3ftRzpverPf+ejXcL1eKSy6lgofYY1LUqK7OEr+sFzLcVLacqLC8UWhYTQTd/QnsrOn9SL2B
OfrtOmcs6R2xq+oBbcgCCSQkabd1aOt6QT46flkvxuD9YNDT4UZX3IyOqBPd8zkopozDjODhSTTnTm/Wy3pZL+tlvayX9bJe1st6WS/rZb2sl/WyXtbLelkv62W9rJf1sl7Wy3pZL+tlvayX9bJe1st6WS/rZb2s
l/WyXtbLelkv62W9rJf1sl7Wy3pZL+tlvayX9bJe1st6WS/rZb2sl/WyXtbLelnvJnre24Kej799/U38/nw8H/C//vpNoKL4+u1nRInd/uWPn7+XX+WX/2b++uXv2+0//PoX8Yv+Kosv//nLf9X62xfx5Rf3MXz+
5fuvX77/2Xz5Zn426rvRX/7RfPvX77/+9uWfzS9/fPn19y//8ods992PWuV/0j99d2qw9218dqf6dvD//M3G4p9//Tdj99xJ8Mf8SV/++O3tvH/89a+/9GfC/uq5Gg56O9t++924c9z+/FnfujO87d+ej//w/wG+
CSwM4bMGAA==
"@
#endregion

#region ******** $AEMenuCommandsrtf Compressed Text ********
$AEMenuCommandsrtf = @"
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
zO/Lu387PD/90919Obv7j58fvt5V/3v5+XR5tfpH8XL368Pj4115ujs+fP38WPz9dLx7Ov3t5e7l+TLfn54/fSqejn9srem3+89PL9VM9+f5/X/91+39S1H+/tv9P1avVv97/OWxfHyp/lG9+fnp4el4enqZXZb4
20spZv/99/vzwx+Wm9n948N2MTNV++7Pz9/Kx9Mf/vT4cPjr3aWmr1U+P5wej6Jyz59P8uV/+PH0eDq8XN7+h2orisfnn16ra6rnXx5++vnlzgEfHk/Fl8vrD9Xr92VvG9dtdPc/ik8n0c7/1Gpp8erd8/ny738/
PX37Pvul9auZvje8XFO1y+o5/vvDkwFU323vwtPfTodvL9Ue/PXn18ZprbBaXrbVKYP9WVVGNrm2I1+r+31f3tl35r+d74qnux/+1w/qtrUa6dL64h+XnVw31LfPx0LM+XDZLX+/K76c7p6eX+6Kxy+n4vj3u6+n
F8dH6H8/f7s7VOv99vV098PTLw9fnp8+VY1y90vx5aGoNvNr/cE6vFbiUeyp8tuLXFldiV+Kx2+XWly+ag+nL5dXTnLnfTn94XR8EHvq+74/Vu9Vs/78/OsF//Hl+JfTT//zy/Mv1cwv3748fb374W+fq9VV4o8v
Xx6efpLe17vqE/LlW1Wjh0+nP/ocMX48fT59KV6ev/zr6fz85fUT+Gf5Kb0rqsaplhVv35XVF6W8zHOpUfcD9/3z/B38l/PL6YvbK8QsLk77+/t08l/+P7vEZ7XfMwoA
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
        $Script:VerbosePreference = "SilentlyContinue"
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
      #$MyDMToolTip.Active = (-not $MyDMToolTip.Active)
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
        if ((Verify-MyWorkstation -ComputerName $ComputerName).Found)
        {
          if ($MyDMConfig.Credential -eq [PSCredential]::Empty)
          {
            $MyDMConfig.Registry = [MyWMIRegistry]::New($ComputerName)
          }
          else
          {
            $MyDMConfig.Registry = [MyWMIRegistry]::New($ComputerName, $MyDMConfig.Credential)
          }
        }
        else
        {
          [Void]([System.Windows.Forms.MessageBox]::Show($MyDMForm, "Remote System '$ComputerName' is not On-Line.", "Error: $ComputerName", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error))
          $MyDMForm.Close()
          $MyDMConfig.Registry = @{"Connect" = $False}
        }
      }
    }
    else
    {
      $MyDMConfig.Registry = @{"Connect" = $True}
    }
    
    $TempUCount = 0
    $TempSCount = 0
    
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
              $TempUCount = @($TempMenuList.Values).Count
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
                  
                  $CheckValue = $CheckValue -bor ($Data = $MyDMConfig.Registry.GetExpandedStringValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$Key\Command", "")).Failure
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
              $TempSCount = @($TempMenuList.Values).Count
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
                  
                  $CheckValue = $CheckValue -bor ($Data = $MyDMConfig.Registry.GetExpandedStringValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$Key\Command", "")).Failure
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
                            
                            $CheckValue = $CheckValue -bor ($Data = $MyDMConfig.Registry.GetExpandedStringValue($TempHive, "$($MyDMConfig.RegistrySubMenuCmds)\$SubKey\Command", "")).Failure
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
              
              $CurTreeNode.Expand()
              
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
    
    $MyDMStatusStrip.Items["Status"].Text = "Loaded $TempUCount User and $TempSCount System Desktop Menus..."
    
    $MyDMForm.Cursor = [System.Windows.Forms.Cursors]::Arrow

    [System.GC]::Collect()
    [System.GC]::WaitForPendingFinalizers()
  }
  Catch
  {
    [Void]([System.Windows.Forms.MessageBox]::Show($MyDMForm, "There was an unexpected error.", "Error: $ComputerName", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error))
    $MyDMForm.Cursor = [System.Windows.Forms.Cursors]::Arrow
    
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
              $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetStringValue($TempHive, $MyDMConfig.RegistryMenuList, $Data.ReturnVal01Text, $Data.ReturnVal02Text)).Failure
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
          # Delete Desktop Menu
          [Void]$ExportAdd.AppendLine("$TempHiveDel\$($MyDMConfig.RegistryMenuData)\$TempMenuID]")
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
              $Lines = @("$(((($Cmd.Command).ToCharArray() | ForEach-Object -Process { "{0:X2}" -f [Byte]$PSItem }) -join ",00,")),00,00,00" -split "(?<=\G.{96})(?=.)")
              if ($Lines.Count -gt 1)
              {
                [Void]$ExportAdd.AppendLine("@=hex(2):$($Lines[0])\")
                For ($Index = 1; $Index -lt ($Lines.Count - 1); $Index++)
                {
                  [Void]$ExportAdd.AppendLine("  $($Lines[$Index])\")
                  
                }
                [Void]$ExportAdd.AppendLine("  $($Lines[($Lines.Count - 1)])")
              }
              else
              {
                [Void]$ExportAdd.AppendLine("@=hex(2):$($Lines[0])")
              }
              #$FilePath = "$($Cmd.Command)".Replace("\", "\\").Replace("`"", "\`"")
              #[Void]$ExportAdd.AppendLine("@=`"$FilePath`"")
              #$FilePath = "hex(2):$(((($Cmd.Command).ToCharArray() | ForEach-Object -Process { "{0:X2}" -f [Byte]$PSItem }) -join ",00,")),00,00,00"
              #[Void]$ExportAdd.AppendLine("@=$FilePath")
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
              $Lines = @("$(((($SubCmd.Command).ToCharArray() | ForEach-Object -Process { "{0:X2}" -f [Byte]$PSItem }) -join ",00,")),00,00,00" -split "(?<=\G.{96})(?=.)")
              if ($Lines.Count -gt 1)
              {
                [Void]$ExportAdd.AppendLine("@=hex(2):$($Lines[0])\")
                For ($Index = 1; $Index -lt ($Lines.Count - 1); $Index++)
                {
                  [Void]$ExportAdd.AppendLine("  $($Lines[$Index])\")
                  
                }
                [Void]$ExportAdd.AppendLine("  $($Lines[($Lines.Count - 1)])")
              }
              else
              {
                [Void]$ExportAdd.AppendLine("@=hex(2):$($Lines[0])")
              }
              #$FilePath = "$($SubCmd.Command)".Replace("\", "\\").Replace("`"", "\`"")
              #[Void]$ExportAdd.AppendLine("@=`"$FilePath`"")
              #$FilePath = "hex(2):$(((($SubCmd.Command).ToCharArray() | ForEach-Object -Process { "{0:X2}" -f [Byte]$PSItem }) -join ",00,")),00,00"
              #[Void]$ExportAdd.AppendLine("@=$FilePath")
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
              $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetExpandedStringValue($TempHive, "$($MyDMConfig.RegistrySubMenuCmds)\$TempSubCommandName\Command", "", $Data.ReturnVal02Text)).Failure
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
              $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetExpandedStringValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempCommandName\Command", "", $Data.ReturnVal02Text)).Failure
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
                $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetExpandedStringValue($TempHive, "$($MyDMConfig.RegistrySubMenuCmds)\$TempSubCommandName\Command", "", $Item.SubItems[1].Text)).Failure
                
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
                $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetExpandedStringValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempCommandName\Command", "", $Item.SubItems[1].Text)).Failure
                
                
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
              $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetExpandedStringValue($TempHive, "$($MyDMConfig.RegistrySubMenuCmds)\$TempSubCommandName\Command", "", $Item.SubItems[1].Text)).Failure
              
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
              $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetExpandedStringValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempCommandName\Command", "", $Item.SubItems[1].Text)).Failure
              
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
              $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetExpandedStringValue($TempHive, "$($MyDMConfig.RegistrySubMenuCmds)\$TempSubCommandName\Command", "", $Item.SubItems[1].Text)).Failure
              
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
              $CheckValue = $CheckValue -bor ($MyDMConfig.Registry.SetExpandedStringValue($TempHive, "$($MyDMConfig.RegistryMenuData)\$TempMenuID\Shell\$TempCommandName\Command", "", $Item.SubItems[1].Text)).Failure
              
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
        return
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
$MyDMMidCmdsListView.Size = New-Object -TypeName System.Drawing.Size(($MyDMMidSplitContainer.Panel2.ClientSize.Width - $MyDMConfig.FormSpacer), ($MyDMMidSplitContainer.Panel2.ClientSize.Height - $MyDMMidCmdsListView.Top))
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
