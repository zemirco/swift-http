
import Foundation



/**
 * HTTP
 */
public class HTTP {
    
    public typealias Response = (AnyObject, NSHTTPURLResponse?, NSError?) -> Void
    
    public enum Method: String {
        case GET    = "GET"
        case POST   = "POST"
        case PUT    = "PUT"
        case HEAD   = "HEAD"
        case DELETE = "DELETE"
    }
    
    private var request: NSMutableURLRequest
    
    
    
    /**
     * Init
     */
    public init(method: Method, url: String) {
        self.request = NSMutableURLRequest(URL: NSURL(string: url)!)
        self.request.HTTPMethod = method.rawValue
    }
    
    
    
    /**
     * Class funcs
     */
    
    // GET
    public class func get(url: String) -> HTTP {
        return HTTP(method: .GET, url: url)
    }
    
    public class func get(url: String, done: Response) -> HTTP {
        return HTTP.get(url).end(done)
    }
    
    // POST
    public class func post(url: String) -> HTTP {
        return HTTP(method: .POST, url: url)
    }
    
    public class func post(url: String, data: AnyObject, done: Response) -> HTTP {
        return HTTP.post(url).send(data).end(done)
    }
    
    public class func post(url: String, done: Response) -> HTTP {
        return HTTP.post(url).end(done)
    }
    
    // PUT
    public class func put(url: String) -> HTTP {
        return HTTP(method: .PUT, url: url)
    }
    
    public class func put(url: String, data: AnyObject, done: Response) -> HTTP {
        return HTTP.put(url).send(data).end(done)
    }
    
    
    
    /**
     * Methods
     */
    public func send(data: AnyObject) -> HTTP {
        var error: NSError?
        self.request.HTTPBody = NSJSONSerialization.dataWithJSONObject(data, options: nil, error: &error)
        self.request.addValue("application/json", forHTTPHeaderField: "Accept")
        self.request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        return self
    }
    
    public func end(done: Response) -> HTTP {
        var session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(self.request) { data, response, error in
            
            // we have an error -> maybe connection lost
            if error != .None {
                done(data, .None, error)
                return
            }
            
            // request was success
            var error: NSError?
            var json: AnyObject!
            if data != .None {
                json = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &error)
            }
            let res = response as! NSHTTPURLResponse
            done(json, res, error)
        }
        task.resume()
        return self
    }
    
}