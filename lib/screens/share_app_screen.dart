import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ShareAppScreen extends StatelessWidget {
  final Color themeColor;

  const ShareAppScreen({
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

          backgroundColor: Colors.white,
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

            'Share & Earn',

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



              // ── TOP EARN CARD ──

              Container(

                width: double.infinity,

                padding:
                const EdgeInsets.all(26),


                decoration:
                BoxDecoration(

                  gradient:
                  LinearGradient(

                    colors: [

                      themeColor,

                      themeColor
                          .withOpacity(0.75),

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
                      const EdgeInsets.all(14),

                      decoration:
                      BoxDecoration(

                        color:
                        Colors.white.withOpacity(0.2),

                        shape:
                        BoxShape.circle,

                      ),


                      child: const Text(

                        '🎁',

                        style:
                        TextStyle(fontSize: 38),

                      ),

                    ),



                    const SizedBox(height: 16),



                    Text(

                      'Share CartKaro\nEarn ₹50',

                      textAlign:
                      TextAlign.center,


                      style: _s(

                        size: 28,

                        weight:
                        FontWeight.w800,

                        color:
                        Colors.white,

                        height: 1.2,

                      ),

                    ),




                    const SizedBox(height: 12),




                    Text(

                      'Invite your friends and get\nreward after their first order',

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




              const SizedBox(height: 28),





              // ── SHARE BUTTON CARD ──


              Container(

                width:
                double.infinity,


                padding:
                const EdgeInsets.all(22),


                decoration:
                BoxDecoration(

                  color:
                  Colors.white,


                  borderRadius:
                  BorderRadius.circular(22),


                  border:
                  Border.all(

                    color:
                    const Color(0xFFE5E7EB),

                  ),


                  boxShadow: [

                    BoxShadow(

                      color:
                      Colors.black.withOpacity(0.03),

                      blurRadius: 12,

                      offset:
                      const Offset(0,5),

                    )

                  ],

                ),




                child: Column(

                  children: [


                    Icon(

                      Icons.groups_rounded,

                      color:
                      themeColor,

                      size: 46,

                    ),




                    const SizedBox(height: 14),




                    Text(

                      'Invite Your Friends',

                      style: _s(

                        size: 18,

                        weight:
                        FontWeight.w800,

                      ),

                    ),




                    const SizedBox(height: 6),




                    Text(

                      'Share CartKaro with friends\nand start earning rewards',

                      textAlign:
                      TextAlign.center,


                      style: _s(

                        size: 13,

                        color:
                        const Color(0xFF6B7280),

                        height: 1.5,

                      ),

                    ),





                    const SizedBox(height: 22),




                    SizedBox(

                      width:
                      double.infinity,


                      child:
                      ElevatedButton.icon(


                        onPressed: () {},



                        style:
                        ElevatedButton.styleFrom(

                          backgroundColor:
                          themeColor,


                          padding:
                          const EdgeInsets.symmetric(
                            vertical: 16,
                          ),


                          shape:
                          RoundedRectangleBorder(

                            borderRadius:
                            BorderRadius.circular(18),

                          ),

                        ),




                        icon:
                        const Icon(

                          Icons.share_rounded,

                          color:
                          Colors.white,

                        ),




                        label:
                        Text(

                          'Share App',

                          style: _s(

                            size: 15,

                            weight:
                            FontWeight.w700,

                            color:
                            Colors.white,

                          ),

                        ),


                      ),

                    )


                  ],

                ),

              ),






              const SizedBox(height: 32),



              _title('How to Earn 💰'),



              _step(

                Icons.share_rounded,

                'Share CartKaro App',

                'Invite your friends to join CartKaro',

              ),



              _step(

                Icons.shopping_bag_rounded,

                'Friend Orders',

                'Friend completes first successful order',

              ),



              _step(

                Icons.account_balance_wallet_rounded,

                'Earn ₹50 Reward',

                'Reward will be added to your wallet',

              ),





              const SizedBox(height: 30),




              _title('Terms & Conditions'),



              _condition(
                'Reward is valid only for new users.',
              ),


              _condition(
                'Friend must complete first order.',
              ),


              _condition(
                'Cancelled orders are not eligible.',
              ),


              _condition(
                'Reward will be credited after delivery.',
              ),


              _condition(
                'CartKaro can change offer anytime.',
              ),



              const SizedBox(height: 40),


            ],

          ),

        ),

      ),

    );

  }





  Widget _title(String text){

    return Text(

      text,

      style: _s(

        size: 16,

        weight:
        FontWeight.w700,

      ),

    );

  }






  Widget _step(
      IconData icon,
      String title,
      String subtitle,
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






  Widget _condition(String text){

    return Padding(

      padding:
      const EdgeInsets.only(top: 12),


      child: Row(

        crossAxisAlignment:
        CrossAxisAlignment.start,


        children: [


          Icon(

            Icons.check_circle_rounded,

            size: 18,

            color:
            themeColor,

          ),



          const SizedBox(width: 10),




          Expanded(

            child:
            Text(

              text,

              style:
              _s(

                size: 12,

                color:
                const Color(0xFF6B7280),

              ),

            ),

          )


        ],

      ),

    );

  }

}