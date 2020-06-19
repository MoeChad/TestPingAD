# Test Ping with AD
This Script is designed to ping a remote machine to verify if it's turned on. Active Directory is used to verify the machine is active before attempting to ping

### Functionality
1. Prompts for file path containing machine names
2. The enabled property is checked for each machine using ```Foreach``` 
3. If the Enabled property returns with "true" then a quiet ping is attempted
4. A custom PSObject is created and stores all output
5. Custom PSObject is saved as a CSV file


### Notes
- Try/Catch is used to prevent pings for machine that is disabled or not in AD at all. The automatic value returned is false for these machines
