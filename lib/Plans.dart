import 'package:aqarat_flutter_project/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:aqarat_flutter_project/subscription_pageOne.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class PricingPlansPage extends StatelessWidget {
  final Locale myLocale;
  int? initialAmount;
  PricingPlansPage({super.key, required this.myLocale});
  
  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(      
      locale: myLocale,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
    home: Scaffold(
      
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          S.of(context).Plans,
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              S.of(context).BODREALESTATE,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
                letterSpacing: 1.5,
              ),
            ),
            SizedBox(height: 8),
            Text(
              S.of(context).ChooseTheBestPlan,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 24),

            // Plan 1 - $5
            PlanCard(
              price: '12,000 IQD',
              onPressed: () {
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (context) => PaymentPage(
                  MyLocale: myLocale,
                  initialAmount: 12000,
                  targetAccountValue: 2,
                  
                )));
              },
              services: [
                ServiceItem(name: S.of(context).AccessToApp, included: true),
                ServiceItem(name: S.of(context).AddAccessPost, included: true),
                ServiceItem(name: S.of(context).RequestCammeraSession, included: false),
                ServiceItem(name: S.of(context).ShowYourPostsAtTop, included: false),
                ServiceItem(name: S.of(context).BetterAppearence, included: false),
                // ServiceItem(name: 'Service 6', included: false),
              ],
            ),

            SizedBox(height: 16),

            // Plan 2 - $14
            PlanCard(
              price: '25,000 IQD',
              onPressed: () {
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (context) => PaymentPage(
                  MyLocale: myLocale,
                  initialAmount: 25000,
                  targetAccountValue: 3,
                  
                )));
              },
              services: [
                ServiceItem(name: S.of(context).AccessToApp, included: true),
                ServiceItem(name: S.of(context).AddAccessPost, included: true),
                ServiceItem(name: S.of(context).RequestCammeraSession, included: true),
                ServiceItem(name: S.of(context).ShowYourPostsAtTop, included: false),
                ServiceItem(name: S.of(context).BetterAppearence, included: false),
                // ServiceItem(name: 'Service 6', included: false),
              ],
            ),

            SizedBox(height: 16),

            // Plan 3 - $20
            PlanCard(
              price: '38,000 IQD',
              onPressed: () {
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (context) => PaymentPage(
                  MyLocale: myLocale,
                  initialAmount: 38000,
                  targetAccountValue: 4,
                  
                )));
              },
              services: [
                ServiceItem(name: S.of(context).AccessToApp, included: true),
                ServiceItem(name: S.of(context).AddAccessPost, included: true),
                ServiceItem(name: S.of(context).RequestCammeraSession, included: true),
                ServiceItem(name: S.of(context).ShowYourPostsAtTop, included: true),
                ServiceItem(name: S.of(context).BetterAppearence, included: true),
                // ServiceItem(name: 'Service 6', included: true),
              ],
            ),
          ],
        ),
      ),
    )
    );
  }
}

class PlanCard extends StatelessWidget {
  final String price;
  final List<ServiceItem> services;
  final VoidCallback onPressed;

  PlanCard({
    required this.price,
    required this.services,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF1A1D2E),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: EdgeInsets.all(24),
      child: Column(
        children: [
          Text(
            S.of(context).ServicesPrice,
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          SizedBox(height: 8),
          Text(
            price,
            style: TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),

          // Get Plan Button
          ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF3B82F6),
              minimumSize: Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              S.of(context).GetPlan,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),

          SizedBox(height: 20),

          // Services List
          ...services.map(
            (service) => Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    service.name,
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  Icon(
                    service.included ? Icons.check : Icons.close,
                    color: service.included ? Colors.white : Colors.white54,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ServiceItem {
  final String name;
  final bool included;

  ServiceItem({required this.name, required this.included});
}
