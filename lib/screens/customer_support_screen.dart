import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomerSupportScreen extends StatelessWidget {

  final Color themeColor;


  const CustomerSupportScreen({
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

            'Customer Support',

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





              // HERO CARD


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

                    begin:
                    Alignment.topLeft,

                    end:
                    Alignment.bottomRight,

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



                    Container(

                      padding:
                      const EdgeInsets.all(16),


                      decoration:
                      BoxDecoration(

                        color:
                        Colors.white.withOpacity(0.2),

                        shape:
                        BoxShape.circle,

                      ),



                      child:
                      const Icon(

                        Icons.support_agent_rounded,

                        color:
                        Colors.white,

                        size: 48,

                      ),

                    ),




                    const SizedBox(height: 18),





                    Text(

                      'Need Help?',

                      style:
                      _s(

                        size: 26,

                        weight:
                        FontWeight.w800,

                        color:
                        Colors.white,

                      ),

                    ),





                    const SizedBox(height: 8),






                    Text(

                      'Our CartKaro support team is always ready to help you.',

                      textAlign:
                      TextAlign.center,


                      style:
                      _s(

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






              _sectionTitle(
                  'POPULAR QUERIES'
              ),



              const SizedBox(height: 12),






              Container(

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




                child: Column(

                  children: [

                    _queryTile(
                        'Where is my order?'
                    ),


                    _queryTile(
                        'Cancel or refund issue'
                    ),


                    _queryTile(
                        'Payment related problem'
                    ),


                    _queryTile(
                      'Delivery partner issue',
                      divider:false,
                    ),

                  ],

                ),

              ),






              const SizedBox(height: 30),






              _sectionTitle(
                  'CONTACT US'
              ),



              const SizedBox(height: 12),







              // CHAT BUTTON


              GestureDetector(

                onTap: () {},



                child: Container(

                  width:
                  double.infinity,


                  padding:
                  const EdgeInsets.symmetric(
                    vertical: 16,
                  ),


                  decoration:
                  BoxDecoration(

                    color:
                    themeColor,

                    borderRadius:
                    BorderRadius.circular(18),



                    boxShadow: [

                      BoxShadow(

                        color:
                        themeColor.withOpacity(0.3),

                        blurRadius: 15,

                        offset:
                        const Offset(0,8),

                      )

                    ],

                  ),




                  child: Row(

                    mainAxisAlignment:
                    MainAxisAlignment.center,


                    children: [


                      const Icon(

                        Icons.chat_bubble_outline_rounded,

                        color:
                        Colors.white,

                      ),


                      const SizedBox(width: 10),



                      Text(

                        'Chat with Support',

                        style:
                        _s(

                          size: 15,

                          weight:
                          FontWeight.w700,

                          color:
                          Colors.white,

                        ),

                      ),

                    ],

                  ),

                ),

              ),







              const SizedBox(height: 16),






              Row(

                children: [


                  Expanded(

                    child:
                    _contactButton(

                      Icons.phone_outlined,

                      'Call Us',

                    ),

                  ),



                  const SizedBox(width: 16),




                  Expanded(

                    child:
                    _contactButton(

                      Icons.email_outlined,

                      'Email Us',

                    ),

                  ),


                ],

              ),





              const SizedBox(height: 40),



            ],

          ),

        ),

      ),

    );

  }







  Widget _sectionTitle(String text){

    return Text(

      text,

      style:
      _s(

        size: 12,

        weight:
        FontWeight.w800,

        color:
        const Color(0xFF6B7280),

      ),

    );

  }







  Widget _queryTile(
      String title,
      {
        bool divider = true,
      }
      ){


    return Column(

      children: [


        ListTile(

          title:
          Text(

            title,

            style:
            _s(

              size: 14,

              weight:
              FontWeight.w600,

            ),

          ),


          trailing:
          const Icon(

            Icons.arrow_forward_ios_rounded,

            size: 14,

            color:
            Color(0xFF9CA3AF),

          ),

        ),



        if(divider)

          const Divider(

            height: 1,

            indent: 20,

            endIndent: 20,

            color:
            Color(0xFFF3F4F6),

          ),

      ],

    );

  }







  Widget _contactButton(
      IconData icon,
      String title,
      ){


    return Container(

      padding:
      const EdgeInsets.symmetric(
        vertical: 15,
      ),


      decoration:
      BoxDecoration(

        color:
        Colors.white,


        borderRadius:
        BorderRadius.circular(18),


        border:
        Border.all(

          color:
          themeColor.withOpacity(0.3),

        ),

      ),



      child: Row(

        mainAxisAlignment:
        MainAxisAlignment.center,


        children: [


          Icon(

            icon,

            size: 18,

            color:
            themeColor,

          ),



          const SizedBox(width: 8),



          Text(

            title,

            style:
            _s(

              size: 14,

              weight:
              FontWeight.w700,

              color:
              themeColor,

            ),

          ),

        ],

      ),

    );

  }

}