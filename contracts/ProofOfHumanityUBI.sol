/**
 *  @authors: [@epiqueras]
 *  @reviewers: []
 *  @auditors: []
 *  @bounties: []
 *  @deployments: []
 */
// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.7.3;

/**
 * @title ERC20 Interface
 * @dev See https://github.com/ethereum/EIPs/issues/20.
 */
interface IERC20 {
    function approve(address spender, uint256 value) external returns (bool);

    function transfer(address to, uint256 value) external returns (bool);
}

/**
 * @title ProofOfHumanity Interface
 * @dev See https://github.com/Proof-Of-Humanity/Proof-Of-Humanity.
 */
interface IProofOfHumanity {
    enum Status {None, Vouching, PendingRegistration, PendingRemoval}

    function getSubmissionInfo(address _submissionID)
        external
        view
        returns (
            Status status,
            uint64 submissionTime,
            uint64 renewalTimestamp,
            uint64 index,
            bool registered,
            bool hasVouched,
            uint256 numberOfRequests
        );
}

/**
 *  @title Proof Of Humanity Universal Basic Income (UBI)
 *  @dev This contract provides a UBI to registered members
 *  of the Proof Of Humanity contract.
 */
contract ProofOfHumanityUBI {
    /* Events */

    /** @dev Emitted when UBI is withdrawn or taken by a reporter.
     *  @param _recipient The accruer of the UBI.
     *  @param _beneficiary The withdrawer or taker.
     *  @param _value The value withdrawn.
     */
    event Withdrawal(
        address indexed _recipient,
        address indexed _beneficiary,
        uint256 _value
    );

    /* Constructor Storage */

    /// @dev The contract's governor.
    address public governor = msg.sender;

    /// @dev The token the UBI is paid with.
    IERC20 public token;
    /// @dev The Proof Of Humanity registry to reference.
    IProofOfHumanity public proofOfHumanity;

    /* Governable Storage */

    /// @dev How much of the token is accrued per block.
    uint256 public accruedPerBlock;

    /* Logic Storage */

    /// @dev Mapping of addresses to the block number when they started accruing UBI.
    mapping(address => uint256) public accruingSinceBlock;

    /* Modifiers */

    modifier onlyByGovernor() {
        require(governor == msg.sender, "The caller is not the governor.");
        _;
    }

    modifier isAccruing(address _submissionID, bool _accruing) {
        bool accruing = accruingSinceBlock[_submissionID] != 0;
        require(
            accruing == _accruing,
            accruing
                ? "The submission is already accruing UBI."
                : "The submission is not accruing UBI."
        );
        _;
    }

    modifier isRegistered(address _submissionID, bool _registered) {
        (, , , , bool registered, , ) = proofOfHumanity.getSubmissionInfo(
            _submissionID
        );
        require(
            registered == _registered,
            registered
                ? "The submission is still registered in Proof Of Humanity."
                : "The submission is not registered in Proof Of Humanity."
        );
        _;
    }

    /** @dev Constructor.
     *  @param _token The token the UBI is paid with.
     *  @param _proofOfHumanity The Proof Of Humanity registry to reference.
     *  @param _accruedPerBlock How much of the token is accrued per block.
     */
    constructor(
        IERC20 _token,
        IProofOfHumanity _proofOfHumanity,
        uint256 _accruedPerBlock
    ) {
        token = _token;
        proofOfHumanity = _proofOfHumanity;

        accruedPerBlock = _accruedPerBlock;
    }

    /* Governance */

    /** @dev Changes `accruedPerBlock` to `_accruedPerBlock`.
     *  @param _accruedPerBlock How much of the token is accrued per block.
     */
    function changeAccruedPerBlock(uint256 _accruedPerBlock)
        external
        onlyByGovernor
    {
        accruedPerBlock = _accruedPerBlock;
    }

    /* External */

    /** @dev Starts accruing UBI for a registered submission.
     *  @param _submissionID The submission ID.
     */
    function startAccruing(address _submissionID)
        external
        isRegistered(_submissionID, true)
        isAccruing(_submissionID, false)
    {
        accruingSinceBlock[_submissionID] = block.number;
    }

    /** @dev Withdraws accrued UBI for a registered submission.
     *  @param _submissionID The submission ID.
     */
    function withdrawAccrued(address _submissionID)
        external
        isRegistered(_submissionID, true)
        isAccruing(_submissionID, true)
    {
        uint256 accrued = getAccruedValue(_submissionID);
        accruingSinceBlock[_submissionID] = block.number;

        token.transfer(_submissionID, accrued);
        emit Withdrawal(_submissionID, _submissionID, accrued);
    }

    /** @dev Allows anyone to report a submission that
     *  should no longer receive UBI due to removal from the
     *  Proof Of Humanity registry. The reporter receives any
     *  leftover accrued UBI.
     *  @param _submissionID The submission ID.
     */
    function reportRemoval(address _submissionID)
        external
        isRegistered(_submissionID, false)
        isAccruing(_submissionID, true)
    {
        uint256 accrued = getAccruedValue(_submissionID);
        accruingSinceBlock[_submissionID] = 0;

        token.transfer(msg.sender, accrued);
        emit Withdrawal(_submissionID, msg.sender, accrued);
    }

    /* Public Views */

    /** @dev Calculates how much UBI a submission has available for withdrawal.
     *  @param _submissionID The submission ID.
     *  @return accrued The available UBI for withdrawal.
     */
    function getAccruedValue(address _submissionID)
        public
        view
        returns (uint256 accrued)
    {
        if (accruingSinceBlock[_submissionID] == 0) return 0;
        return
            (block.number - accruingSinceBlock[_submissionID]) *
            accruedPerBlock;
    }
}
