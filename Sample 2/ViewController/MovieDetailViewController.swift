//
//  MovieDetailViewController.swift
//  Sample 2
//
//  Created by TechUnity IOS Developer on 21/08/22.
//

import UIKit

class MovieDetailViewController: UIViewController {
    @IBOutlet weak var MoviePosterImageView: UIImageView!
    @IBOutlet weak var MovieTitleLable: UILabel!
    @IBOutlet weak var DurationLable: UILabel!
    @IBOutlet weak var ReleasedateLable: UILabel!
    @IBOutlet weak var LanguageLable: UILabel!
    @IBOutlet weak var GenresLable: UILabel!
    @IBOutlet weak var RatingLable: UILabel!
    @IBOutlet weak var aboutLable: UILabel!
    @IBOutlet weak var castLable: UILabel!
    var MovieID = 0
    var MovieTitle = ""
    var Duration = ""
    var Releasedate = ""
    var languages = ""
    var LanguageArray = [Launguage]()
    var GenreArray = [Genre]()
    var Rating = ""
    var Votes = 0
    var About = ""
    var Cast = ""
    var imageURl = ""
    var ImagePath = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        GeMovieInfo()
        MovieTitleLable.text = MovieTitle
        
        ReleasedateLable.attributedText = ("Release Date: "+Releasedate).withBoldText(text: "Release Date:")
        LanguageLable.text = languages
        RatingLable.attributedText = ("Rating: " + Rating + " / " + String(Votes)).withBoldText(text: "Rating:")
        print(About)
        aboutLable.text = About
        loadImage(imageview: MoviePosterImageView, imageString: "https://image.tmdb.org/t/p/original/\(ImagePath)")
    }
    func minutesToHoursAndMinutes(_ minutes: Int) -> (hours: Int , leftMinutes: Int) {
        return (minutes / 60, (minutes % 60))
    }
    func printHoursMinutesSeconds(_ minutes: Int) {
        let obj = minutesToHoursAndMinutes(minutes)
        DurationLable.attributedText = "Duration: \(obj.hours) Hours, \(obj.leftMinutes) Minutes".withBoldText(text: "Duration:")
    }
    // MARK:- Web Services
    func GeMovieInfo() {
        
        activityview = UIView(frame: UIApplication.shared.keyWindow!.bounds)
        UIApplication.shared.keyWindow?.addSubview(activityview)
        activityview.backgroundColor = UIColor.black
        activityview.alpha = 0.2
        activityIndicatorView = ActivityIndicatorView(title: "Loading...", center: self.view.center)
        UIApplication.shared.keyWindow?.addSubview(activityIndicatorView.getViewActivityIndicator())
        activityIndicatorView.startAnimating()
        guard let serviceUrl = URL(string:"https://api.themoviedb.org/3/movie/\(MovieID)?api_key=097bf4a3ad19e641aef85e73cceebbd3&language=en-US") else { return }
        
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "GET"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 90
        let session = URLSession.shared
        let task = session.dataTask(with: request) { [self] (data, response, error) in
            guard let data = data else{
                // Show error
                print("Error - ",error as Any)
                DispatchQueue.main.async(execute: {() -> Void in
                    activityview.removeFromSuperview()
                    activityIndicatorView.stopAnimating()
                    self.alert(title: "Error", message: "Error in fetching response")
                })
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200{
                let ststusCode = httpStatus.statusCode
                print("Status Code ",ststusCode)
                if httpStatus.statusCode == 404 {
                    DispatchQueue.main.async(execute: {() -> Void in
                        activityview.removeFromSuperview()
                        activityIndicatorView.stopAnimating()
                        self.alert(title: "Message", message: "Check your server connection.")
                    })
                    return
                    
                }else if httpStatus.statusCode == 400{
                    DispatchQueue.main.async(execute: {() -> Void in
                        activityview.removeFromSuperview()
                        activityIndicatorView.stopAnimating()
                        self.alert(title: "Error", message: "Server was unable to process request")
                    })
                    return
                }
                
                else{
                    // Show status code message error related to server
                    DispatchQueue.main.async(execute: {() -> Void in
                        activityview.removeFromSuperview()
                        activityIndicatorView.stopAnimating()
                        self.alert(title: "Error", message: "Could not process request \(ststusCode)")
                    })
                    return
                }
            }
            
            
            do {
                let Str_data = String(decoding: data, as: UTF8.self)
                print("Response for GET MovieINFO ", Str_data)
                let response = try JSONDecoder().decode(MovieInfo.self, from: data)
                GenreArray = response.genres
                LanguageArray = response.spoken_languages
                
                DispatchQueue.main.async(execute: { [self]() -> Void in
                    activityview.removeFromSuperview()
                    activityIndicatorView.stopAnimating()
                    printHoursMinutesSeconds(response.runtime ?? 0)
                    var GenreString = ""
                    for i in self.GenreArray
                    {
                        let name =  i.name
                        if GenreString == ""
                        {
                            GenreString = i.name ?? ""
                        }
                        else
                        {
                            GenreString = GenreString + ", " + (i.name ?? "")
                        }
                    }
                    self.GenresLable.attributedText = ("Genre: " + GenreString).withBoldText(text: "Genre:")
                })
                
            } catch {
                // Show Error Dialog
                // Could not process request
                DispatchQueue.main.async(execute: {() -> Void in
                    activityIndicatorView.stopAnimating()
                    self.alert(title: "Error", message: "Could not process request")
                    print(error)
                })
            }
            
        }
        
        task.resume()
        
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
extension String {
    func withBoldText(text: String, font: UIFont? = nil) -> NSAttributedString {
        let _font = font ?? UIFont.systemFont(ofSize: 14, weight: .regular)
        let fullString = NSMutableAttributedString(string: self, attributes: [NSAttributedString.Key.font: _font])
        let boldFontAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: _font.pointSize)]
        let range = (self as NSString).range(of: text)
        fullString.addAttributes(boldFontAttribute, range: range)
        return fullString
    }}
