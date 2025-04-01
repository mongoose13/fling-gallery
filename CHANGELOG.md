# Change Log for fling\_gallery

A Flutter widget that lays out its children in tight rows.

## [Unreleased]

### Fixed

- Use correct scaling for single items in rows where there is no solution (AStar)

## [1.0.3]

### Fixed

- Prevent infinote row ratios in both algorithms when zero-size children are added, which leads to invalid child placement during layout

## [1.0.2]

### Added

- More test cases for AStar

### Fixed

- A couple of issues with gallery sizing in AStar when the gallery is very narrow
- Prevent AStar gallery from reporting infinite height

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

[Unreleased]: https://github.com/mongoose13/fling-gallery/compare/v1.0.3...HEAD
[1.0.3]: https://github.com/mongoose13/fling-gallery/compare/v1.0.2...v1.0.3
[1.0.2]: https://github.com/mongoose13/fling-gallery/compare/v1.0.1...v1.0.2
[1.0.1]: https://github.com/mongoose13/fling-gallery/compare/v1.0.0...v1.0.1
[1.0.0]: https://github.com/mongoose13/fling-gallery/compare/v0.2.0...v1.0.0
[0.2.0]: https://github.com/mongoose13/fling-gallery/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/mongoose13/fling-gallery/compare/v0.0.1...v0.1.0
[0.0.1]: https://github.com/mongoose13/fling-gallery/tree/v0.0.1
