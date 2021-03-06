---
slug: progressive-progressive-web-apps
date: 2017-07-04T13:20:31+01:00
title: "Progressive Progressive Web Apps"
description: "Building Progressive Web Apps progressively is possible. This is how I did it."
image_header: "/images/feeddeck.png"
tags: ['ssr', 'progressive web apps', 'pwa']
toc: true
---


मुझे [प्रोग्रेसिव वेब एप्स] पसंद है (0)। मुझे वह मॉडल पसंद है जो यह प्रदान करता है कि आप अच्छी, ठोस, भरोसेमंद वेब साइट्स और ऐप्स कैसे बनाते हैं। मुझे सिद्धांत मंच एपीआई - सेवा कार्यकर्ता पसंद है - जो पीडब्ल्यूए मॉडल को काम करने में सक्षम बनाता है।

हम जिन जाल में गिर गए हैं उनमें से एक है "[ऐप शैल](https://developers.google.com/web/fundamentals/architecture/app-shell)"। ऐप शैल मॉडल का कहना है कि आपकी साइट को आपके एप्लिकेशन का एक पूरा खोल प्रस्तुत करना चाहिए (ताकि ऑफ़लाइन होने पर भी अनुभव कुछ हो) और फिर आप सामग्री को कैसे और कब खींचें।

<figure><img src="/images/app-shell.png"><figcaption> ऐप शैल </figcaption></figure>

ऐप शैल मॉडल मोटे तौर पर "एसपीए" (सिंगल पेज ऐप) के अनुरूप है & mdash; आप खोल लोड करते हैं, फिर प्रत्येक अनुवर्ती नेविगेशन सीधे आपके पृष्ठ में जेएस द्वारा संभाला जाता है। यह कई मामलों में अच्छी तरह से काम करता है।

मुझे विश्वास नहीं है कि ऐप शैल * केवल * न ही सबसे अच्छा मॉडल है, और हमेशा आपकी पसंद स्थिति से स्थिति में भिन्न होती है; उदाहरण के लिए मेरा स्वयं का ब्लॉग एक सरल "स्टेल-व्हिल्स्ट-रेवालिडेट" पैटर्न का उपयोग करता है, क्योंकि प्रत्येक पृष्ठ को कैश किया जाता है क्योंकि आप साइट के चारों ओर नेविगेट करते हैं और अपडेट बाद में रीफ्रेश में प्रदर्शित किए जाएंगे; इस पोस्ट में मैं एक मॉडल का अन्वेषण करना चाहता हूं जिसे मैंने हाल ही में प्रयोग किया है।

# ऐप शैल या ऐप शैल नहीं

ऐप शैल के क्लासिक मॉडल में प्रगतिशील रेंडर का समर्थन करना लगभग असंभव है और मैं निम्न गुणों वाले सेवा कार्यकर्ता के साथ एक साइट बनाने के लिए एक वास्तविक "प्रगतिशील" मॉडल प्राप्त करना चाहता था:


* यह जेएस के बिना काम करता है
* यह तब काम करता है जब सेवा कर्मचारी के लिए कोई समर्थन नहीं होता है
* यह तेज़ है

मैंने एक ऐसा प्रोजेक्ट बनाकर इसे प्रदर्शित करने के लिए तैयार किया जिसे मैं हमेशा बनाना चाहता था: समाचार की एक नदी + TweetDeck हाइब्रिड। आरएसएस फ़ीड के दिए गए संग्रह के लिए उन्हें कॉलम फैशन में प्रस्तुत करें।

<figure><img src="/images/feeddeck.png"><figcaption> फ़ीड डेक - कृपया स्टाइल को अनदेखा करें </figcaption></figure>

सेवा कार्यकर्ता और प्रगतिशील वृद्धि के साथ प्रयोग करने के लिए "फ़ीड डेक" एक अच्छा संदर्भ अनुभव है। इसमें एक सर्वर प्रस्तुत घटक है, इसे उपयोगकर्ता को कुछ दिखाने के लिए "खोल" की आवश्यकता है और इसमें गतिशील रूप से जेनरेट की गई सामग्री है जिसे नियमित रूप से अपडेट करने की आवश्यकता होती है। आखिरकार क्योंकि यह एक निजी परियोजना है, मुझे उपयोगकर्ता कॉन्फ़िगरेशन और प्रमाणीकरण को सहेजने के लिए बहुत अधिक सर्वर आधारभूत संरचना की आवश्यकता नहीं है।

मैंने इनमें से अधिकांश हासिल किया और मैंने प्रक्रिया के दौरान बहुत कुछ सीखा है। कुछ चीजों को अभी भी जेएस की आवश्यकता है, लेकिन सिद्धांत में अनुप्रयोग जेएस के बिना काम करता है; मैं डोम एपीआई के साथ अधिक सामान्य होने के लिए नोडजेएस के लिए लंबा हूं; मैंने इसे पूरी तरह क्रोम ओएस पर [गड़बड़](https://glitch.com/edit/#!/feeddeck?path=public/sw.js) के साथ बनाया लेकिन यह अंतिम टुकड़ा एक और दिन के लिए एक कहानी है।

मैंने परियोजना में शुरुआती "वर्क्स" के कुछ परिभाषाओं को निर्धारित किया है।


* "यह जेएस के बिना काम करता है" & mdash; स्क्रीन पर सामग्री लोड होती है और भविष्य में जेएस के बिना काम कर रहे सबकुछ के लिए इसके लिए एक स्पष्ट रास्ता है (या यह स्पष्ट नहीं है कि यह सक्षम क्यों नहीं था)। मैं सिर्फ "नहीं" कह सकता हूं।
* "यह तब काम करता है जब सेवा कार्यकर्ता के लिए कोई समर्थन नहीं है" & mdash; सब कुछ लोड करना, काम करना और तेजस्वी होना चाहिए, लेकिन अगर मैं हर जगह ऑफ़लाइन काम नहीं करता तो मुझे खुशी है।

लेकिन यह एकमात्र कहानी नहीं थी, अगर हमारे पास एक सेवा कार्यकर्ता के लिए जेएस और समर्थन था, तो मुझे यह सुनिश्चित करने का जनादेश था:


* यह तुरंत लोड हो गया
* यह विश्वसनीय था और अनुमानित प्रदर्शन विशेषताओं है
* यह पूरी तरह से ऑफलाइन काम किया

मी culpa: यदि आप कोड को देखते हैं और आप इसे पुराने ब्राउज़र में चलाते हैं तो यह एक मजबूत मौका है कि यह काम नहीं करेगा, मैंने ES6 का उपयोग करना चुना है, हालांकि यह एक असुरक्षित बाधा नहीं है।

अगर हम जावास्क्रिप्ट सक्षम किए बिना एक अनुभव बनाने पर ध्यान केंद्रित करना चाहते थे तो यह मानता है कि हमें सर्वर पर जितना संभव हो उतना प्रस्तुत करना चाहिए।

आखिरकार, मेरे पास द्वितीयक लक्ष्य था: मैं यह जानना चाहता था कि आपके सेवा कर्मचारी और आप सर्वर के बीच तर्क साझा करना कितना व्यवहार्य था .... मैं झूठ बोलता हूं, यह वह चीज थी जो मुझे सबसे ज्यादा लाभ देती थी और बहुत से लाभ प्रगतिशील कहानी के पीछे से पीछे गिर गया।

# पहले क्या आया था। सर्वर या सेवा कर्मचारी?

यह दोनों एक ही समय में था। मुझे सर्वर से प्रस्तुत करना होगा, लेकिन क्योंकि सेवा कर्मचारी ब्राउज़र और नेटवर्क के बीच बैठता है, मुझे इस बारे में सोचना पड़ता था कि दोनों कैसे इंटरप्लेड किए गए थे।

मैं एक भाग्यशाली स्थिति में था कि मेरे पास बहुत से अद्वितीय सर्वर तर्क नहीं थे इसलिए मैं एक ही समय में समग्र रूप से समस्या से निपट सकता था। जिन सिद्धांतों का मैंने पालन किया था, वे इस बारे में सोचना चाहते थे कि मैं पृष्ठ के पहले प्रस्तुत करने के अनुभव के साथ क्या हासिल करना चाहता हूं (अनुभव जो हर उपयोगकर्ता को मिलेगा) और पेज के बाद के प्रस्तुतकर्ता (अनुभव जो उपयोगकर्ताओं को मिलेगा) दोनों के साथ और बिना सेवा कार्यकर्ता


** पहले प्रस्तुत करें ** & mdash; वहां कोई सेवा कर्मचारी उपलब्ध नहीं होगा, इसलिए मुझे यह सुनिश्चित करने की आवश्यकता थी कि पहले प्रस्तुत करने में जितना संभव हो उतना पृष्ठ सामग्री शामिल हो और इसे सर्वर पर जेनरेट किया गया हो।

यदि उपयोगकर्ता का एक ब्राउज़र है जो सेवा कार्यकर्ता का समर्थन करता है तो मैं कुछ दिलचस्प चीजें कर सकता हूं। मेरे पास सर्वर पर पहले से ही टेम्पलेट तर्क बनाया गया है और उनके बारे में कुछ खास नहीं है, तो वे सटीक उसी टेम्पलेट्स होना चाहिए जो मैं सीधे क्लाइंट पर उपयोग करूंगा। सेवा कर्मचारी टेम्पलेट्स को 'ऑनइंस्टॉल' समय पर ला सकता है और उन्हें बाद में उपयोग के लिए स्टोर कर सकता है।

<figure><img src="/images/wpt-feeddeck-first-load.png"><figcaption> फ़ीड डेक - पहला भार </figcaption></figure>


** सेवा कार्यकर्ता के बिना दूसरा प्रस्तुत ** ** mdash; यह बिल्कुल पहले प्रस्तुत करने की तरह कार्य करना चाहिए। हमें सामान्य HTTP कैशिंग से लाभ हो सकता है, लेकिन सिद्धांत समान है: अनुभव को जल्दी से प्रस्तुत करें।


** दूसरा _with_ सेवा कार्यकर्ता प्रस्तुत करें ** & mdash; इसे * बिल्कुल * पहले सर्वर की तरह कार्य करना चाहिए, लेकिन, सेवा कार्यकर्ता के अंदर सभी। मेरे पास पारंपरिक खोल नहीं है। यदि आप नेटवर्क को देखते हैं तो आप जो कुछ भी देखते हैं वह पूरी तरह से एक साथ एचटीएमएल: संरचना _and_ सामग्री है।

{{<figure src="/images/devtools-feeddeck-second-load.png" title="फ़ीड डेक & mdash; दूसरा लोड (सेवा कार्यकर्ता नियंत्रित)">}}

### "प्रस्तुत करें" & mdash; स्ट्रीमिंग हमारे दोस्त है

मैं जितना संभव हो उतना प्रगतिशील होने की कोशिश कर रहा था जिसका मतलब है कि मुझे सर्वर पर जितना संभव हो उतना प्रस्तुत करना होगा। मुझे एक चुनौती थी, अगर मैंने सभी आरएसएस फ़ीड से सभी डेटा विलय कर दिया तो पहला रेंडर आरएसएस फ़ीड के नेटवर्क अनुरोधों से अवरुद्ध हो जाएगा और इस प्रकार हम पहले रेंडर को धीमा कर देंगे।

मैंने निम्नलिखित पथ चुना है:


* पृष्ठ के प्रमुख को प्रस्तुत करें & mdash; यह अपेक्षाकृत स्थैतिक है और यह स्क्रीन पर प्राप्त करने के लिए जल्दी प्रदर्शन के साथ सहयोगी सहयोगी है।
* कॉन्फ़िगरेशन (कॉलम) और mdash के आधार पर पृष्ठ की संरचना प्रस्तुत करें; किसी दिए गए उपयोगकर्ता के लिए यह वर्तमान में स्थिर है और इसे उपयोगकर्ताओं के लिए तेज़ी से दिखाई देना महत्वपूर्ण है।
* कॉलम डेटा प्रस्तुत करें ** यदि ** हमारे पास सामग्री कैश और उपलब्ध सामग्री है, तो हम इसे सर्वर और सेवा कार्यकर्ता दोनों पर कर सकते हैं
* उस पृष्ठ के पाद लेख को प्रस्तुत करें जिसमें समय-समय पर पृष्ठ की सामग्री को गतिशील रूप से अद्यतन करने के लिए तर्क शामिल है।

इन बाधाओं को ध्यान में रखते हुए, सबकुछ एसिंक्रोनस होना चाहिए और मुझे जितनी जल्दी हो सके नेटवर्क पर सबकुछ निकालना होगा।

वेब पर स्ट्रीमिंग टेम्पलेटिंग लाइब्रेरीज़ की वास्तविक कमी है। मैंने अपने अच्छे दोस्त और सहयोगी सुरमा द्वारा [स्ट्रीमिंग-डॉट](https://github.com/surma/streaming-dot) का उपयोग किया जो टेम्पलेटिंग फ्रेमवर्क [डीओटी](https://github.com/olado/doT) का एक बंदरगाह है लेकिन अतिरिक्त जनरेटर के साथ ताकि यह नोड या डोम स्ट्रीम को लिख सके और ब्लॉक न हो पूरी सामग्री उपलब्ध है।

कॉलम डेटा को प्रस्तुत करना (यानी, फ़ीड में क्या था) सबसे महत्वपूर्ण टुकड़ा है और इस समय इस समय क्लाइंट पर पहले लोड के लिए जावास्क्रिप्ट की आवश्यकता होती है। प्रणाली को पहले लोड के लिए सर्वर पर सबकुछ प्रस्तुत करने में सक्षम होने के लिए स्थापित किया गया है, लेकिन मैंने नेटवर्क पर अवरुद्ध नहीं किया है।

यदि डेटा पहले से ही लाया जा चुका है और यह सेवा कार्यकर्ता में उपलब्ध है तो हम इसे तुरंत उपयोगकर्ता के पास निकाल सकते हैं भले ही यह जल्दी से बेवकूफ हो।

एआईएसएनसी होने पर सामग्री को प्रस्तुत करने के लिए कोड अपेक्षाकृत प्रक्रियात्मक है और पहले वर्णित मॉडल का पालन करता है: टेम्पलेट तैयार होने पर हम हेडर को धारा में प्रस्तुत करते हैं, फिर शरीर की सामग्री को स्ट्रीम में प्रस्तुत करते हैं जो बदले में सामग्री पर प्रतीक्षा कर सकता है उपलब्ध भी स्ट्रीम में फंस जाएगा और अंत में जब सबकुछ तैयार हो जाएगा तो हम पाद लेख में जोड़ देंगे और प्रतिक्रिया स्ट्रीम में फ्लश करेंगे।

नीचे वह कोड है जिसका मैं सर्वर और सेवा कार्यकर्ता पर उपयोग करता हूं।


```javascript
const root = (dataPath, assetPath) => {
  
  let columnData = loadData(`${dataPath}columns.json`).then(r => r.json());

  let headTemplate = getCompiledTemplate(`${assetPath}templates/head.html`);
  let bodyTemplate = getCompiledTemplate(`${assetPath}templates/body.html`);
  let itemTemplate = getCompiledTemplate(`${assetPath}templates/item.html`);
  
  let jsonFeedData = fetchCachedFeedData(columnData, itemTemplate);
  
  /*
   * Render the head from the cache or network
   * Render the body.
     * Body has template that brings in config to work out what to render
     * If we have data cached let's bring that in.
   * Render the footer - contains JS to data bind client request.
  */
  
  const headStream = headTemplate.then(render => render({ columns: columnData }));
  const bodyStream = jsonFeedData.then(columns => bodyTemplate.then(render => render({ columns: columns })));
  const footStream = loadTemplate(`${assetPath}templates/foot.html`);

  let concatStream = new ConcatStream;
  
  headStream.then(stream => stream.pipeTo(concatStream.writable, { preventClose:true }))
                .then(() => bodyStream)
                .then(stream => stream.pipeTo(concatStream.writable, { preventClose: true }))
                .then(() => footStream)
                .then(stream => stream.pipeTo(concatStream.writable));
  
  return Promise.resolve(new Response(concatStream.readable, { status: "200" }))
}
```


इस मॉडल के साथ, यह सेवा कार्यकर्ता में सर्वर * और * पर काम करने वाले उपरोक्त कोड और प्रक्रिया को प्राप्त करने के लिए वास्तव में अपेक्षाकृत सरल था।

## एकीकृत तर्क सर्वर और सेवा कार्यकर्ता तर्क & mdash; हुप्स और बाधाएं

सर्वर और क्लाइंट, नोड + एनपीएम पारिस्थितिक तंत्र और वेब जेएस पारिस्थितिक तंत्र के बीच साझा कोड आधार पर जाना निश्चित रूप से आसान नहीं था, जो आनुवंशिक रूप से समान जुड़वां हैं जो अलग-अलग परिवारों के साथ बड़े हुए हैं और जब वे अंत में मिलते हैं तो कई समानताएं होती हैं और कई मतभेदों को दूर करने की जरूरत है ... यह एक फिल्म के लिए एक अच्छा विचार की तरह लगता है।

मैंने परियोजना में वेब पसंद करना चुना। मैंने इस पर ध्यान दिया क्योंकि मैं उपयोगकर्ता के ब्राउज़र में कोड को बंडल और लोड नहीं करना चाहता, बल्कि मैं सर्वर पर उस हिट को ले सकता हूं (मैं इसे स्केल कर सकता हूं, उपयोगकर्ता नहीं कर सकता), इसलिए अगर एपीआई ' टी नोड में समर्थित है तो मुझे एक संगत शिम मिलना होगा।

यहां कुछ चुनौतियों का सामना करना पड़ा है।

### टूटा मॉड्यूल सिस्टम

चूंकि नोड और वेब पारिस्थितिक तंत्र दोनों बड़े हुए, इसलिए दोनों ने डिजाइन समय पर कोडिंग, सेगमेंटिंग और आयात करने के विभिन्न तरीकों का विकास किया। यह एक वास्तविक मुद्दा था जब मैं इस परियोजना को बनाने की कोशिश कर रहा था।

मैं ब्राउज़र में कॉमनजेएस नहीं चाहता था। मुझे जितना संभव हो उतना निर्माण टूलिंग से दूर रहने की एक अपरिहार्य इच्छा है और मुझे कैसे बंडल करने वाले कार्यों के बारे में मेरी घृणा में शामिल किया गया है, इसने मुझे कई विकल्प नहीं छोड़े।

ब्राउजर में मेरा समाधान फ्लैट 'आयातक' विधि का उपयोग करना था, यह काम करता है लेकिन यह बहुत विशिष्ट फाइल ऑर्डरिंग पर निर्भर है, जैसा कि सेवा कार्यकर्ता में देखा जा सकता है:


** sw.js **


```javascript
importScripts(`/scripts/router.js`);
importScripts(`/scripts/dot.js`);
importScripts(`/scripts/platform/web.js`);
importScripts(`/scripts/platform/common.js`);
importScripts(`/scripts/routes/index.js`);
importScripts(`/scripts/routes/root.js`);
importScripts(`/scripts/routes/proxy.js`);
```


और फिर नोड के लिए, मैंने एक ही फाइल में सामान्य कॉमनजेएस लोडिंग तंत्र का उपयोग किया, लेकिन मॉड्यूल आयात करने के लिए उन्हें सरल 'if` कथन के पीछे गेट किया गया।


```javascript
if (typeof module !== 'undefined' && module.exports) {
    var doT = require('../dot.js');
    ...
```


मेरा समाधान एक स्केलेबल समाधान नहीं है, यह काम करता है लेकिन मेरे कोड को भी अच्छी तरह से कोडित करता है, जो कोड मैं नहीं चाहता था।

मैं उस दिन की प्रतीक्षा करता हूं जहां नोड 'मॉड्यूल' का समर्थन करता है जो ब्राउज़र समर्थन करेगा ... हमें कुछ सरल, सौहार्दपूर्ण, साझा और स्केलेबल की आवश्यकता है।

यदि आप कोड को चेक करते हैं, तो आप इस पैटर्न को लगभग हर साझा फ़ाइल में उपयोग करेंगे और कई मामलों में इसकी आवश्यकता थी क्योंकि मुझे [WHATWG स्ट्रीम संदर्भ कार्यान्वयन](https://github.com/whatwg/streams/tree/master/reference-implementation) आयात करने की आवश्यकता थी।

### क्रॉस्ड स्ट्रीम

स्ट्रीम शायद सबसे महत्वपूर्ण आदिम हैं जो हमारे पास कंप्यूटिंग (और शायद कम से कम समझ में) हैं और नोड और वेब दोनों के पास अपने स्वयं के अलग-अलग समाधान हैं। यह इस परियोजना में निपटने के लिए एक दुःस्वप्न था और हमें वास्तव में एक एकीकृत समाधान (आदर्श डोम स्ट्रीम) पर मानकीकृत करने की आवश्यकता है।

सौभाग्य से [स्ट्रीम एपीआई](https://github.com/whatwg/streams/tree/master/reference-implementation) का पूर्ण कार्यान्वयन है जिसे आप नोड में ला सकते हैं, और आपको बस इतना करना है कि वेब स्ट्रीम -> नोड स्ट्रीम और नोड स्ट्रीम -> वेब से मानचित्र करने के लिए कुछ उपयोगिताएं लिखनी होंगी स्ट्रीम।


```javascript
const nodeReadStreamToWHATWGReadableStream = (stream) => {
    
  return new ReadableStream({
    start(controller) {
      stream.on('data', data => {
        controller.enqueue(data)
      });
      stream.on('error', (error) => controller.abort(error))
      stream.on('end', () => {
        controller.close();
      })
    }
  });
};

class FromWHATWGReadableStream extends Readable {
  constructor(options, whatwgStream) {
    super(options);
    const streamReader = whatwgStream.getReader();
    
    pump(this);

    function pump(outStream) {
      return streamReader.read().then(({ value, done }) => {
        if (done) {
          outStream.push(null);
          return;
        }

        outStream.push(value.toString());
        return pump(outStream);
      });
    }
  }
}
```


इन दो सहायक कार्यों का उपयोग केवल इस परियोजना के नोड पक्ष में किया जाता था और इन्हें मुझे नोड एपीआई में डेटा प्राप्त करने के लिए उपयोग किया जाता था जो WHATWG स्ट्रीम स्वीकार नहीं कर सकता था और इसी तरह WHATWG स्ट्रीम संगत एपीआई में डेटा पास करने के लिए जो नोड स्ट्रीम को समझ नहीं पाया था । मुझे विशेष रूप से नोड में 'fetch` API के लिए इसकी आवश्यकता थी।

एक बार जब मैंने स्ट्रीम को सॉर्ट किया था, तो अंतिम समस्या और असंगतता रूटिंग थी (संयोग से यह वह जगह है जहां मुझे सबसे ज्यादा स्ट्रीम की आवश्यकता होती है)।

### साझा रूटिंग

नोड पारिस्थितिकी तंत्र, विशेष रूप से एक्सप्रेस अविश्वसनीय रूप से प्रसिद्ध और आश्चर्यजनक रूप से मजबूत है, लेकिन हमारे पास ग्राहक और सेवा कार्यकर्ता के बीच एक साझा मॉडल नहीं है।

सालों पहले मैंने लिखा [लेवी रूट्स](https://github.com/PaulKinlan/leviroutes), एक साधारण ब्राउज़र साइड लाइब्रेरी जिसने एक्सप्रेसजेएस को मार्गों की तरह संभाला और इतिहास एपीआई में भी लगाया और 'ऑनशैशचेंज' एपीआई भी लगाया। कोई भी इसका इस्तेमाल नहीं करता लेकिन मैं खुश था। मैं cobwebs की धूल में कामयाब रहे (एक चिमटा या दो बनाओ) और इस आवेदन में इसे तैनात किया। नीचे दिए गए कोड को देखते हुए आप देखते हैं कि मेरा रूटिंग _nearly_ समान है।


** server.js **


```javascript
app.get('/', (req, res, next) => {
  routes['root'](dataPath, assetPath)
    .then(response => node.responseToExpressStream(res, response));         
});

app.get('/proxy', (req, res, next) => {
  routes['proxy'](dataPath, assetPath, req)
    .then(response => response.body.pipe(res, {end: true}));
})
```



** sw.js **


```javascript
// The proxy server '/proxy'
router.get(`${self.location.origin}/proxy`, (e) => {
  e.respondWith(routes['proxy'](dataPath, assetPath, e.request));
}, {urlMatchProperty: 'href'});

// The root '/'
router.get(`${self.location.origin}/$`, (e) => {
  e.respondWith(routes['root'](dataPath, assetPath));
}, {urlMatchProperty: 'href'});
```


मैं एक एकीकृत समाधान देखने के लिए _love_ होगा जो सेवा कार्यकर्ता 'onfetch` API को नोड में लाता है।

मैं एक "एक्सप्रेस" फ्रेमवर्क की तरह देखने के लिए _love_ भी करूंगा जो एकीकृत नोड और ब्राउज़र कोड अनुरोध रूटिंग। वहां केवल पर्याप्त मतभेद थे जिसका मतलब था कि मेरे पास हर जगह एक ही स्रोत नहीं हो सकता था। हम लगभग क्लाइंट और सर्वर पर लगभग समान मार्गों को संभाल सकते हैं, इसलिए हम इतने दूर नहीं हैं।

### रेंडर के बाहर कोई डोम नहीं है

जब उपयोगकर्ता के पास कोई सेवा कर्मचारी उपलब्ध नहीं होता है, तो साइट के लिए तर्क काफी पारंपरिक है, हम सर्वर पर साइट प्रस्तुत करते हैं और फिर पारंपरिक AJAX मतदान के माध्यम से पृष्ठ में सामग्री को लगातार रीफ्रेश करते हैं।

तर्क 'आरओएम फ़ीड को उस चीज़ में बदलने के लिए' डोमपार्सर 'एपीआई का उपयोग करता है जिसे मैं फ़िल्टर कर सकता हूं और पेज में क्वेरी कर सकता हूं।


```javascript
// Get the RSS feed data.
fetch(`/proxy?url=${feedUrl}`)
      .then(feedResponse => feedResponse.text())
      // Convert it in to DOM
      .then(feedText => {
        const parser = new DOMParser();
        return parser.parseFromString(feedText,'application/xml');
      })
      // Find all the news items
      .then(doc => doc.querySelectorAll('item'))
      // Convert to an array
      .then(items => Array.prototype.map.call(items, item => convertRSSItemToJSON(item)))
      // Don't add in items that already exist in the page
      .then(items => items.filter(item => !!!(document.getElementById(item.guid))))
      // DOM Template.
      .then(items => items.map(item => applyTemplate(itemTemplate.cloneNode(true), item)))
      // Add it into the page
      .then(items => items.forEach(item => column.appendChild(item)))
```


ब्राउज़र में मानक एपीआई का उपयोग करके आरएसएस फ़ीड के डीओएम तक पहुंचने के लिए अविश्वसनीय रूप से उपयोगी था और इसने मुझे पृष्ठ को गतिशील रूप से अपडेट करने के लिए अपने स्वयं के टेम्पलेटिंग तंत्र (जिसे मुझे गर्व है) का उपयोग करने की अनुमति दी।


```html
<template id='itemTemplate'>
  <div class="item" data-bind_id='guid'>
    <h3><span data-bind_inner-text='title'></span> (<a data-bind_href='link'>#</a>)</h3>
    <div data-bind_inner-text='pubDate'></div>
  </div>
</template>
<script>
  
const applyTemplate = (templateElement, data) => {
  const element = templateElement.content.cloneNode(true);    
  const treeWalker = document.createTreeWalker(element, NodeFilter.SHOW_ELEMENT, () => NodeFilter.FILTER_ACCEPT);

  while(treeWalker.nextNode()) {
    const node = treeWalker.currentNode;
    for(let bindAttr in node.dataset) {
      let isBindableAttr = (bindAttr.indexOf('bind_') == 0) ? true : false;
      if(isBindableAttr) {
        let dataKey = node.dataset[bindAttr];
        let bindKey = bindAttr.substr(5);
        node[bindKey] = data[dataKey];
      }
    }
  }

  return element;
};
</script>
```


मैं तब तक खुद से बहुत खुश था जब तक मुझे एहसास हुआ कि मैं सर्वर पर या सेवा कार्यकर्ता में इसका उपयोग नहीं कर सका। एकमात्र समाधान जो मेरे पास था [कस्टम पार्सर](https://www.npmjs.com/package/xml-parser) लाने और HTML उत्पन्न करने के लिए चलना था। इसमें कुछ जटिलता शामिल हुई और मुझे वेब को शाप देने में छोड़ दिया।

लंबे समय तक मुझे कुछ और डीओएम एपीआई को श्रमिकों में लाया गया और नोड में भी समर्थन करना अच्छा लगेगा, लेकिन समाधान जो मैंने किया है, भले ही यह इष्टतम न हो।

# क्या यह संभव है?

इस पोस्ट में वास्तव में दो प्रश्न हैं:


* क्या यह एक सामान्य सर्वर और सेवा कार्यकर्ता साझा करने के लिए सिस्टम बनाने के लिए व्यावहारिक है?
* क्या यह पूरी तरह से प्रगतिशील प्रगतिशील वेब ऐप बनाना संभव है?

## क्या यह एक सामान्य सर्वर और सेवा कार्यकर्ता साझा करने के लिए सिस्टम बनाना व्यावहारिक है?

सिस्टम को एक सामान्य सर्वर और सेवा कार्यकर्ता साझा करना संभव है लेकिन क्या यह व्यावहारिक है? मुझे विचार पसंद है, लेकिन मुझे लगता है कि इसे और अधिक शोध की आवश्यकता है क्योंकि यदि आप जेएस जा रहे हैं, तो नोड और वेब प्लेटफ़ॉर्म के बीच बहुत सारे मुद्दे हैं जिन्हें लोहे से बाहर करने की आवश्यकता है।

व्यक्तिगत रूप से मैं नोड पारिस्थितिकी तंत्र में और अधिक "वेब" एपीआई देखना पसंद करूंगा।

## क्या यह पूरी तरह से प्रगतिशील प्रगतिशील वेब ऐप बनाना संभव है?

हाँ।

मुझे बहुत खुशी है कि मैंने यह किया। यहां तक ​​कि यदि आप क्लाइंट पर सेवा के समान भाषा साझा नहीं करते हैं, तो ऐसी कई महत्वपूर्ण चीजें हैं जो मुझे लगता है कि मैं दिखा सकता हूं।

1. AppShell एकमात्र मॉडल नहीं है जिसका आप अनुसरण कर सकते हैं, महत्वपूर्ण बात यह है कि सेवा कार्यकर्ता _you_ नेटवर्क पर नियंत्रण प्राप्त करता है और _you_ यह तय कर सकता है कि आपके उपयोग के मामले में सबसे अच्छा क्या है। 2. एक प्रगतिशील रूप से प्रदान किया गया अनुभव बनाना संभव है जो सेवा कार्यकर्ता का प्रदर्शन और लचीलापन लाने के साथ-साथ आपको पसंद होने पर स्थापित अनुभव भी प्रदान करता है। आपको समग्र रूप से सोचने की ज़रूरत है, आपको पहले सर्वर पर जितना हो सके उतना प्रतिपादन शुरू करना होगा और फिर ग्राहक में नियंत्रण रखना होगा। 3. एक सामान्य कोड बेस, एक सामान्य रूटिंग संरचना और क्लाइंट, सेवा कार्यकर्ता और सर्वर पर साझा सामान्य तर्क के साथ "ट्रिसोमोर्फिक" (मुझे अभी भी लगता है कि यह शब्द आइसोमोर्फिक सर्वोत्तम है) के अनुभवों के बारे में सोचना संभव है।

मैं इसे अंतिम विचार के रूप में छोड़ देता हूं: हमें प्रगतिशील वेब ऐप्स बनाने के तरीके के बारे में और अधिक जांच करने की आवश्यकता है और हमें उन पैटर्नों पर दबाव डालने की आवश्यकता है जो हमें वहां पहुंचने दें। AppShell एक महान शुरुआत थी, यह अंत नहीं है। प्रगतिशील प्रतिपादन और वृद्धि वेब की दीर्घकालिक सफलता की कुंजी है, कोई दूसरा माध्यम यह और साथ ही वेब भी कर सकता है।

यदि आप कोड में रूचि रखते हैं, [इसे गीथूब पर देखें](https://github.com/PaulKinlan/streaming-server-sw-demo) लेकिन आप इसके साथ भी खेल सकते हैं [सीधे और गड़बड़ पर इसे रीमिक्स करें](https://glitch.com/edit/#!/feeddeck)
