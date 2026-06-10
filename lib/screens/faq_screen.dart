import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FaqScreen extends StatelessWidget {

  final Color themeColor;


  const FaqScreen({
    super.key,
    required this.themeColor,
  });




  static const List<Map<String, String>> faqs = [

    {
      'q': 'How do I track my order?',
      'a':
      'You can track your order in real-time from My Orders section. Open your active order to view delivery status and partner details.',
    },

    {
      'q': 'What is your refund policy?',
      'a':
      'Refunds are processed after cancellation approval. Wallet refunds are instant while bank refunds may take 3-5 business days.',
    },

    {
      'q': 'Can I change my delivery address?',
      'a':
      'Address cannot be changed after placing an order. You can cancel quickly and place a new order with another address.',
    },

    {
      'q': 'How does CartKaro Wallet work?',
      'a':
      'CartKaro Wallet stores rewards, refunds and promotional balance which you can use during checkout.',
    },

    {
      'q': 'Are there hidden charges?',
      'a':
      'No. Delivery charges, taxes and other fees are clearly shown before payment.',
    },

    {
      'q': 'How can I contact support?',
      'a':
      'You can contact our support team anytime from Help & Support section.',
    },

  ];






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

            'FAQ',

            style: _s(

              size: 18,

              weight:
              FontWeight.w700,

            ),

          ),

        ),







        body: ListView(

          physics:
          const BouncingScrollPhysics(),

          padding:
          const EdgeInsets.all(20),




          children: [







            // HEADER CARD

            Container(

              padding:
              const EdgeInsets.all(22),


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
                BorderRadius.circular(24),





                boxShadow: [

                  BoxShadow(

                    color:
                    themeColor.withOpacity(0.25),

                    blurRadius: 18,

                    offset:
                    const Offset(0,8),

                  )

                ],

              ),






              child: Column(

                crossAxisAlignment:
                CrossAxisAlignment.start,



                children: [



                  const Text(

                    '❓',

                    style:
                    TextStyle(fontSize:38),

                  ),






                  const SizedBox(height:12),






                  Text(

                    'How can we help?',

                    style:
                    _s(

                      size:24,

                      weight:
                      FontWeight.w800,

                      color:
                      Colors.white,

                    ),

                  ),






                  const SizedBox(height:8),





                  Text(

                    'Find answers about orders, payments, rewards and CartKaro services.',


                    style:
                    _s(

                      size:13,

                      color:
                      Colors.white70,

                      height:1.5,

                    ),

                  ),



                ],

              ),

            ),







            const SizedBox(height:28),








            Text(

              'Frequently Asked Questions',

              style:
              _s(

                size:17,

                weight:
                FontWeight.w800,

              ),

            ),







            const SizedBox(height:16),








            Theme(

              data:
              Theme.of(context).copyWith(

                dividerColor:
                Colors.transparent,

              ),



              child:
              ListView.separated(

                shrinkWrap:true,


                physics:
                const NeverScrollableScrollPhysics(),


                itemCount:
                faqs.length,



                separatorBuilder:
                    (_,__) =>
                const SizedBox(height:12),






                itemBuilder:
                    (context,index){



                  return Container(


                    decoration:
                    BoxDecoration(

                      color:
                      Colors.white,


                      borderRadius:
                      BorderRadius.circular(18),




                      border:
                      Border.all(

                        color:
                        const Color(0xFFE5E7EB),

                      ),






                      boxShadow:[

                        BoxShadow(

                          color:
                          Colors.black.withOpacity(0.02),

                          blurRadius:10,

                          offset:
                          const Offset(0,4),

                        )

                      ],

                    ),







                    child:
                    ExpansionTile(


                      iconColor:
                      themeColor,



                      collapsedIconColor:
                      const Color(0xFF6B7280),





                      tilePadding:
                      const EdgeInsets.symmetric(

                        horizontal:18,

                        vertical:6,

                      ),






                      childrenPadding:
                      const EdgeInsets.fromLTRB(

                        18,0,18,18,

                      ),







                      title:
                      Text(

                        faqs[index]['q']!,

                        style:
                        _s(

                          size:14,

                          weight:
                          FontWeight.w700,

                        ),

                      ),






                      children:[


                        Text(

                          faqs[index]['a']!,

                          style:
                          _s(

                            size:13,

                            color:
                            const Color(0xFF6B7280),

                            height:1.5,

                          ),

                        ),


                      ],


                    ),

                  );

                },

              ),

            ),







            const SizedBox(height:40),


          ],

        ),

      ),

    );

  }

}