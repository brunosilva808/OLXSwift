import UIKit

class PageViewController: UIPageViewController {

    var rowSelected: Int!
    var array: [Response.Resource]!
    private var pages: [UIViewController] = []

    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: style, navigationOrientation: navigationOrientation, options: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        self.rowSelected = nil
        self.array = nil
        self.pages = []
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataSource = self
        self.delegate = self
        
        let detailViewController = DetailViewController()
        detailViewController.resource = self.array[rowSelected]
        self.pages.append(detailViewController)
        setViewControllers([self.pages.first!], direction: .forward, animated: true, completion: nil)
    }

}

extension PageViewController: UIPageViewControllerDataSource {

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if self.rowSelected != 0 {
            let detailViewController = DetailViewController()
            detailViewController.resource = self.array[self.rowSelected - 1]
            self.rowSelected -= 1
            self.pages.insert(detailViewController, at: 0)
        }
        
        guard let viewControllerIndex = pages.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil//pages.last
        }
        
        guard pages.count > previousIndex else {
            return nil
        }
        
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {

        if self.rowSelected == self.pages.count - 1
        && self.array.count != self.rowSelected + 1 {

            let detailViewController = DetailViewController()
            detailViewController.resource = self.array[self.rowSelected + 1]
            self.rowSelected += 1
            self.pages.append(detailViewController)
        }
        
        guard let viewControllerIndex = pages.index(of: viewController) else {
                return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        
//        guard nextIndex < pages.count else {
//            return pages.first
//        }
        
        guard pages.count > nextIndex else {
            return nil
        }
        
        return pages[nextIndex]
    }

}

extension PageViewController: UIPageViewControllerDelegate {}
