//
//  ViewController.swift
//  Sample 2
//
//  Created by TechUnity IOS Developer on 19/08/22.
//

import UIKit

var activityview = UIView()
var activityIndicatorView: ActivityIndicatorView!

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
    
    @IBOutlet weak var MovieSearchBar: UISearchBar!
    @IBOutlet weak var MovieDetailTableview: UITableView!
    
    var MovieArray = [MovieDetails]()
    var FilterArray = [MovieDetails]()
    var isSearch = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GetAllMovies()
    }
    
    // MARK:- Tableview Delegate and DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearch == true
        {
            return FilterArray.count
        }
        else
        {
            return MovieArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        150
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MovieDetailTableViewCell
        shadowDrop(view: cell.MovieDetailBackgroundView)
        shadowDrop(view: cell.MovieImageview)
        if isSearch == true
        {
            cell.MovieTitle.text = FilterArray[indexPath.row].title
            cell.RatingLable.text = String(FilterArray[indexPath.row].vote_average ?? 0.0)
            loadImage(imageview: cell.MovieImageview, imageString: "https://image.tmdb.org/t/p/w780/"+(FilterArray[indexPath.row].poster_path ?? ""))
        }
        else
        {
            cell.MovieTitle.text = MovieArray[indexPath.row].title
            cell.RatingLable.text = String(MovieArray[indexPath.row].vote_average ?? 0.0)
            loadImage(imageview: cell.MovieImageview, imageString: "https://image.tmdb.org/t/p/w780/"+(MovieArray[indexPath.row].poster_path ?? ""))
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isSearch == true
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier:"MovieDetailViewController") as! MovieDetailViewController
            vc.MovieID = FilterArray[indexPath.row].id ?? 0
            vc.MovieTitle = FilterArray[indexPath.row].title
            vc.Rating = String(FilterArray[indexPath.row].vote_average ?? 0.0)
            vc.Votes = FilterArray[indexPath.row].vote_count ?? 0
            vc.About = FilterArray[indexPath.row].overview ?? ""
            vc.Releasedate = FilterArray[indexPath.row].release_date ?? ""
            vc.languages = FilterArray[indexPath.row].original_language ?? ""
            vc.ImagePath = FilterArray[indexPath.row].backdrop_path ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier:"MovieDetailViewController") as! MovieDetailViewController
            vc.MovieID = MovieArray[indexPath.row].id ?? 0
            vc.MovieTitle = MovieArray[indexPath.row].title
            vc.Rating = String(MovieArray[indexPath.row].vote_average ?? 0.0)
            vc.Votes = MovieArray[indexPath.row].vote_count ?? 0
            vc.About = MovieArray[indexPath.row].overview ?? ""
            vc.Releasedate = MovieArray[indexPath.row].release_date ?? ""
            vc.languages = MovieArray[indexPath.row].original_language ?? ""
            vc.ImagePath = MovieArray[indexPath.row].backdrop_path ?? ""
            //        vc.passtext = MovieArray[indexPath.row].title
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        
    }
    
    // MARK:- searchBarDelegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        FilterArray.removeAll(keepingCapacity: false)
        
        if MovieSearchBar.text == ""
        {
            MovieSearchBar.showsCancelButton = false
            FilterArray = MovieArray
        }
        else
        {
            MovieSearchBar.showsCancelButton = true
            let array1 = MovieArray.filter{((($0.title)).localizedCaseInsensitiveContains(MovieSearchBar.text ?? ""))}
            array1.forEach({print($0)})
            FilterArray = array1
            
        }
        
        isSearch = true
        
        self.MovieDetailTableview.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        self.MovieSearchBar.endEditing(true)
        MovieSearchBar.showsCancelButton = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        MovieSearchBar.text = ""
        isSearch = false
        MovieSearchBar.showsCancelButton = false
        searchBar.endEditing(true)
        MovieDetailTableview.reloadData()
    }
    
    // MARK:- Other Functions
    func shadowDrop(view:UIView)
    {
        view.layer.shadowColor = UIColor.darkGray.cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize.zero
        view.layer.cornerRadius = 7
        view.layer.shadowRadius = 3
    }
    
    // MARK:- Webservices
    func GetAllMovies() {
        
        activityview = UIView(frame: UIApplication.shared.keyWindow!.bounds)
        UIApplication.shared.keyWindow?.addSubview(activityview)
        activityview.backgroundColor = UIColor.black
        activityview.alpha = 0.2
        activityIndicatorView = ActivityIndicatorView(title: "Loading...", center: self.view.center)
        UIApplication.shared.keyWindow?.addSubview(activityIndicatorView.getViewActivityIndicator())
        activityIndicatorView.startAnimating()
        guard let serviceUrl = URL(string:"https://api.themoviedb.org/3/movie/popular?api_key=097bf4a3ad19e641aef85e73cceebbd3&language=en-US") else { return }
        
        print("Speciality Url ", serviceUrl)
        
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
                // let Str_data = request
                print("Response for GET Specialization ", Str_data)
                
                let specialityresponse = try JSONDecoder().decode(MovieResult.self, from: data)
                MovieArray = specialityresponse.results
                DispatchQueue.main.async(execute: {() -> Void in
                    activityview.removeFromSuperview()
                    activityIndicatorView.stopAnimating()
                    self.MovieDetailTableview.reloadData()
                    //                    self.specialityTableview.reloadData()
                    //                    self.specialityCollectionview.reloadData()
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
}
extension UIViewController{
    func alert(title: String, message: String){
        let alertcontroller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alertcontroller.addAction(okAction)
        self.present(alertcontroller, animated: true, completion: nil)
        
    }
    
    func loadImage(imageview:UIImageView,imageString:String)
    {
        let url = URL(string: imageString)
        if let data = try? Data(contentsOf: url!)
        {
            imageview.image = UIImage(data: data)
        }
    }
    
}
