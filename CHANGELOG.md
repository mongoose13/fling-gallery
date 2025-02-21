# Change Log for fling\_gallery

A Flutter widget that lays out its children in tight rows.

## [1.0.1]

### Added

- Tests for AStar layout strategy

### Changed

- Improvements in layout behavior for the AStar algorithm to avoid breaching parent size contracts

## [1.0.0]

### Changed

- The widget accepts a layout strategy, which has a specific interface
- The old layout logic became the Greedy algorithm layout strategy
- Example is fully functional app with both strategies showcased

### Added

- A* (A-Star) algorithm layout strategy

## [0.2.0]

### Added

- Parameter for maximum child count per row

### Fixed

- Report actual dimensions to parent instead of max dimensions
- Respect minimum and maximum sizes

## [0.1.0]

### Added

- Ability to force fill the bottom row

### Fixed

- Incorrect calculations on row length in some instances
- Layout bounds during intermediate layout steps causing errors

## [0.0.1]

### Added

- Initial implementation
- Readme
- Example
- Basic test suite
- CircleCI config

[Unreleased]: https://bitbucket.org/mongoose13/fling-gallery/commits/
[1.0.0]: https://bitbucket.org/mongoose13/fling-gallery/commits/tag/1.0.0
[0.2.0]: https://bitbucket.org/mongoose13/fling-gallery/commits/tag/0.2.0
[0.1.0]: https://bitbucket.org/mongoose13/fling-gallery/commits/tag/0.1.0
[0.0.1]: https://bitbucket.org/mongoose13/fling-gallery/commits/tag/0.0.1
