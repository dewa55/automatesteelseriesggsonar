; Define the hotkey (Function + F1) to run the PowerShell script
^F1::
    Run, powershell.exe -ExecutionPolicy Bypass -File "<Path to script>"
return