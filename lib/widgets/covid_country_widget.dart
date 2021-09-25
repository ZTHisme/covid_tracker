import 'package:covid_tracker/ob/covid_summary_ob.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CovidCountryWidget extends StatelessWidget {

  var numberFormat = NumberFormat(",###");

  final Countries country;

  CovidCountryWidget(this.country);

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.all(10),
        color: Colors.indigo,
        child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                RichText(
                  text: TextSpan(
                      text: country.country! + " . ",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 17),
                      children: [
                        TextSpan(
                            text: numberFormat.format(country.newConfirmed),
                            style:
                                TextStyle(color: Colors.amber, fontSize: 14)),
                        TextSpan(
                            text: " New Cases ",
                            style: TextStyle(color: Colors.grey, fontSize: 14))
                      ]),
                ),
                Divider(
                  color: Colors.white,
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    SizedBox(width: 30),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(numberFormat.format(country.totalConfirmed),
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18)),
                          SizedBox(height: 15),
                          Text("Confirmed",
                              style: TextStyle(
                                  color: Colors.grey.shade300, fontSize: 16)),
                          SizedBox(height: 5),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(numberFormat.format(country.totalDeaths),
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18)),
                          SizedBox(height: 15),
                          Text("Deaths",
                              style: TextStyle(
                                  color: Colors.grey.shade300, fontSize: 16)),
                          SizedBox(height: 5),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(numberFormat.format(country.totalRecovered),
                              style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18)),
                          SizedBox(height: 15),
                          Text("Recovered",
                              style: TextStyle(
                                  color: Colors.grey.shade300, fontSize: 16)),
                          SizedBox(height: 5),
                        ],
                      ),
                    )
                  ],
                ),
                Divider(
                  color: Colors.white,
                ),
                Text(
                  DateFormat("EEEE, MMMM dd, yyyy, HH:MM")
                      .format(DateTime.parse(country.date!)),
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                )
              ],
            )));
  }
}
