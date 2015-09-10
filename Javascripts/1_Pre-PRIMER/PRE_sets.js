// Javascript to write out beam sets
// Date: 29 Apr 2015 

//How file paths are written changes with system type
if( Unix() ) var slash = "/";
else if( Windows() ) var slash = "\\";

//Global Variables
var directory;
var nodes_file = "req_node_sets.csv";
var beam_forces_file = "req_solid_sets.csv";
var coupling_beams_file = "coupling_beam_sets.csv";
var brbs_file = "brb_sets.csv";
var walls_file = "wall_shell_sets.csv";
var cross_sections_file = "xsec_sets.csv";

//MAIN WINDOW
var main_window = new Window("Write Sets", 0.6, 0.7, 0.7, 0.8);

var select = new Widget(main_window, Widget.BUTTON, 5, 50, 10, 20, "Select CSV Directory");
select.background = Widget.DARKGREEN;
select.foreground = Widget.WHITE;
select.onClick = directory_clicked;

var dir_label = new Widget(main_window, Widget.LABEL, 55, 120, 10, 20, "None currently selected");

var nodes = new Widget(main_window, Widget.BUTTON, 5, 50, 35, 45, "Node Sets");
nodes.background = Widget.DARKGREEN;
nodes.foreground = Widget.WHITE;
nodes.active = false;
nodes.onClick = on_click;

var node_label = new Widget(main_window, Widget.LABEL, 55, 120, 35, 45, "undefined");

var basic_beams = new Widget(main_window, Widget.BUTTON, 5, 50, 50, 60, "Solid Sets");
basic_beams.background = Widget.DARKGREEN;
basic_beams.foreground = Widget.WHITE;
basic_beams.active = false;
basic_beams.onClick = on_click;

var basic_beam_label = new Widget(main_window, Widget.LABEL, 55, 120, 50, 60, "undefined");

var coupling_beams = new Widget(main_window, Widget.BUTTON, 5, 50, 65, 75, "Coupling Beam Rotations");
coupling_beams.background = Widget.DARKBLUE;
coupling_beams.foreground = Widget.WHITE;
coupling_beams.active = false;
coupling_beams.onClick = on_click;

var coupling_beam_label = new Widget(main_window, Widget.LABEL, 55, 120, 65, 75, "undefined");

var brbs = new Widget(main_window, Widget.BUTTON, 5, 50, 80, 90, "BRB Strains");
brbs.background = Widget.DARKBLUE;
brbs.foreground = Widget.WHITE;
brbs.active = false;
brbs.onClick = on_click;

var brb_label = new Widget(main_window, Widget.LABEL, 55, 120, 80, 90, "undefined");

var walls = new Widget(main_window, Widget.BUTTON, 5, 50, 95, 105, "Walls");
walls.background = Widget.ORANGE;
walls.foreground = Widget.WHITE;
walls.active = false;
walls.onClick = on_click;

var wall_label = new Widget(main_window, Widget.LABEL, 55, 120, 95, 105, "undefined");

var cross_sections = new Widget(main_window, Widget.BUTTON, 5, 50, 110, 120, "Cross Sections");
cross_sections.background = Widget.MAGENTA;
cross_sections.foreground = Widget.WHITE;
cross_sections.active = false;
cross_sections.onClick = on_click;

var cross_sections_label = new Widget(main_window, Widget.LABEL, 55, 120, 110, 120, "undefined");


var exit = new Widget(main_window, Widget.BUTTON, 5, 50, 135, 145, "Exit");
exit.background = Widget.DARKRED;
exit.foreground = Widget.WHITE;
exit.onClick = on_click;

main_window.Show();


function directory_clicked(){
	Message("Please Select Run Directory");

	directory = Window.GetDirectory(GetCurrentDirectory());

	if (directory != undefined) {
		var text = directory.split(slash);
		dir_label.text = "Selected Folder '" + text[text.length - 1] + "'";
		nodes.active = true;
		basic_beams.active = true;
		coupling_beams.active = true;
		brbs.active = true;
		walls.active = true;
		cross_sections.active = true;

		var not_found_message = "File not found";
		if (File.Exists(directory + slash + nodes_file)) {
			node_label.text = "Found " + nodes_file;
			node_label.foreground = Widget.DARKBLUE;
		}
		else {
			node_label.text = not_found_message;
			node_label.foreground = Widget.DARKRED;
		}

		if (File.Exists(directory + slash + beam_forces_file)){
			basic_beam_label.text = "Found " + beam_forces_file;
			basic_beam_label.foreground = Widget.DARKBLUE;			
		}
		else { 
			basic_beam_label.text = not_found_message;
			basic_beam_label.foreground = Widget.DARKRED;
		}

		if (File.Exists(directory + slash + coupling_beams_file)) {
			coupling_beam_label.text = "Found " + coupling_beams_file;
			coupling_beam_label.foreground = Widget.DARKBLUE;
		}
		else {
			coupling_beam_label.text = not_found_message;
			coupling_beam_label.foreground = Widget.DARKRED;
		}
		if (File.Exists(directory + slash + brbs_file)){
			brb_label.text = "Found " + brbs_file;
			brb_label.foreground = Widget.DARKBLUE;			
		}
		else { 
			brb_label.text = not_found_message;
			brb_label.foreground = Widget.DARKRED;
		}
		if (File.Exists(directory + slash + walls_file)) {
			wall_label.text = "Found " + walls_file;
			wall_label.foreground = Widget.DARKBLUE;				
		}
		else {
			wall_label.text = not_found_message;
			wall_label.foreground = Widget.DARKRED;
		}
		if (File.Exists(directory + slash + cross_sections_file)) {
			cross_sections_label.text = "Found " + cross_sections_file;
			cross_sections_label.foreground = Widget.DARKBLUE;
		}
		else {
			cross_sections_label.text = not_found_message;
			cross_sections_label.foreground = Widget.DARKRED;
		}
	}
	else {
		dir_label.text = "Please select run directory";
	}
}

function on_click(){
var success;

	if (this === nodes){
		//write_node_sets returns true if it succeeds in writing a csv
		success = write_node_sets(nodes_file);
		if (success){
			node_label.text = "Created " + nodes_file;
			node_label.foreground = Widget.DARKGREEN; 
		}
	}
	else if (this === basic_beams){
		success = write_beam_sets(beam_forces_file);
		if (success){
			basic_beam_label.text = "Created " + beam_forces_file;
			basic_beam_label.foreground = Widget.DARKGREEN; 
		}
	}
	else if ( this === coupling_beams) {
		sucess = write_beam_sets(coupling_beams_file);
		if (success){
			coupling_beam_label.text = "Created " + coupling_beams_file;
			coupling_beam_label.foreground = Widget.DARKGREEN;
		}		
	}
	else if (this === brbs) {
		success = write_beam_sets(brbs_file);
		if (success){
			brb_label.text = "Created " + brbs_file;
			brb_label.foreground = Widget.DARKGREEN;
		}		
	}
	else if (this === walls){
		success = write_shell_sets(walls_file);
		if (success){
			wall_label.text = "Created " + walls_file;
			wall_label.foreground = Widget.DARKGREEN;
		}
	}
	else if (this === cross_sections){
		success = write_cross_sections(cross_sections_file);
		if (success){
			cross_sections_label.text = "Created " + cross_sections_file;
			cross_sections_label.foreground = Widget.DARKGREEN;
		}
	}
	else if (this === exit){
		main_window.Hide();
	}

}

function write_node_sets(file_name){
	var success;
	var m = Model.GetFromID(1);
	var sflag = AllocateFlag();

	var select = Window.Message("Select Sets", "Select Floor Node Sets", Window.OK | Window.CANCEL);
	if(select != Window.CANCEL){
			
		//Request user to flag sets to be written out
		var select_sets = Set.Select(Set.NODE, sflag, 'Select sets', m);
		if (select_sets != null){
			var nsets = Set.GetAll(m, Set.NODE);

			var file_path = directory+slash+file_name;

			var file = new File(file_path, File.WRITE);
			file.Writeln("NID,Set_Name,X,Y,Z");

			for(i=0; i<nsets.length; i++)
			{
			    if(nsets[i].Flagged(sflag))
			    {
			        name = nsets[i].title;
			        if(name == "")
			        {
			            name = "S:"+nsets[i].sid;
			        }
			        nsets[i].StartSpool();
			        while (nid = nsets[i].Spool() )
			        {
			            var n = Node.GetFromID(m, nid);
			            file.Writeln(nid+","+name+","+n.x+","+n.y+","+n.z);
			        }
			    }
		}
		file.Close();
		Window.Message("Success!", "Successfully written " + file_name, Window.OK);
		Message("File written at " + file_path);
		success = true;
		}
		else{
			success = false;
		}
	}
	else{
		success = false;
	}
		return success;

}

function write_beam_sets(file_name){
	var success;
	var model = Model.GetFromID(1);
	var flag = AllocateFlag();

	var select = Window.Message("Select Sets", "Select Beam Sets", Window.OK | Window.CANCEL);
	if(select != Window.CANCEL){

		//Request user to flag sets to be written out
		var select_sets = Set.Select(Set.SOLID, flag, 'Select Solid Sets', model);
		if (select_sets != null) {

			var sets = Set.GetAll(model, Set.SOLID);

			//Create/Overwrite file 
			var file_path = directory+slash+file_name;
			var file = new File(file_path, File.WRITE);
			file.Writeln("SID,Set_Name,Node1_Z");

			for (i=0; i < sets.length; i++){

				if (sets[i].Flagged(flag)){
					var set_name = sets[i].title;

					var sid;
					sets[i].StartSpool();

					while( sid = sets[i].Spool() ){
						var sol = Solid.GetFromID( model,sid );
						var node_1 = Node.GetFromID( model,sol.n1 );
						file.Writeln(sid + "," + set_name + "," + node_1.z);
					}

				}
			}
			Window.Message("Success!", "Successfully written " + file_name, Window.OK);
			Message("File written at " + file_path);
			file.Close();
			success = true;
		}
		else {
			success = false;
		}
	}
	else{
		success = false;
	}
	return success;
}

function write_shell_sets(file_name){
	var success;
	var m = Model.GetFromID(1);
	var sflag = AllocateFlag();

	var select = Window.Message("Select Sets", "Select Wall Shell Sets", Window.OK | Window.CANCEL);
	if(select != Window.CANCEL)
	{

		//Prompt user to select shell sets
		var select_sets = Set.Select(Set.SHELL, sflag, 'Select sets', m);
		if (select_sets != null){

			//Create/Overwrite file 
			var file_path = directory+slash+file_name;
			var file = new File(file_path, File.WRITE);
			file.Writeln("EID,Set_Name,Centroid_X,Centroid_Y,Centroid_Z,Node1_X,Node1_Y,Node1_Z,Node2_X,Node2_Y,Node2_Z,Node3_X,Node3_Y,Node3_Z,Node4_X,Node4_Y,Node4_Z,ELFORM,MATERIAL,NIP");

			var shell_sets = Set.GetAll(m, Set.SHELL);

			for(i=0; i<shell_sets.length; i++)
			{
				//If shell set has been flagged by user
				if(shell_sets[i].Flagged(sflag))
				{
					var name = shell_sets[i].title;
					if(name == "")
					{
						name = "S:"+shell_sets[i].sid;
					}

					shell_sets[i].StartSpool();
					var sid;
					while (sid = shell_sets[i].Spool() )
					{
						var shell = Shell.GetFromID(m, sid);
						var centroid = shell.IsoparametricToCoords(0.0, 0.0);

						var ip = "";
						var part = Part.GetFromID(m, shell.pid);



						//Determine nodal coordinates
						var n1 = Node.GetFromID(m, shell.n1);
						var n2 = Node.GetFromID(m, shell.n2);
						var n3 = Node.GetFromID(m, shell.n3);
						
						//If it is a 4 noded element, set n4. Otherwise set n4 = 0
						if (shell.nodes == 4) var n4 = Node.GetFromID(m, shell.n4);
						else var n4 = {x: 0, y: 0, z: 0};

						//Determine Integration Points
						if(part.composite == true)
						{
							var elform = part.elform;
							//Get composite data for first layer
							var composite = part.GetCompositeData(0);
							var material = Material.GetFromID(m, composite[0])
							var nip = part.nip;
						}
						else
						{
							var material = Material.GetFromID(m, part.mid);
							var elform = Section.GetFromID(m, part.secid).elform;
							var nip = Section.nip;
						}

						file.Writeln(sid+","+name + "," + centroid[0]+","+centroid[1]+","+centroid[2] + "," + n1.x + "," + n1.y + "," + n1.z + "," + n2.x + "," + n2.y + "," + n2.z + "," + n3.x + "," + n3.y + "," + n3.z + "," + n4.x + "," + n4.y + "," + n4.z +","+ elform + "," + material.type + "," + nip);
					}
				}
			}
			file.Close();	
			Window.Message("Success!", "Successfully written " + file_name, Window.OK);
			Message("File written at " + file_path);
			success = true;
		}
		else success = false;
	}
	else success = false;

	return success;
}

function write_cross_sections(file_name){
	var success;
	var m = Model.GetFromID(1);
	var sflag = AllocateFlag();

	var select = Window.Message("Select X-Sec", "Select Cross-sections", Window.OK | Window.CANCEL);
	if(select != Window.CANCEL){
		
		//Prompt user to select cross sections
		var select_sets = CrossSection.Select(sflag, 'Select X-sec', m);
		if (select_sets != null){
			var xsec = CrossSection.GetAll(m);

			//Create File
			var file_path = directory + slash + file_name;
			var file = new File(file_path, File.WRITE);
			file.Writeln("XSection_ID,Set_Name,X,Y,Z");

			for(i=0; i<xsec.length; i++)
			{
				if(xsec[i].Flagged(sflag))
				{
					csid = xsec[i].csid;
					name = xsec[i].heading;
					if(name == "" || name == null)
					{
						name = "X:"+csid;
					}
					x = xsec[i].xct;
					y = xsec[i].yct;
					z = xsec[i].zct;

					file.Writeln(csid+","+name+","+x+","+y+","+z);
				}
			}
			file.Close();
			Window.Message("Success!", "Successfully written " + file_name, Window.OK);
			Message("File written at " + file_path);
			success = true;
		}
		else{
			success = false;
		}
	}
	else{
		success = false;
	}	

	return success
}