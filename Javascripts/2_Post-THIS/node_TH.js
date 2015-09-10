

var m = Model.GetFromID(1);
var model_path = m.dir;

var file_path = model_path + '\\req_node_sets.csv';


delete_all_curves();

var nodes = read_csv(file_path);
load_curves(nodes);


var sets = sort_by_sets(nodes);

for (var set in sets){
	var filename = model_path + '\\' + 'Nodes_' + set + '.csv';
	write_csv(sets[set], filename);
}



var results = {};

Message("SCRIPT COMPLETED");

//var cList = get_cList(out_csv.nodes);

//write_csv(results.SurfaceNodes, model_path + "\\SurfaceNodes2_Displacements.csv", cList, out_csv.nodes, out_csv.nco);
//write_csv(results.BedrockIFNodes, model_path + "\\BedrockIFNodes_Displacements.csv", cList, out_csv.node, out_csv.nco);

function read_csv(filename)
{

	var nodes =  new Array;		// array of nodes which stores the nid, set #, and x, y, and z coords

	var file = new File(filename, File.READ);
	var line_number = 1;
	var line;
	while( (line = file.ReadLongLine()) != undefined){
		if(line_number != 1){

			var text = line.split(",");

			var node = new Object();
			node.nid = Number(text[0]);
			node.set = text[1];
			node.x   = Number(text[2]);
			node.y   = Number(text[3]);
			node.z   = Number(text[4]);
			nodes.push(node);
		}
		line_number++;
	}

	file.Close();
	return nodes
}

function sort_by_sets(nodes){
	var sets = new Object;
	var current_node;
	var previous_node;

	for(var i=0; i<nodes.length; i++){
		current_node = nodes[i];
		//Initialize first set array
		if (i==0){
			sets[current_node.set] = new Array;
			sets[current_node.set].push(current_node.nid);
		} 

		else {
			previous_node = nodes[i-1];

			if(current_node.set == previous_node.set){
				sets[current_node.set].push(current_node.nid);
			}
			else{
				sets[current_node.set] = new Array;
				sets[current_node.set].push(current_node.nid);
			}
		};
	}

	return sets;
}



function load_curves(nodes){

	
	// Displacements
	var displx = "mo da no all dx #";
	DialogueInputNoEcho(displx);
	var disply = "mo da no all dy #";
	DialogueInputNoEcho(disply);

	// Velocities
	var displx = "mo da no all vx #";
	DialogueInputNoEcho(displx);
	var disply = "mo da no all vy #";
	DialogueInputNoEcho(disply);

	// Accelerations
	var displx = "mo da no all ax #";
	DialogueInputNoEcho(displx);
	var disply = "mo da no all ay #";
	DialogueInputNoEcho(disply);



 // //THIS IS FOR ADDING NODES INDIVIDUALLY RATHER THAN ALL AT ONCE
// 	for (var i=0; i<nodes.length; i++){
// 
//		var node = nodes[i];
//		// Displacements
//		var displx = "mo da no " + (node.nid) + " dx #";
//		DialogueInputNoEcho(displx);
//		var disply = "mo da no " + (node.nid) + " dy #";
//		DialogueInputNoEcho(disply);

//		// Velocities
//		var displx = "mo da no " + (node.nid) + " vx #";
//		DialogueInputNoEcho(displx);
//		var disply = "mo da no " + (node.nid) + " vy #";
//		DialogueInputNoEcho(disply);

//		// Accelerations
//		var displx = "mo da no " + (node.nid) + " ax #";
//		DialogueInputNoEcho(displx);
//		var disply = "mo da no " + (node.nid) + " ay #";
//		DialogueInputNoEcho(disply);
//	}	
	
}



function write_csv(set_nodes, file_path)
{
	var file = new File(file_path, File.WRITE);
	var write_line = "";
	var x = new Array;
	var y = new Array;
	var curve = Curve.GetFromID(1);


	var text = curve.label.split(/\s+/);
	x =  [curve.nid,"Time [s]"];
	for (var k=0; k<curve.npoints; k++){
		x.push(curve.GetPoint(k+1)[0]);
	}
	write_line = x.join(",");
	file.Writeln(write_line);

	//For each node in set
	for (var i=0; i<set_nodes.length; i++){
		var node = set_nodes[i];

		curve = Curve.GetFromID(1);	// all curves read in thus far are time curves and have the same time step and # of points

		while(curve){
			var label = curve.label.split(/\s+/);
			//Last element in label is node id
			curve.nid = Number(label[label.length-1]);
			curve.type = label[0] + label[1];

			//If curve node ID matches current set node id
			if(curve.nid == set_nodes[i]){
				for (var j=0; j<curve.npoints; j++){
					if (j==0) y = [curve.nid,curve.type];
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
