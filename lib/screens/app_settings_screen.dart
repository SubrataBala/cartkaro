import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppSettingsScreen extends StatefulWidget {

  final Color themeColor;
  final String serviceType;


  const AppSettingsScreen({
    super.key,
    required this.themeColor,
    required this.serviceType,
  });


  @override
  State<AppSettingsScreen> createState() =>
      _AppSettingsScreenState();
}





class _AppSettingsScreenState
    extends State<AppSettingsScreen> {


  bool notification = true;
  bool location = true;


  TextStyle _s({
    double size = 14,
    FontWeight weight = FontWeight.w400,
    Color color = const Color(0xFF111827),
  }) {

    return TextStyle(
      fontFamily: 'Poppins',
      fontSize: size,
      fontWeight: weight,
      color: color,
    );

  }






  @override
  Widget build(BuildContext context) {


    return AnnotatedRegion<SystemUiOverlayStyle>(


      value: const SystemUiOverlayStyle(

        statusBarColor:
        Colors.transparent,

        statusBarIconBrightness:
        Brightness.dark,

      ),



      child: Scaffold(

        backgroundColor:
        const Color(0xFFFAFAFC),



        appBar: AppBar(

          backgroundColor:
          Colors.white,

          elevation: 0,

          centerTitle: true,


          leading: IconButton(

            icon: const Icon(

              Icons.arrow_back_ios_new_rounded,

              color:
              Color(0xFF111827),

              size: 20,

            ),

            onPressed: () =>
                Navigator.pop(context),

          ),



          title: Text(

            "App Settings",

            style: _s(

              size: 18,

              weight:
              FontWeight.w700,

            ),

          ),

        ),





        body: SingleChildScrollView(

          physics:
          const BouncingScrollPhysics(),


          padding:
          const EdgeInsets.all(20),



          child: Column(

            crossAxisAlignment:
            CrossAxisAlignment.start,


            children: [





              // HEADER


              Container(

                width:
                double.infinity,


                padding:
                const EdgeInsets.all(24),



                decoration:
                BoxDecoration(

                  gradient:
                  LinearGradient(

                    colors: [

                      widget.themeColor,

                      widget.themeColor
                          .withOpacity(0.75),

                    ],

                  ),


                  borderRadius:
                  BorderRadius.circular(26),

                ),



                child: Column(

                  children: [


                    const Icon(

                      Icons.settings_rounded,

                      size: 48,

                      color:
                      Colors.white,

                    ),



                    const SizedBox(height: 12),



                    Text(

                      "${widget.serviceType} Settings",

                      style:
                      _s(

                        size: 24,

                        weight:
                        FontWeight.w800,

                        color:
                        Colors.white,

                      ),

                    ),



                    const SizedBox(height: 6),




                    Text(

                      "Manage your CartKaro experience",

                      style:
                      _s(

                        size: 13,

                        color:
                        Colors.white70,

                      ),

                    ),


                  ],

                ),

              ),







              const SizedBox(height: 30),




              _title("Preferences"),





              _switchTile(

                Icons.notifications_none_rounded,

                "Notifications",

                "Receive order updates and offers",

                notification,

                    (v){

                  setState(() {

                    notification = v;

                  });

                },

              ),






              _switchTile(

                Icons.location_on_outlined,

                "Location Access",

                "Improve delivery experience",

                location,

                    (v){

                  setState(() {

                    location = v;

                  });

                },

              ),









              const SizedBox(height: 20),






              _title(
                  "${widget.serviceType} Preferences"
              ),







              ..._serviceSettings(),







              const SizedBox(height: 20),





              _title("Storage"),





              _normalTile(

                Icons.cleaning_services_rounded,

                "Clear Cache",

                "Remove temporary data",

              ),








              const SizedBox(height: 20),






              _title("About"),






              _normalTile(

                Icons.info_outline,

                "App Version",

                "CartKaro v2.5.0",

              ),




              const SizedBox(height: 40),



            ],

          ),

        ),

      ),

    );

  }







  List<Widget> _serviceSettings(){


    if(widget.serviceType == "Grocery"){


      return [


        _normalTile(

          Icons.eco_outlined,

          "Fresh Item Preference",

          "Prioritize fresh products",

        ),


        _normalTile(

          Icons.shopping_basket_outlined,

          "Substitution Preference",

          "Manage unavailable items",

        ),

      ];


    }



    if(widget.serviceType == "Restaurant"){


      return [



        _normalTile(

          Icons.restaurant_menu,

          "Food Preference",

          "Veg / Non Veg choices",

        ),



        _normalTile(

          Icons.local_fire_department,

          "Spice Preference",

          "Manage taste preference",

        ),

      ];


    }




    return [



      _normalTile(

        Icons.medical_services_outlined,

        "Medicine Reminder",

        "Manage medicine alerts",

      ),



      _normalTile(

        Icons.health_and_safety_outlined,

        "Prescription Settings",

        "Manage prescription details",

      ),


    ];



  }









  Widget _title(String text){

    return Padding(

      padding:
      const EdgeInsets.only(bottom: 12),

      child:
      Text(

        text,

        style:
        _s(

          size: 13,

          weight:
          FontWeight.w800,

          color:
          const Color(0xFF6B7280),

        ),

      ),

    );

  }







  Widget _normalTile(
      IconData icon,
      String title,
      String subtitle){


    return ListTile(

      leading:
      Icon(

        icon,

        color:
        widget.themeColor,

      ),


      title:
      Text(

        title,

        style:
        _s(
          weight:
          FontWeight.w700,
        ),

      ),


      subtitle:
      Text(

        subtitle,

        style:
        _s(
          size: 12,
          color:
          const Color(0xFF6B7280),
        ),

      ),

    );

  }








  Widget _switchTile(
      IconData icon,
      String title,
      String subtitle,
      bool value,
      Function(bool) change,
      ){


    return SwitchListTile(

      activeColor:
      widget.themeColor,


      value:
      value,


      onChanged:
      change,


      secondary:
      Icon(

        icon,

        color:
        widget.themeColor,

      ),



      title:
      Text(

        title,

        style:
        _s(
          weight:
          FontWeight.w700,
        ),

      ),



      subtitle:
      Text(

        subtitle,

        style:
        _s(
          size: 12,
          color:
          const Color(0xFF6B7280),
        ),

      ),

    );

  }

}