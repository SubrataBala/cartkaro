import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AboutUsScreen extends StatelessWidget {
  final Color themeColor;

  const AboutUsScreen({
    super.key,
    required this.themeColor,
  });


  TextStyle _s({
    double size = 14,
    FontWeight weight = FontWeight.w400,
    Color color = const Color(0xFF111827),
    double? height,
  }) {
    return TextStyle(
      fontFamily: 'Poppins',
      fontSize: size,
      fontWeight: weight,
      color: color,
      height: height,
    );
  }



  @override
  Widget build(BuildContext context) {

    return AnnotatedRegion<SystemUiOverlayStyle>(

      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
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
              color: Color(0xFF111827),
              size: 20,
            ),

            onPressed: () =>
                Navigator.pop(context),

          ),


          title: Text(

            'About Us',

            style: _s(
              size: 18,
              weight: FontWeight.w700,
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



              // APP INTRO CARD

              Container(

                width:
                double.infinity,


                padding:
                const EdgeInsets.all(26),


                decoration:
                BoxDecoration(

                  gradient:
                  LinearGradient(

                    colors: [

                      themeColor,

                      themeColor.withOpacity(0.75),

                    ],

                  ),


                  borderRadius:
                  BorderRadius.circular(26),


                  boxShadow: [

                    BoxShadow(

                      color:
                      themeColor.withOpacity(0.3),

                      blurRadius: 20,

                      offset:
                      const Offset(0,8),

                    )

                  ],

                ),




                child: Column(

                  children: [


                    const Text(

                      '🛒',

                      style:
                      TextStyle(fontSize: 48),

                    ),


                    const SizedBox(height: 14),



                    Text(

                      'CartKaro',

                      style: _s(

                        size: 30,

                        weight:
                        FontWeight.w800,

                        color:
                        Colors.white,

                      ),

                    ),



                    const SizedBox(height: 8),




                    Text(

                      'Your everyday partner for Grocery, Food and Medicine delivery.',

                      textAlign:
                      TextAlign.center,

                      style: _s(

                        size: 13,

                        color:
                        Colors.white70,

                        height: 1.5,

                      ),

                    ),


                  ],

                ),

              ),





              const SizedBox(height: 30),




              _title('Our Mission 🚀'),



              Text(

                'CartKaro is built with a vision to make daily needs simple, fast and reliable. We connect people with groceries, restaurants and medicines through one easy platform.',


                style:
                _s(

                  size: 13,

                  color:
                  const Color(0xFF6B7280),

                  height: 1.6,

                ),

              ),





              const SizedBox(height: 30),





              _title('Our Team 👨‍💻'),



              const SizedBox(height: 16),




              _member(

                name:
                'Mukesh Bala',

                role:
                'Founder & Developer',

              ),



              _member(

                name:
                'Subrata Bala',

                role:
                'Co-Founder',

              ),



              _member(

                name:
                'Shyam Sundar Bala',

                role:
                'Team Member',

              ),






              const SizedBox(height: 30),



              _title('Why CartKaro ❤️'),



              const SizedBox(height: 10),


              _point(

                Icons.flash_on_rounded,

                'Fast Delivery',

              ),


              _point(

                Icons.security_rounded,

                'Safe & Trusted Service',

              ),


              _point(

                Icons.support_agent_rounded,

                'Customer First Support',

              ),




              const SizedBox(height: 40),


              Center(

                child:
                Text(

                  'CartKaro v2.5.0',

                  style:
                  _s(

                    size: 12,

                    color:
                    const Color(0xFF9CA3AF),

                  ),

                ),

              ),


            ],

          ),

        ),

      ),

    );

  }





  Widget _title(String text){

    return Text(

      text,

      style:
      _s(

        size: 17,

        weight:
        FontWeight.w800,

      ),

    );

  }





  Widget _member({

    required String name,

    required String role,

  }){


    return Container(

      margin:
      const EdgeInsets.only(bottom: 14),


      padding:
      const EdgeInsets.all(16),


      decoration:
      BoxDecoration(

        color:
        Colors.white,


        borderRadius:
        BorderRadius.circular(20),


        border:
        Border.all(

          color:
          const Color(0xFFE5E7EB),

        ),

      ),



      child: Row(

        children: [



          // PHOTO PLACEHOLDER

          Container(

            height: 60,

            width: 60,


            decoration:
            BoxDecoration(

              color:
              themeColor.withOpacity(0.12),

              shape:
              BoxShape.circle,

            ),


            child:
            Icon(

              Icons.person,

              color:
              themeColor,

              size: 32,

            ),


            // Later:
            // child: ClipOval(
            //   child: Image.asset(
            //    'assets/images/mukesh.png',
            //    fit: BoxFit.cover,
            //   ),
            // ),

          ),




          const SizedBox(width: 16),




          Column(

            crossAxisAlignment:
            CrossAxisAlignment.start,


            children: [


              Text(

                name,

                style:
                _s(

                  size: 15,

                  weight:
                  FontWeight.w800,

                ),

              ),



              const SizedBox(height: 4),



              Text(

                role,

                style:
                _s(

                  size: 12,

                  color:
                  const Color(0xFF6B7280),

                ),

              ),


            ],

          )

        ],

      ),

    );

  }






  Widget _point(
      IconData icon,
      String text,
      ){

    return ListTile(

      contentPadding:
      EdgeInsets.zero,


      leading:
      Icon(

        icon,

        color:
        themeColor,

      ),



      title:
      Text(

        text,

        style:
        _s(

          weight:
          FontWeight.w600,

        ),

      ),

    );

  }

}