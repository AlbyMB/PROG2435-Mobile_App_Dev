class Quote {
    Quote({
        required this.author,
        required this.quote,
    });

    final String author;
    final String quote;

    factory Quote.fromJson(Map<String, dynamic> json){ 
        return Quote(
            author: json["author"] ?? "",
            quote: json["quote"] ?? "",
        );
    }

}
