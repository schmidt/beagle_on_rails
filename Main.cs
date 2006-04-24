// project created on 24.04.2006 at 12:47
using System;

namespace beagle_in_rails_cs_client
{
	class MainClass
	{
		public static void Main(string[] args)
		{
			Console.Write("Query for: ");
			String query_string = Console.ReadLine();
			
			try
			{
				
		    	BeagleService bs = new BeagleService ();
		    	
				Console.WriteLine("Querying Beagle via Webservice...");
		    	Search search_object = bs.Execute( query_string );
		    	
		    	Console.WriteLine("Query string:    " + search_object.key);
		    	Console.WriteLine("Result ordering: " + search_object.order);
		    	Console.WriteLine("No. of Hits:     " + search_object.number_of_hits);
		    	Console.WriteLine("First Hit after: " + search_object.first_hit + "s");
		    	Console.WriteLine("Total Time:      " + search_object.total_time + "s");
		    	Console.WriteLine();
		    	
		    	foreach(Item result in search_object.results)
		    	{
		    		Console.Write("URI:      " + result.uri);
		    		Console.Write("Snip:     " + result.snip);
		    		Console.WriteLine("Time:     " + result.time);
		    		Console.Write("Source:   " + result.source);
		    		Console.Write("MimeType: " + result.mime_type);		    	
		    		Console.Write("Type:     " + result.type);
//		    		Console.Write("Divers:   " + result.divers);
		    		Console.WriteLine();
		    	}
			}
			catch (Exception ex)
			{
				Console.WriteLine("Exception occurred: " + ex.GetType());
				Console.WriteLine(ex.StackTrace);
			}		
		}
	}
}