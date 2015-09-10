

var m = Model.GetFromID(1);
var model_path = m.dir;

var file_path = model_path + '\\req_solid_sets.csv';


delete_all_curves();

var solids = read_csv(file_path);
load_curves(solids);


var sets = sort_by_sets(solids);

for (var set in sets){
	var filename = model_path + '\\' + 'Solids_' + set + '.csv';
	write_csv(sets[set], filename);
}



var results = {};

Message("SCRIPT COMPLETED");

//var cList = get_cList(out_csv.solids);

//write_csv(results.Surfacesolids, model_path + "\\Surfacesolids2_Displacements.csv", cList, out_csv.solids, out_csv.nco);
//write_csv(results.BedrockIFsolids, model_path + "\\BedrockIFsolids_Displacements.csv", cList, out_csv.solid, out_csv.nco);

function read_csv(filename)
{

	var solids =  new Array;		// array of solids which stores the sid, set #, and x, y, and z coords

	var file = new File(filename, File.READ);
	var line_number = 1;
	var line;
	while( (line = file.ReadLongLine()) != undefined){
		if(line_number != 1){

			var text = line.split(",");

			var solid = new Object();
			solid.sid = Number(text[0]);
			solid.set = text[1];
			solid.x   = Number(text[2]);
			solid.y   = Number(text[3]);
			solid.z   = Number(text[4]);
			solids.push(solid);
		}
		line_number++;
	}

	file.Close();
	return solids
}

function sort_by_sets(solids){
	var sets = new Object;
	var current_solid;
	var previous_solid;

	for(var i=0; i<solids.length; i++){
		current_solid = solids[i];
		//Initialize first set array
		if (i==0){
			sets[current_solid.set] = new Array;
			sets[current_solid.set].push(current_solid.sid);
		} 

		else {
			previous_solid = solids[i-1];

			if(current_solid.set == previous_solid.set){
				sets[current_solid.set].push(current_solid.sid);
			}
			else{
				sets[current_solid.set] = new Array;
				sets[current_solid.set].push(current_solid.sid);
			}
		};
	}

	return sets;
}



function load_curves(solids){

	
	// Strains
	var displx = "mo da so STRAIN all eyz #";
	DialogueInputNoEcho(displx);
	var disply = "mo da so STRAIN all ezx #";
	DialogueInputNoEcho(disply);

	// Stresses
	var displx = "mo da so STRESS all syz #";
	DialogueInputNoEcho(displx);
	var disply = "mo da so STRESS all szx #";
	DialogueInputNoEcho(disply);




 //THIS IS FOR ADDING solids INDIVIDUALLY RATHER THAN ALL AT ONCE
// 	for (var i=0; i<solids.length; i++){
// 
//		var solid = solids[i];
//		// Displacements
//		var displx = "mo da no " + (solid.sid) + " dx #";
//		DialogueInputNoEcho(displx);
//		var disply = "mo da no " + (solid.sid) + " dy #";
//		DialogueInputNoEcho(disply);

//		// Velocities
//		var displx = "mo da no " + (solid.sid) + " vx #";
//		DialogueInputNoEcho(displx);
//		var disply = "mo da no " + (solid.sid) + " vy #";
//		DialogueInputNoEcho(disply);

//		// Accelerations
//		var displx = "mo da no " + (solid.sid) + " ax #";
//		DialogueInputNoEcho(displx);
//		var disply = "mo da no " + (solid.sid) + " ay #";
//		DialogueInputNoEcho(disply);
//	}	
	
}



function write_csv(set_solids, file_path)
{
	var file = new File(file_path, File.WRITE);
	var write_line = "";
	var x = new Array;
	var y = new Array;
	var curve = Curve.GetFromID(1);


	var text = curve.label.split(/\s+/);
	x =  [curve.sid,"Time [s]"];
	for (var k=0; k<curve.npoints; k++){
		x.push(curve.GetPoint(k+1)[0]);
	}
	write_line = x.join(",");
	file.Writeln(write_line);

	//For each solid in set
	for (var i=0; i<set_solids.length; i++){
		var solid = set_solids[i];

		curve = Curve.GetFromID(1);	// all curves read in thus far are time curves and have the same time step and # of points

		while(curve){
			var label = curve.label.split(/\s+/);
			//Last element in label is solid id
			curve.sid = Number(label[label.length-1]);
			curve.type = label[0] + label[1];

			//If curve solid ID matches current set solid id
			if(curve.sid == set_solids[i]){
				for (var j=0; j<curve.npoints; j++){
					if (j==0) y = [curve.sid,curve.type];
					y.push(curve.GetPoint(j+1)[1]);
				}


				write_line = y.join(",");
				file.Writeln(write_line);
			}
			
			curve = curve.Next();

		}
	}

	file.Close();
	Message("Finished writing results");
}



// Delete all curves
function delete_all_curves()
{
	if (Curve.Exists(1) == true)
	{
		var c = Curve.First();

		while(c)
		{
			Curve.Delete(c.id);
			c = c.Next();
		}

		Message("Deleted all curves");
		return true;

	}
	else
	{
		Message("No curves to delete");
		return false;
	}
}
