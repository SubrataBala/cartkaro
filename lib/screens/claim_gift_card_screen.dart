import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ClaimGiftCardScreen extends StatefulWidget {
  final Color themeColor;

  const ClaimGiftCardScreen({
    super.key,
    required this.themeColor,
  });

  @override
  State<ClaimGiftCardScreen> createState() =>
      _ClaimGiftCardScreenState();
}

class _ClaimGiftCardScreenState
    extends State<ClaimGiftCardScreen> {

  final TextEditingController _codeController =
      TextEditingController();

  bool _checking = false;
  bool _isValid = false;


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


  void _checkGiftCard() async {

    if (_codeController.text.trim().isEmpty) return;

    setState(() {
      _checking = true;
      _isValid = false;
    });


    // Firebase checking later
    await Future.delayed(
      const Duration(seconds: 2),
    );


    setState(() {
      _checking = false;
      _isValid = true;
    });

  }


  @override
  Widget build(BuildContext context) {

    final themeColor = widget.themeColor;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness:
            Brightness.dark,
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
            'Claim Gift Card',
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


              // Gift Card Banner

              Container(

                width: double.infinity,

                padding:
                const EdgeInsets.all(24),

                decoration: BoxDecoration(

                  gradient: LinearGradient(

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

                      color: themeColor
                          .withOpacity(0.3),

                      blurRadius: 20,

                      offset:
                      const Offset(0, 8),

                    )

                  ],

                ),


                child: Column(

                  children: [

                    const Text(
                      '🎁',
                      style:
                      TextStyle(fontSize: 46),
                    ),

                    const SizedBox(height: 14),


                    Text(

                      'Have a Gift Card?',

                      style: _s(

                        size: 22,

                        weight:
                        FontWeight.w800,

                        color:
                        Colors.white,

                      ),

                    ),


                    const SizedBox(height: 6),


                    Text(

                      'Enter your gift card code\nand unlock rewards',

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



              Text(

                'Gift Card Number',

                style: _s(

                  size: 15,

                  weight:
                  FontWeight.w700,

                ),

              ),


              const SizedBox(height: 12),


              TextField(

                controller:
                _codeController,

                textCapitalization:
                TextCapitalization.characters,


                decoration: InputDecoration(

                  hintText:
                  'XXXX-XXXX-XXXX',

                  prefixIcon: Icon(

                    Icons.card_giftcard_rounded,

                    color:
                    themeColor,

                  ),

                  filled: true,

                  fillColor:
                  Colors.white,


                  border:
                  OutlineInputBorder(

                    borderRadius:
                    BorderRadius.circular(18),

                    borderSide:
                    BorderSide.none,

                  ),

                ),

              ),


              const SizedBox(height: 24),



              SizedBox(

                width:
                double.infinity,

                child:
                ElevatedButton(

                  onPressed:
                  _checking
                      ? null
                      : _checkGiftCard,


                  style:
                  ElevatedButton.styleFrom(

                    backgroundColor:
                    themeColor,

                    padding:
                    const EdgeInsets
                    .symmetric(
                      vertical: 16,
                    ),

                    shape:
                    RoundedRectangleBorder(

                      borderRadius:
                      BorderRadius
                      .circular(18),

                    ),

                  ),


                  child:
                  _checking

                  ? const SizedBox(

                    height: 22,
                    width: 22,

                    child:
                    CircularProgressIndicator(

                      color:
                      Colors.white,

                      strokeWidth: 2,

                    ),

                  )


                  : Text(

                    'Check & Claim',

                    style: _s(

                      size: 15,

                      weight:
                      FontWeight.w700,

                      color:
                      Colors.white,

                    ),

                  ),

                ),

              ),



              if(_isValid) ...[

                const SizedBox(height: 30),


                Container(

                  padding:
                  const EdgeInsets.all(18),

                  decoration:
                  BoxDecoration(

                    color: themeColor
                        .withOpacity(0.1),

                    borderRadius:
                    BorderRadius.circular(20),

                    border:
                    Border.all(

                      color: themeColor
                          .withOpacity(0.3),

                    ),

                  ),


                  child: Row(

                    children: [

                      Icon(

                        Icons.verified_rounded,

                        color:
                        themeColor,

                      ),

                      const SizedBox(width: 14),


                      Expanded(

                        child: Text(

                          'Gift Card Valid\n₹100 added successfully',

                          style: _s(

                            size: 14,

                            weight:
                            FontWeight.w600,

                          ),

                        ),

                      )

                    ],

                  ),

                )

              ],


            ],

          ),

        ),

      ),

    );

  }
}