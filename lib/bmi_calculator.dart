import 'package:bmi_calculator/widget/app_input_field.dart';
import 'package:flutter/material.dart';
enum HeightType{m,cm,feetInch}
enum WeightType { kg, pound }

class bmi extends StatefulWidget {
  const bmi({super.key});

  @override
  State<bmi> createState() => _bmiState();
}

class _bmiState extends State<bmi> {
  HeightType heightType=HeightType.cm;
  WeightType weightType = WeightType.kg;

  final TextEditingController Weightcontroller=TextEditingController();
  final TextEditingController cmHeightcontroller=TextEditingController();
  final TextEditingController feetHeightcontroller=TextEditingController();
  final TextEditingController inchHeightcontroller=TextEditingController();
  final TextEditingController meterHeightController = TextEditingController();


  String bmiResult="";
  String? category;
  //codition =  weight(kg) / height(m*m);
  // 1inch= 0.0254 m

  double ? cmToM()
  {
    final cm=double.tryParse(cmHeightcontroller.text.trim());
    if(cm==null || cm<0) return null;
    return cm/100;

  }

  double ? feetInchToM()
  {
    final feet=double.tryParse(feetHeightcontroller.text.trim());
    final inch=double.tryParse(inchHeightcontroller.text.trim());

    if(feet==null || feet<0 || inch==null || inch<0){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Invvalid Data')));
      return null;
    };
    final totalInch=(feet*12)+inch;

    if(totalInch==null)
      {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Invvalid Data')));
        return null;
      }
    return totalInch*0.0254;
  }

  double convertToKg(double weight) {
    if (weightType == WeightType.kg) {
      return weight;
    } else {
      return weight * 0.453592; // pound → kg
    }
  }

  double? mHeight() {
    final m = double.tryParse(meterHeightController.text.trim());
    if (m == null || m <= 0) return null;
    return m; // already in meters
  }



  void calculate()
  {
    final weight=double.tryParse(Weightcontroller.text.trim());
    if(weight==null || weight<=0)
      {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Invvalid Data')));
        return;
      }
    final weightInKg = convertToKg(weight);
    final m = heightType == HeightType.cm
        ? cmToM()
        : heightType == HeightType.feetInch
        ? feetInchToM()
        : mHeight();
    if(m==null)
      {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Invvalid Data')));
        return;
      }
    final bmi=weightInKg/(m*m);
    final cat=categoryResult(bmi);
    setState(() {
      bmiResult=bmi.toStringAsFixed(2);
      category=cat;
    });


  }
  String categoryResult(double bmi)
  {
    if(bmi<18.5) return "UnderWeight😬";
    if(bmi<25) return "Normal😊";
    if(bmi<30) return "OverWeight😬";
    return "Obese☠️";

  }
  Color categoryColor(double bmi)
  {
    if(bmi<18.5) return Colors.blue;
    if(bmi<25) return Colors.green;
    if(bmi<30) return Colors.yellow;
    return Colors.red;

  }
  String getHealthMessage(double bmi) {
    if (bmi < 18.5) return "You are underweight. Try to maintain a healthy diet.";
    if (bmi < 25) return "Great! You have a healthy body weight.";
    if (bmi < 30) return "You are slightly overweight. Consider regular exercise.";
    return "High BMI. Try to consult a doctor or follow a weight-loss plan.";
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Bmi Calculator',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 16),
          children: [
            Text('Select Weight Type', style: TextStyle(fontWeight: FontWeight.bold,color: Colors.orange),),

            SegmentedButton<WeightType>(
              segments: [
                ButtonSegment(
                    label: Text('KG'), value: WeightType.kg),
                ButtonSegment(label: Text('Pound'), value: WeightType.pound),
              ],
              selected: {weightType,},
              onSelectionChanged: (value) {
                setState(() {
                  weightType = value.first;
                });
              },
            ),
            Text('Weight Unit',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.orange),),
            SizedBox(height: 4,),
            if(weightType==WeightType.kg)...[
              AppInputField(
                  labelText: 'Enter weight in (kg)',
                  textinputtype: TextInputType.number,
                  controller: Weightcontroller),
            ]else...[
              AppInputField(
                  labelText: 'Enter weight in (lb)',
                  textinputtype: TextInputType.number,
                  controller: Weightcontroller),
            ],
            SizedBox(height: 10,),
            Text('Select Height Type',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.orange),),
            SegmentedButton<HeightType>(segments: [
              ButtonSegment(label: Text('Meter'), value: HeightType.m),
              ButtonSegment<HeightType>(
                label: Text('CM'),
                  value: HeightType.cm),
              ButtonSegment<HeightType>(
                  label: Text('Feet Inch'),
                  value: HeightType.feetInch)
            ], selected: {heightType},
              onSelectionChanged: (value){
              setState(() {
                heightType=value.first;
              });
              },
            ),
            SizedBox(height: 10,),
            Text('Height Unit',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.orange),),
            if (heightType==HeightType.cm)...[
              AppInputField(
                labelText: 'Enter height in (cm)',
                textinputtype: TextInputType.number,
                controller:cmHeightcontroller),
            ]else if(heightType == HeightType.feetInch)...[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(children: [

                  Expanded(
                    child: AppInputField(
                      labelText: 'height in (feet)',
                      textinputtype: TextInputType.number,
                      controller: feetHeightcontroller,),
                  ),
                  SizedBox(width: 5,),
                  Expanded(
                    child: AppInputField(
                      labelText: 'height in (inch)',
                      textinputtype: TextInputType.number,
                      controller: inchHeightcontroller,),
                  ),
                ],),
              ),
            ]else...[
              AppInputField(
                labelText: 'Enter height in (meter)',
                textinputtype: TextInputType.number,
                controller: meterHeightController,
              )
            ],
            SizedBox(height: 15,),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white
              ),
                onPressed: (){calculate();}, child: Text(' Calculate BMI')
            ),
            SizedBox(height: 15,),
            SizedBox(height: 20),

            SizedBox(height: 20),

            if (bmiResult.isNotEmpty) ...[
              Container(
                padding: EdgeInsets.symmetric(vertical: 14, horizontal: 18),
                margin: EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300, width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "BMI Result",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                      ),
                    ),

                    SizedBox(height: 6),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          bmiResult,
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),

                        Container(
                          padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                          decoration: BoxDecoration(
                            color: categoryColor(double.parse(bmiResult)).withOpacity(0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            category!,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: categoryColor(double.parse(bmiResult)),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 10),

                    Text(
                      getHealthMessage(double.parse(bmiResult)),
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],


          ],
        ),
      ),
    );
  }
}


