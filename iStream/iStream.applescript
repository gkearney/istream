-- iStream.applescript
-- iStream

--  Created by Greg Kearney on 7/3/07.
--  Copyright 2007 __MyCompanyName__. All rights reserved.

on choose menu item theObject
	set theTest to false
	-- tell progress indicator "progress" of window "main" to start
	set visible of window "busy" to true
	set visible of window "main" to false
	
	if the name of theObject is "m_itunes" then
		--set stagingFolder to choose folder with prompt "Choose the Music folder of your device." as string
		try
			set stagingFolder to openstageDir("Choose VRStream's music directory")
			
			set myDIR to POSIX file stagingFolder as alias
			log myDIR
			
			tell application "iTunes"
				
				set selectedTracks to selection
				if the (count of selectedTracks) is less than 2 then
					set tfv to "file"
				else
					set tfv to "files"
				end if
				set filesToCopy to {}
				repeat with aTrack in selectedTracks
					if class of aTrack is file track then
						
						--if the kind of aTrack is not "Protected AAC audio file" then
						set filesToCopy to filesToCopy & aTrack's location
						--end if
					end if
					
					try
						tell application "Finder"
							duplicate filesToCopy to myDIR with replacing
							set theTest to true
						end tell
						set appPath to path to me
						set accconvert to POSIX path of appPath & "Contents/Resources/acc2mp3.pl"
						
						
						do shell script "/usr/bin/perl " & accconvert & " '" & stagingFolder & "'"
						
						
					on error
						display alert "There was an error copying the file " & filesToCopy
						--tell progress indicator "progress" of window "main" to stop
					end try
					--end tell
					
					
				end repeat
				
			end tell
			
			
		end try
	end if
	
	if the name of theObject is "m_text" then
		try
			--set filesToCopy to choose file with prompt "Choose the file you wish to load to your device." of type {} with multiple selections allowed
			set filesToCopy to openFile("Choose text or html files to load to VRStream")
			set filesToCopy to POSIX file filesToCopy as list
			log filesToCopy
			
			--set stagingFolder to choose folder with prompt "Choose the Documents folder of your device." as string
			set stagingFolder to openstageDir("Choose the VRStream's text directory")
			set myDIR to POSIX file stagingFolder as alias
			log myDIR
			
			try
				tell application "Finder"
					duplicate filesToCopy to myDIR with replacing
					set tfv to "file"
					set theTest to true
					
				end tell
				
			on error
				display alert "There was an error copying the file " & filesToCopy
			end try
		end try
	end if
	
	
	
	
	if the name of theObject is "m_key" then
		try
			--set filesToCopy to choose file with prompt "Choose the file you wish to load to your device." of type {} with multiple selections allowed
			set filesToCopy to openFile("Choose the kxo file to load to VRStream")
			set filesToCopy to POSIX file filesToCopy as list
			log filesToCopy
			
			--set stagingFolder to choose folder with prompt "Choose the Documents folder of your device." as string
			set stagingFolder to openstageDir("Choose the VRStream's root (top) directory")
			set myDIR to POSIX file stagingFolder as alias
			log myDIR
			
			try
				tell application "Finder"
					duplicate filesToCopy to myDIR with replacing
					set tfv to "file"
					set theTest to true
					
				end tell
				
			on error
				display alert "There was an error copying the file " & filesToCopy
			end try
		end try
	end if
	
	
	if the name of theObject is "m_audio" then
		try
			--set filesToCopy to choose file with prompt "Choose the file you wish to load to your device." of type {} with multiple selections allowed
			set filesToCopy to openFile("Choose audio files to load to VRStream")
			set filesToCopy to POSIX file filesToCopy as list
			log filesToCopy
			
			--set stagingFolder to choose folder with prompt "Choose the folder on the VRStream to copy these files to." as string
			set stagingFolder to openstageDir("Choose the VRStream's  directory")
			set myDIR to POSIX file stagingFolder as alias
			log myDIR
			
			try
				tell application "Finder"
					duplicate filesToCopy to myDIR with replacing
					set tfv to "file"
					set theTest to true
				end tell
				set appPath to path to me
				set accconvert to POSIX path of appPath & "Contents/Resources/acc2mp3.pl"
				do shell script "/usr/bin/perl " & accconvert & " '" & stagingFolder & "'"
				
			on error
				display alert "There was an error copying the file " & filesToCopy
			end try
		end try
	end if
	
	
	
	if the name of theObject is "m_daisy" then
		
		--log "in m_text"
		--set filesToCopy to choose folder with prompt "Choose the directory of the DAISY book you wish to load to your device." with multiple selections allowed
		
		--set stagingFolder to choose folder with prompt "Choose the DAISY folder of your device." as string
		try
			set daisyFolder to openstageDir("Open your Daisy/NISO book directory")
			set streamFolder to openstageDir("Open the Daisy/NISO directory on VRStream")
			--display dialog "Please enter your book's folder name." default answer "Folder Name Here"
			--set bookfolder to text returned of the result
			--set bookfolder to streamFolder & bookfolder
			tell progress indicator "progress" of window "main" to start
			log "rsync -av '" & daisyFolder & "' '" & streamFolder & "'"
			do shell script "rsync -av '" & daisyFolder & "' '" & streamFolder & "'"
			set tfv to "book"
			set theTest to true
		end try
	end if
	
	set visible of window "main" to true
	if theTest is true then
		display alert "The " & tfv & " has been transfered" attached to window "main"
	end if
	-- tell progress indicator "progress" of window "main" to stop
	set visible of window "busy" to false
end choose menu item

on clicked theObject
	if the name of theObject is "cfolders" then
		set stagingFolder to openstageDir("Choose VRStream's top directory")
		set myDIR to POSIX file stagingFolder as alias
		set info to system info
		set homeDIR to {home directory} of info as alias
		set mydirs to ""
		tell application "Finder"
			try
				make new folder at myDIR with properties {name:"$VRMusic"}
				set mydirs to "$VRMusic "
			end try
			try
				make new folder at myDIR with properties {name:"$VROtherBooks"}
				set mydirs to myDIR & "$VROtherBooks "
			end try
			try
				make new folder at myDIR with properties {name:"$VRText"}
				set mydirs to mydirs & "$VRText "
			end try
			try
				make new folder at myDIR with properties {name:"$VRDTB"}
				set mydirs to mydirs & "$VRDTB "
			end try
			try
				make new folder at myDIR with properties {name:"$VRAudible"}
				set mydirs to mydirs & "$VRAudible "
			end try
			try
				make new folder at homeDIR with properties {name:"VRBackup"}
				set mydirs to mydirs & "VRBackup in you home directory."
			end try
		end tell
		if mydirs is not "" then
			display alert "Created the following directories " & mydirs attached to window "main"
		else
			display alert "Standard VRStream Directories are already in place" attached to window "main"
		end if
		
	end if
	
	if the name of theObject is "backup" then
		try
			--set stagingFolder to "QQ"
			set stagingFolder to openstageDir("Choose VRStream's top directory")
			set myDIR to POSIX file stagingFolder as alias
			set info to system info
			set homeDIR to {home directory} of info as alias
			set backupDIR to POSIX path of homeDIR
			tell application "Finder"
				try
					make new folder at homeDIR with properties {name:"VRBackup"}
					set mydirs to mydirs & "VRBackup in you home directory."
				end try
			end tell
			
			
			do shell script "rsync -av '" & stagingFolder & "' '" & backupDIR & "VRbackup'"
			display alert "Backup complete" attached to window "main"
		end try
	end if
	
	if the name of theObject is "remove" then
		
		try
			set stagingFolder to openany("Choose the file or directory to remove")
			set myDIR to POSIX file stagingFolder as alias
			
			tell application "Finder"
				move myDIR to trash
			end tell
			display alert "File removed" attached to window "main"
			
		end try
		
		
	end if
	
end clicked


on openstageDir(theString)
	
	tell window "main"
		set theTitle to theString
		set thePrompt to "Choose"
		--set theFileTypes to {"txt","doc","rtf"}		set theDirectory to contents of text field "directory"
		--set theFileName to contents of text field "file name"
		set canChooseDirectories to true
		set canChooseFiles to false
		set allowsMultiple to false
		--set asSheet to contents of button "sheet" as boolean
		
		-- Convert the comma separated list of file type to an actual list
		-- set AppleScript's text item delimiters to ", "
		-- set theFileTypes to text items of theFileTypes
		-- set AppleScript's text item delimiters to ""
	end tell
	
	-- Setup the properties in the 'open panel'
	tell open panel
		set title to theTitle
		set prompt to thePrompt
		--set treat packages as directories to treatPackages
		set can choose directories to canChooseDirectories
		set can choose files to canChooseFiles
		set allows multiple selection to allowsMultiple
	end tell
	
	set theResult to display open panel
	
	if theResult is 1 then
		set the pathNames to (path names of open panel as list)
		set stagingFolder to pathNames
	end if
end openstageDir

on openFile(theString)
	tell progress indicator "progress" of window "main" to start
	log "in openstateDir"
	tell window "main"
		set theTitle to theString
		set thePrompt to "Choose File."
		
		if theString is "Choose audio files to load to VRStream" then
			set theFileTypes to {"mp3", "wav", "aiff", "m4a", "m4p", "m4b", "aif", "mov", "au", "flv", "3gp", "ogg"}
		end if
		
		if theString is "Choose text or html files to load to VRStream" then
			set theFileTypes to {"txt", "html", "htm"}
		end if
		
		if theString is "Choose the kxo file to load to VRStream" then
			set theFileTypes to {"kxo"}
		end if
		
		--set theDirectory to contents of text field "directory"
		--set theFileName to contents of text field "file name"
		set canChooseDirectories to false
		set canChooseFiles to true
		set allowsMultiple to true
		--set asSheet to contents of button "sheet" as boolean
		
		-- Convert the comma separated list of file type to an actual list
		-- set AppleScript's text item delimiters to ", "
		-- set theFileTypes to text items of theFileTypes
		-- set AppleScript's text item delimiters to ""
	end tell
	
	-- Setup the properties in the 'open panel'
	tell open panel
		set title to theTitle
		set prompt to thePrompt
		--set treat packages as directories to treatPackages
		set can choose directories to canChooseDirectories
		set can choose files to canChooseFiles
		set allows multiple selection to allowsMultiple
	end tell
	
	set theResult to display open panel for file types theFileTypes
	
	if theResult is 1 then
		set the pathNames to (path names of open panel as list)
		set filesToCopy to pathNames as list
	end if
end openFile

on openany(theString)
	
	tell window "main"
		set theTitle to theString
		set thePrompt to "Choose"
		--set theFileTypes to {"txt","doc","rtf"}		set theDirectory to contents of text field "directory"
		--set theFileName to contents of text field "file name"
		set canChooseDirectories to true
		set canChooseFiles to true
		set allowsMultiple to false
		--set asSheet to contents of button "sheet" as boolean
		
		-- Convert the comma separated list of file type to an actual list
		-- set AppleScript's text item delimiters to ", "
		-- set theFileTypes to text items of theFileTypes
		-- set AppleScript's text item delimiters to ""
	end tell
	
	-- Setup the properties in the 'open panel'
	tell open panel
		set title to theTitle
		set prompt to thePrompt
		--set treat packages as directories to treatPackages
		set can choose directories to canChooseDirectories
		set can choose files to canChooseFiles
		set allows multiple selection to allowsMultiple
	end tell
	
	set theResult to display open panel
	
	if theResult is 1 then
		set the pathNames to (path names of open panel as list)
		set stagingFolder to pathNames
	end if
end openany

on findAndReplace(tofind, toreplace, theString)
	set ditd to text item delimiters
	set text item delimiters to tofind
	set textItems to text items of theString
	set text item delimiters to toreplace
	if (class of theString is string) then
		set res to textItems as string
	else -- if (class of TheString is Unicode text) then
		set res to textItems as Unicode text
	end if
	set text item delimiters to ditd
	return res
end findAndReplace