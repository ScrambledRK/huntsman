import java.awt.Color;

File input = new File("output_nodes.json")

File output_nodes = new File("out_nodes.csv");
File output_graph = new File("out_graph.csv");

// -------------------------------------------- //
// -------------------------------------------- //

def jsonSlurper = new groovy.json.JsonSlurper()
def json = jsonSlurper.parseText(input.text)

// -------------------------------------------- //
// -------------------------------------------- //

float interpolate(float a, float b, float proportion) {
   return (a + ((b - a) * proportion));
 }

 /** Returns an interpoloated color, between <code>a</code> and <code>b</code> */
Color interpolateColor(float proportion) {

   return Color.getHSBColor( proportion, 1, 0.75 );
 }

// -------------------------------------------- //
// -------------------------------------------- //

ArrayList<String> packages = new ArrayList<String>();
ArrayList<String> nodes = new ArrayList<String>();
ArrayList<String> graph = new ArrayList<String>();

//
json.class.each {

	String pack = it.name.substring( 0, it.name.lastIndexOf( "." ) );

	if( !packages.contains(pack) )
		packages.add(pack);
}

//
java.util.Collections.sort(packages);

//
json.class.each {

	String pack = it.name.substring( 0, it.name.lastIndexOf( "." ) );

	float delta = packages.indexOf( pack ) / packages.size();
	Color v = this.interpolateColor( delta );

	println v;

	String name = it.name.substring( it.name.lastIndexOf( "." ) + 1 );
	String color = ex = String.format("#%02x%02x%02x", v.getRed(), v.getGreen(), v.getBlue() );

	nodes.add( it.name + "," + name + "," + color );

	it.children.each { child ->
		if( child != null && child.type == "class" )
		{
			graph.add( it.name + "," + child.name );
		}
	}
}

// -------------------------------------------- //
// -------------------------------------------- //

String output = "id,label,color\n";

nodes.each{
	output += it + "\n";
}

//
output_nodes.createNewFile();
output_nodes.text = output;

output = "source,target\n";

graph.each{
	output += it + "\n";
}

//
output_graph.createNewFile();
output_graph.text = output;

println "DONE!"