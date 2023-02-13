const kLoading = ("assets/animation/loading.json");
const kLoadings = ("assets/animation/jsonloading.json");
const String text ='Créé et implanté à Libreville en 2017, le Groupe audiovisuel panafricain international LABEL TELEVISION ET RADIO s’est résolument positionné comme une Vitrine de l’Afrique Emergente avec un enracinement au cœur du Continent et son ouverture aux diverses aires géographiques et culturelles.';
//String API_Key = 'AIzaSyD-flz-Q20zpjIadgDpHJqhLDmuBrZSeS8';
String API_Key = 'AIzaSyDNYc6e906fgd6ZkRY63aMLCSQS0trbsew';
String API_CHANEL = 'UCZX0q49y3Sig3p-yS0IfDIg';

String smallSentence(String bigSentence){
  if(bigSentence.length > 33){
    return bigSentence.substring(0,33) + '...' +'\n';
  }
  else{
    return bigSentence;
  }
}
String smallSentences(){
  if(text.length > 200){
    return text.substring(0,200) + '...';
  }
  else{
    return text;
  }
}


