import 'package:flutter/material.dart';

import '/features/custom_colors.dart';

class Tier {
  final String tierName;
  final List<String> benefits;
  final Color color;
  final int minPoints;

  Tier({
    required this.tierName,
    required this.benefits,
    required this.color,
    required this.minPoints,
  });
}

class TierCard extends StatelessWidget {
  final Tier tier;
  final double progress;
  final int points;
  final int nextPoints;

  TierCard(
      {required this.tier,
      required this.progress,
      required this.points,
      required this.nextPoints});

  Widget _benefitInformationLayout(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 16,
        color: Colors.black54,
      ),
      softWrap: true,
      overflow: TextOverflow.visible,
    );
  }

  Widget _buildOcean() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 15),
        _benefitInformationLayout(
            '1. Priority Boarding: Board the plane early to ensure overhead storage space and a comfortable boarding process.'),
        SizedBox(height: 15),
        _benefitInformationLayout(
            '2. Extra Baggage Allowance: Enjoy an additional baggage allowance for longer trips or extra luggage needs.'),
      ],
    );
  }

  Widget _buildLand() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 15),
        _benefitInformationLayout(
            '1. Lounge Access: Relax in exclusive airport lounges with free Wi-Fi, snacks, and a calm atmosphere before your flight.'),
        SizedBox(height: 15),
        _benefitInformationLayout(
            '2. Priority Check-in: Skip the regular check-in lines with a dedicated counter for faster service.'),
      ],
    );
  }

  Widget _buildMountain() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 15),
        _benefitInformationLayout(
            '1. Free Upgrades: Enjoy complimentary upgrades to premium seating or cabins whenever available.'),
        SizedBox(height: 15),
        _benefitInformationLayout(
            '2. Exclusive Offers: Access special discounts, early sales, and unique promotions reserved for this tier.'),
      ],
    );
  }

  Widget _buildSky() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 15),
        _benefitInformationLayout(
            '1. Complimentary Service: Receive free in-flight services such as meals, drinks, and entertainment upgrades.'),
        SizedBox(height: 15),
        _benefitInformationLayout(
            '2. Early Access to Tickets: Be the first to purchase tickets, ensuring access to the best routes and seats.'),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [hawaiianPink, alaskaBlue],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.2),
          ),
        ),
        Positioned(
            top: 45.0,
            left: 20.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tiers',
                  style: TextStyle(
                    fontSize: 28.0,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Jomolhari',
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  'Current Points: $points points',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.white70,
                    fontFamily: 'Jomolhari',
                  ),
                ),
              ],
            )),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                  color: Colors.white,
                  margin: const EdgeInsets.symmetric(horizontal: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  elevation: 4.0,
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    height: 630,
                    width: double.infinity,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              tier.tierName,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: tier.benefits
                                .map((benefit) => Text(benefit))
                                .toList(),
                          ),
                        ),
                        SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '$nextPoints points',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        LinearProgressIndicator(
                          value: progress,
                          color: tier.color,
                          backgroundColor: tier.color.withOpacity(0.5),
                        ),
                        SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Benefits Information',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            const SizedBox(height: 16.0),
                            if (tier.tierName == 'Ocean') ...[
                              Expanded(child: _buildOcean())
                            ],
                            if (tier.tierName == 'Land') ...[
                              Expanded(child: _buildLand())
                            ],
                            if (tier.tierName == 'Mountain') ...[
                              Expanded(child: _buildMountain())
                            ],
                            if (tier.tierName == 'Sky') ...[
                              Expanded(child: _buildSky())
                            ],
                          ],
                        )
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ],
    ));
  }
}

class Tiers extends StatelessWidget {
  final List<Tier> tiers = [
    Tier(
      tierName: 'Ocean',
      benefits: ['Priority Boarding', 'Extra Baggage Allowance'],
      color: Colors.blueAccent,
      minPoints: 0,
    ),
    Tier(
      tierName: 'Land',
      benefits: ['Lounge Access', 'Priority Check-in'],
      color: Colors.green,
      minPoints: 1000,
    ),
    Tier(
      tierName: 'Mountain',
      benefits: ['Free Upgrades', 'Exclusive Offers'],
      color: Colors.orange,
      minPoints: 2000,
    ),
    Tier(
      tierName: 'Sky',
      benefits: ['Complimentary Service', 'Early Access to Tickets'],
      color: Colors.blue,
      minPoints: 5000,
    ),
  ];

  final int points = 1250; // Edit amount of miles here.

  @override
  Widget build(BuildContext context) {
    Tier currentTier = tiers.first;
    Tier nextTier = tiers.last;
    double progress = 0.0;

    for (int i = 0; i < tiers.length; i++) {
      if (points >= tiers[i].minPoints) {
        currentTier = tiers[i];
        if (i < tiers.length - 1) {
          nextTier = tiers[i + 1];
        }
      }
    }

    if (points < nextTier.minPoints) {
      progress = (points - currentTier.minPoints) /
          (nextTier.minPoints - currentTier.minPoints);
    } else {
      progress = 1.0;
    }

    return Scaffold(
      body: Center(
        child: TierCard(
            tier: currentTier,
            progress: progress,
            points: points,
            nextPoints: nextTier.minPoints),
      ),
    );
  }
}
