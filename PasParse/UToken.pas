unit UToken;

interface

uses
  UTokenType, ULocation, UASTNode;

type
  /// Represents a token including it's text, positions and token type
  TToken = class(TASTNode)
  private
    FLocation: TLocation;
    FEndLocation: TLocation;
    FParsedText: string;
    FText: string;
    FTokenType: TTokenType;

  protected
    function GetLocation: TLocation; override;
    function GetEndLocation: TLocation; override;

  public
    /// Standard constructor
    constructor Create(ATokenType: TTokenType; ALocation: TLocation;
                       AText, AParsedText: string);
    destructor Destroy; override;

    function InspectTo(AIndentCount: Integer): string; override;

    /// Parsed text if available, otherwise empty string ''
    property ParsedText: string read FParsedText;
    /// Textual representation of the token
    property Text: string read FText;
    /// Type of the token
    property TokenType: TTokenType read FTokenType;

    /// Creates a copy of the token with another token type.
    ///  The caller has to destroy the resulting object again!
    function WithTokenType(ATokenType: TTokenType): TToken;
  end;

implementation

uses
  TypInfo;

{ TToken }

constructor TToken.Create(ATokenType: TTokenType; ALocation: TLocation; AText,
  AParsedText: string);
begin
  FTokenType := ATokenType;
  FLocation := ALocation;
  FText := AText;
  FParsedText := AParsedText;

  // Create a new TLocation instance at the end position of the token
  FEndLocation := TLocation.Create(FLocation.FileName, FLocation.FileSource,
    FLocation.Offset + Length(FText));
end;

destructor TToken.Destroy;
begin
  FLocation.Free;
  FEndLocation.Free;
  inherited;
end;

function TToken.GetEndLocation: TLocation;
begin
  Result := FEndLocation;
end;

function TToken.GetLocation: TLocation;
begin
  Result := FLocation;
end;

function TToken.InspectTo(AIndentCount: Integer): string;
begin
  Result := Copy(GetEnumName(TypeInfo(TTokenType), Integer(TokenType)), 3) +
    ' |' + Text + '|';
  if (ParsedText <> '') then
    Result := Result + ', parsed=|' + ParsedText + '|';
end;

function TToken.WithTokenType(ATokenType: TTokenType): TToken;
begin
  Result := TToken.Create(ATokenType, Location, Text, ParsedText);
end;

end.
