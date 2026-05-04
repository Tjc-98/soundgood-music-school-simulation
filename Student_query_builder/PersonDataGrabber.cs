using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading;
using System.Threading.Tasks;
using System.Web;

namespace ConsoleApplication1
{
    static class PersonDataGrabber
    {
        static string[] skill_levelarr = new string[] { "Beginner", "Intermediate" };
        public struct personData
        {
            public personData(string firstname, string lastname,string person_number, string street,string zip, string city)
            {
                this.firstname = firstname;
                this.lastname = lastname;
                this.person_number = person_number;
                this.street = street;
                this.zip = zip;
                this.city = city;
                //this.skill_level = skill_level;
                //this.age = age;
            }
            public string firstname;
            public string lastname;
            public string person_number;
            public string street;
            public string zip;
            public string city;
            //public string skill_level;
            //public int age;
        }

        public static personData getData()
        {
            Thread.Sleep(2000);

            WebClient wc = new WebClient();
            wc.Encoding = Encoding.UTF8;
            string data = wc.DownloadString("https://www.fakeaddressgenerator.com/All_World_Address/get_se_address");
          
            string[] results =  Regex.Split(data, "value=");
            string name_data = Regex.Split(results[1], "/")[0];
            string name_results =  HttpUtility.HtmlDecode(name_data).Replace("'","");
            string firstname = Regex.Split(name_results, " ")[0];
            string lastname = "";
            try
            {

            
            try
            {
                lastname =  Regex.Split(name_results, " ")[2];
            }
            catch
            {
                lastname = Regex.Split(name_results, " ")[1];
            }

            }
            catch
            {
                lastname = "DUDE";
            }


            string personnumber_data = "19" + Regex.Split(results[5], "/")[0].Replace("-","").Replace("'","");

            string street_data = Regex.Split(results[6], " s")[0].Replace("'", "");

            string zip_data = Regex.Split(results[9], "/")[0].Replace(" ", "").Replace("'", ""); ;

            string city_data = Regex.Split(results[7], "/")[0].Replace("'", "");
            Random rnd = new Random();


            string skill = skill_levelarr[rnd.Next(0, 2)];

            int age = 2020 - int.Parse(personnumber_data.Substring(0,4));

            return new personData(firstname, lastname, personnumber_data, street_data, zip_data, city_data);
        }

        public static string build_student_insert_values(int number)
        {
            string query_holder="";

            for (int i = 0; i < number; i++)
            {
                personData pData = getData();

                string data = $"('{pData.firstname}', '{pData.lastname}', '{pData.person_number}', '{pData.street}', '{pData.zip}', '{pData.city}'),";
                query_holder += data + Environment.NewLine;

            }
            return query_holder;
        }
    }
}
