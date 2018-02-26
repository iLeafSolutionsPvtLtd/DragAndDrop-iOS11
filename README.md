# Drag and Drop

Drag and drop for a table view.

To enable drag and drop, you specify the table view as its own drag delegate and drop delegate. To provide or consume data, you implement the drag and drop delegate methods.


### Enable Drag and Drop Interactions
To enable dragging, dropping, or both, specify a table view as its own drag or drop delegate.
This code enables both dragging and dropping:

``` swift
override func viewDidLoad() {
super.viewDidLoad()

tableView.dragDelegate = self
tableView.dropDelegate = self
}
```

Unlike a custom view, a table view does not have an `interactions` property to which you add interactions. Instead, a table view uses a drag delegate and a drop delegate directly.

### Provide Data for a Drag Session
To provide data for dragging from a table view, implement the [`tableView(_:itemsForBeginning:at:)`] method.

``` swift
func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
return model.dragItems(for: indexPath)
}
```

The following helper function, used by the `tableView(_:itemsForBeginning:at:)` method, serves as an interface to the data model in this sample code project:

``` swift
func dragItems(for indexPath: IndexPath) -> [UIDragItem] {
let placeName = placeNames[indexPath.row]

let data = placeName.data(using: .utf8)
let itemProvider = NSItemProvider()

itemProvider.registerDataRepresentation(forTypeIdentifier: kUTTypePlainText as String, visibility: .all) { completion in
completion(data, nil)
return nil
}

return [
UIDragItem(itemProvider: itemProvider)
]
}
```

### Consume Data from a Drop Session
To consume data from a drop session in a table view, you implement three delegate methods.

First, your app can refuse the drag items based on their class, the state of your app, or other requirements.

``` swift
func tableView(_ tableView: UITableView, canHandle session: UIDropSession) -> Bool {
return model.canHandle(session)
}
```

The following helper function, used by the [`tableView(_:canHandle:)`] method, serves as the interface to the data model:

``` swift
func canHandle(_ session: UIDropSession) -> Bool {
return session.canLoadObjects(ofClass: NSString.self)
}
```

Second, you must tell the system how you want to consume the data, which is typically by copying it. You specify this choice by way of a drop proposal:

``` swift
func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
// The .move operation is available only for dragging within a single app.
if tableView.hasActiveDrag {
if session.items.count > 1 {
return UITableViewDropProposal(operation: .cancel)
} else {
return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
}
} else {
return UITableViewDropProposal(operation: .copy, intent: .insertAtDestinationIndexPath)
}
}
```

Finally, after the user lifts their finger from the screen, indicating their intent to drop the drag items, your table view has one opportunity to request particular data representations of the drag items:

``` swift
/**
This delegate method is the only opportunity for accessing and loading
the data representations offered in the drag item. The drop coordinator
supports accessing the dropped items, updating the table view, and specifying
optional animations. Local drags with one item go through the existing
`tableView(_:moveRowAt:to:)` method on the data source.
*/
func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
let destinationIndexPath: IndexPath

if let indexPath = coordinator.destinationIndexPath {
destinationIndexPath = indexPath
} else {
// Get last index path of table view.
let section = tableView.numberOfSections - 1
let row = tableView.numberOfRows(inSection: section)
destinationIndexPath = IndexPath(row: row, section: section)
}

coordinator.session.loadObjects(ofClass: NSString.self) { items in
// Consume drag items.
let stringItems = items as! [String]

var indexPaths = [IndexPath]()
for (index, item) in stringItems.enumerated() {
let indexPath = IndexPath(row: destinationIndexPath.row + index, section: destinationIndexPath.section)
self.model.addItem(item, at: indexPath.row)
indexPaths.append(indexPath)
}

tableView.insertRows(at: indexPaths, with: .automatic)
}
}
```


## Drag and drop for a `UIImageView` instance.


This sample code project uses a [`UIImageView`]instance to show how any instance or subclass of the [`UIView`] class can act as a drag source or a drop destination.

To enable drag and drop, you add one or more interaction objects to a view. To provide or consume data, you implement the protocol methods in the interaction delegates.


### Enable Drag and Drop Interactions
To enable dragging, dropping, or both, attach interactions to views.

Add the drag interaction:
``` swift
let dragInteraction = UIDragInteraction(delegate: self)
imageView.addInteraction(dragInteraction)
```

Add the drop interaction:
``` swift
let dropInteraction = UIDropInteraction(delegate: self)
view.addInteraction(dropInteraction)
```

Enabling drag and drop for an image view, requires an additional step. You must explicitly enable user interaction, like this:
``` swift
imageView.isUserInteractionEnabled = true
```


### Provide Data for a Drag Session
The [`dragInteraction(_:itemsForBeginning:)`] method is the one essential method for allowing dragging from a view.

``` swift
func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
    guard let image = imageView.image else { return [] }

    let provider = NSItemProvider(object: image)
    let item = UIDragItem(itemProvider: provider)
    item.localObject = image
    
    /*
         Returning a non-empty array, as shown here, enables dragging. You
         can disable dragging by instead returning an empty array.
    */
    return [item]
}
```

The system calls this delegate method in response to the user gesture that initiates dragging. In your implementation, return an array of one or more drag items, each with one item provider. In each item provider, specify one or more data representations of the model object to be dragged. The model object must conform to the [`NSItemProviderWriting`] protocol.


### Consume Data from a Drop Session
To enable a view to consume data from a drop session, you implement three delegate methods.

First, your app can refuse the drag items based on their uniform type identifiers (UTIs), the state of your app, or other requirements. Here, the implementation allows a user to drop only a single item that conforms to the [`kUTTypeImage`] UTI:

``` swift
func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
    return session.hasItemsConforming(toTypeIdentifiers: [kUTTypeImage as String]) && session.items.count == 1
}
```

Second, you must tell the system how you want to consume the data, which is typically by copying it. You specify this choice by way of a drop proposal:

``` swift
func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
    let dropLocation = session.location(in: view)
    updateLayers(forDropLocation: dropLocation)

    let operation: UIDropOperation

    if imageView.frame.contains(dropLocation) {
        /*
             If you add in-app drag-and-drop support for the .move operation,
             you must write code to coordinate between the drag interaction
             delegate and the drop interaction delegate.
        */
        operation = session.localDragSession == nil ? .copy : .move
    } else {
        // Do not allow dropping outside of the image view.
        operation = .cancel
    }

    return UIDropProposal(operation: operation)
}
```

Finally, after the user lifts their finger from the screen, indicating their intent to drop the drag items, your view has one opportunity to request particular data representations of the drag items:

``` swift
func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
    // Consume drag items (in this example, of type UIImage).
    session.loadObjects(ofClass: UIImage.self) { imageItems in
        let images = imageItems as! [UIImage]

        /*
             If you do not employ the loadObjects(ofClass:completion:) convenience
             method of the UIDropSession class, which automatically employs
             the main thread, explicitly dispatch UI work to the main thread.
             For example, you can use `DispatchQueue.main.async` method.
        */
        self.imageView.image = images.first
    }

    // Perform additional UI updates as needed.
    let dropLocation = session.location(in: view)
    updateLayers(forDropLocation: dropLocation)
}
```


