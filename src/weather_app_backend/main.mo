import Debug "mo:base/Debug";
import Text "mo:base/Text";
import Blob "mo:base/Blob";
import Cycles "mo:base/ExperimentalCycles";
import Nat "mo:base/Nat";
import Nat64 "mo:base/Nat64";

actor class WeatherApp() = this {
    type HttpResponsePayload = {
        status : Nat;
        headers : [HttpHeader];
        body : Blob;
    };

    type HttpHeader = {
        name : Text;
        value : Text;
    };

    let ic : actor {
        http_request : shared {
            url : Text;
            max_response_bytes : ?Nat64;
            headers : [HttpHeader];
            body : ?Blob;
            method : { #get };
        } -> async HttpResponsePayload;
    } = actor("aaaaa-aa");

    public shared func getWeather(city : Text) : async Text {
        let api_key = "49f3f34e3073ab7df457349d693c4380";
        let url = "https://api.openweathermap.org/data/2.5/weather?q=" # city # "&appid=" # api_key # "&units=metric";

        Debug.print("Fetching weather for: " # city);
        
        try {
            Cycles.add(2_000_000_000_000);
            
            let response = await ic.http_request({
                url = url;
                max_response_bytes = ?(10 * 1024);
                headers = [{ name = "Accept"; value = "application/json" }];
                method = #get;
                body = null;
            });

            if (response.status == 200) {
                switch (Text.decodeUtf8(response.body)) {
                    case (?decoded) { decoded };
                    case null { "Error: Could not decode response" };
                }
            } else {
                "Error: HTTP status " # Nat.toText(response.status)
            }
        } catch err {
            Debug.print("Error making HTTP request");
            "Error: Failed to fetch weather data"
        }
    };

    public func wallet_receive() : async Nat {
        let available = Cycles.available();
        let accepted = Cycles.accept(available);
        accepted
    };
}