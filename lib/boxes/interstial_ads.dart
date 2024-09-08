import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

//===========Intersial Ads Start Code=====================

final intarsitailAds = AdManagerInterstitialAd.load(

    // //real
    adUnitId: "ca-app-pub-4658221067173714/4091003843",

    // // //test
    // adUnitId: "ca-app-pub-3940256099942544/1033173712",
    request: const AdManagerAdRequest(),
    adLoadCallback: AdManagerInterstitialAdLoadCallback(
      // Called when an ad is successfully received.
      onAdLoaded: (ad) {
        ad.show();
      },
      // Called when an ad request failed.
      onAdFailedToLoad: (LoadAdError error) {
        debugPrint('AdManagerInterstitialAd failed to load: $error');
      },
    ));

  //===========Intersial Ads end Code=====================