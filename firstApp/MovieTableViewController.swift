//
//  MovieTableViewController.swift
//  MoviesStory
//
//  Created by Кирилл Анисимов on 10.05.17.
//  Copyright © 2017 Кирилл Анисимов. All rights reserved.
//

import UIKit

class MovieTableViewController: UITableViewController {
    
    //MARK: Propierties
    var movies = [Movie]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem
        
        // Load and saved movies, otherwise load sample data.
        if let savedMovies = loadMovies(){
            movies += savedMovies
        }
        else{
            // Load the sample data.
            loadSampleMovie()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "MovieTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MovieTableViewCell else {
            fatalError("The dequeued cell is not an instance of MovieTableViewCell.")
        }
        
        // Fetch the appropriate movie for the data source layout.
        let movie = movies[indexPath.row]

        cell.nameLabel.text = movie.name
        cell.photoImageView.image = movie.photo
        cell.ratingControl.rating = movie.rating

        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    


    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            movies.remove(at: indexPath.row)
            saveMovies()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch (segue.identifier ?? "") {
        case "AddItem":
            print("Adding a new movie")
        case "ShowDetail":
            guard let movieDetailViewController = segue.destination as? MovieViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedMovieCell = sender as? MovieTableViewCell else {
                fatalError("Unexpected sender: \(sender ?? "")")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedMovieCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedMovie = movies[indexPath.row]
            movieDetailViewController.movie = selectedMovie
        default:
            fatalError("Unexpected Segue Identifier: \(String(describing: segue.identifier))")
        }
    }
 
    
    //MARK: Actions
    @IBAction func unwindToMovieList(sender: UIStoryboardSegue){
        
        if let sourceViewController = sender.source as? MovieViewController, let movie = sourceViewController.movie {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update the existing movie.
                movies[selectedIndexPath.row] = movie
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else{
                // Add new movie
                let newIndexPath = IndexPath(row: movies.count, section: 0)
                
                movies.append(movie)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            
            // Save the movies.
            saveMovies()
        }
    }

    //MARK: Private Methods
    private func loadSampleMovie(){
        let photo1 = UIImage(named: "movie1")
        let photo2 = UIImage(named: "movie2")
        let photo3 = UIImage(named: "movie3")
        
        guard let movie1 = Movie(name: "Побег из Шоушенка", photo: photo1, rating: 4) else {
            fatalError("Unable to instatiate movie1")
        }
        
        guard let movie2 = Movie(name: "Зеленая миля", photo: photo2, rating: 5) else {
            fatalError("Unable to instatiate movie2")
        }
        
        guard let movie3 = Movie(name: "Форес Гамп", photo: photo3, rating: 5) else {
            fatalError("Unable to instatiate movie3")
        }
        
        movies += [movie1, movie2, movie3]
    }
    
    private func saveMovies(){
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(movies, toFile: Movie.ArchiveURL.path)
        
        if isSuccessfulSave {
            print("Movie successefully saved.")
        }
        else{
            print("Failed to save movie.")
        }
    }
    
    private func loadMovies() -> [Movie]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Movie.ArchiveURL.path) as? [Movie]
    }

    
}
