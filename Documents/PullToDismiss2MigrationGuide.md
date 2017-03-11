# PullToDismiss 2 Migration Guide

PullToDismiss 2.0 has several breaking changes.

## change delegateProxy to delegate

- Aefore 2.0

```swift
pullToDismiss?.delegateProxy = self
```

- 2.0〜

```swift
pullToDismiss?.delegate = self
```

## Custom class (subclass) is no longer needed
Since PullToDismiss 2.0, all scroll view's delegate is available without creating custom class.

- Before 2.0

```swift
import PullToDismiss

class CustomPullToDismiss: PullToDismiss {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableViewDelegate?.tableView?(tableView, heightForRowAt: indexPath) ?? 44.0
    }
}

class SampleViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    private var pullToDismiss: PullToDismiss?
    override func viewDidLoad() {
        super.viewDidLoad()
        pullToDismiss = CustomPullToDismiss(scrollView: tableView)
        pullToDismiss?.delegateProxy = self
    }
}

extension SampleViewController: UITableViewDelegate {
    // called by CustomPullToDismiss
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 44.0 : 60.0
    }

    // ...
}
```

- 2.0〜

```swift
import PullToDismiss

class SampleViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    private var pullToDismiss: PullToDismiss?
    override func viewDidLoad() {
        super.viewDidLoad()
        pullToDismiss = PullToDismiss(scrollView: tableView)
        pullToDismiss?.delegate = self
    }
}

extension SampleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 44.0 : 60.0
    }
}
```
