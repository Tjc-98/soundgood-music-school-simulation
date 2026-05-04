using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ConsoleApplication1
{
    class Program
    {
        static void Main(string[] args)
        {
          string res =   PersonDataGrabber.build_student_insert_values(10);

            File.WriteAllText("query.txt", res);
            Console.WriteLine("Done");
            Console.ReadLine();
        }
    }
}
