
import 'package:covid_tracker/ob/covid_country_ob.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CovidCountryDate extends StatelessWidget {
  CovidCountryOb cco;

  CovidCountryDate(this.cco);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          SizedBox(height: 10),
          Text("Date : " + DateFormat("EEEE, MMMM dd, yyy").format(DateTime.parse(cco.date!)), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.grey)),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Container(
                  color: Colors.blue.shade200,
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      Text("Confirmed", style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold, fontSize: 15)),
                      SizedBox(height: 10),
                      Text(cco.confirmed.toString(), style: TextStyle(color: Colors.blue[900],fontWeight: FontWeight.bold, fontSize: 18)),
                      SizedBox(height: 10)],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.amber.shade200,
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      Text("Active", style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold, fontSize: 15)),
                      SizedBox(height: 10),
                      Text(cco.active.toString(), style: TextStyle(color: Colors.amber[900],fontWeight: FontWeight.bold, fontSize: 18)),
                      SizedBox(height: 10)],
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  color: Colors.green.shade200,
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      Text("Recover", style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold, fontSize: 15)),
                      SizedBox(height: 10),
                      Text(cco.recovered.toString(), style: TextStyle(color: Colors.green[900],fontWeight: FontWeight.bold, fontSize: 18)),
                      SizedBox(height: 10)],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.red.shade200,
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      Text("Deaths", style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold, fontSize: 15)),
                      SizedBox(height: 10),
                      Text(cco.deaths.toString(), style: TextStyle(color: Colors.red[900],fontWeight: FontWeight.bold, fontSize: 18)),
                      SizedBox(height: 10)],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
